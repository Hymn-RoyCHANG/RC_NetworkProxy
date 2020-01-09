//
//  RC_NetworkProtocol_Imp.m
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import "RC_NetworkProtocol_Imp.h"
#import <objc/runtime.h>

@interface NSString (RC_HTTP_NilOrEmpty)

@end

@implementation NSString (RC_HTTP_NilOrEmpty)

+ (BOOL)rc_isNilOrEmpty:(NSString *)str{
    
    if(!str){
        
        return YES;
    }
    
    if(![str isKindOfClass:[NSString class]]){
        
        return YES;
    }
    
    return (1 > [str length]);
}

@end


/**************** AFHTTPSessionManager - RC_SharedObjectFlag ****************/


static NSString *const RC_AF_NetWork_SharedObj_Flag = @"rc_af_shared_obj_flag";

@interface AFHTTPSessionManager (RC_SharedObjectFlag)

@property (nonatomic, assign, getter=isSharedObject) BOOL sharedObject;

@end

@implementation AFHTTPSessionManager (RC_SharedObjectFlag)

@dynamic sharedObject;

#pragma mark - ======== property setter / getter ========

- (void)setSharedObject:(BOOL)sharedObject{
    
    objc_setAssociatedObject(self, &RC_AF_NetWork_SharedObj_Flag, [NSNumber numberWithBool:sharedObject], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSharedObject{
    
    NSNumber *num = objc_getAssociatedObject(self, &RC_AF_NetWork_SharedObj_Flag);
    return [num boolValue];
}

@end


/**************** AFHTTPSessionManager - RC_NetworkProtocol ****************/


@implementation AFHTTPSessionManager (RC_NetworkProtocol)


#pragma mark - ======== private method ========

+ (AFHTTPSessionManager *)rc_makeAFHTTPSessionManager{

    AFSecurityPolicy *security = [AFSecurityPolicy defaultPolicy];//[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    security.validatesDomainName = NO;
    security.allowInvalidCertificates = YES;

    AFHTTPSessionManager *manager__ = [AFHTTPSessionManager manager];
    manager__.requestSerializer = [AFJSONRequestSerializer serializer];
    manager__.responseSerializer = [AFJSONResponseSerializer serializer];
    manager__.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain"]];
    //manager__.requestSerializer.HTTPShouldUsePipelining = YES;
    /// security policy
    //manager__.securityPolicy = security;
    /// request timeout
    manager__.requestSerializer.timeoutInterval = RC_HTTP_Default_Timeout;
    /// worker thread
    manager__.completionQueue = RC_HTTP_Default_CompletionQueue;
    
    /// shared object flag
    manager__.sharedObject = NO;

    return manager__;
}

#pragma mark - ======== delegate method ========

+ (id<RC_NetworkProtocol>)rc_sharedProtocol{
    
    static dispatch_once_t token;
    static AFHTTPSessionManager *http_manager__;
    
    dispatch_once(&token, ^{
        
        http_manager__ = [self rc_makeAFHTTPSessionManager];
        [http_manager__ setSharedObject:YES];
    });
    
    return http_manager__;
}

+ (id<RC_NetworkProtocol>)rc_protocol{
    
    return [AFHTTPSessionManager rc_makeAFHTTPSessionManager];
}

- (void)rc_addHTTPHeaders:(NSDictionary<NSString*, NSString*> *)headers{
    
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        
        [self.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
}

- (void)rc_sendRequest:(RC_HTTPRequest *)request completionHandler:(RC_NetworkProtocolHandler)handler{
    
    BOOL bStatus = NO;
    int iType = -1;
    NSString *error_msg = nil;//@"error occurred";
    __typeof(self) __weak weak_self = self;
    
    do{
        
        if(!request){
            
            error_msg = @"the request instance parameter can not be nil";
            iType = -2;
            break;
        }
        
        NSString *url_str = [request url];
        if([NSString rc_isNilOrEmpty:url_str]){
            
            error_msg = @"invalid request url";
            iType = -3;
            break;
        }
        
        NSString *method = [request rc_HTTPMethod];
        if(!method){
            
            error_msg = @"http method unknown";
            iType = -4;
            break;
        }
        
        [self rc_addHTTPHeaders:[request headers]];
        
        NSError *serializationError = nil;
        NSMutableURLRequest *req = [self.requestSerializer requestWithMethod:method URLString:url_str parameters:request.parameters error:&serializationError];
        if(serializationError || !req){
            
            error_msg = serializationError ? [serializationError localizedFailureReason] : @"failed to construct url request";
            iType = -5;
            break;
        }
        
        bStatus = YES;
        iType = 0;
        
        __block NSURLSessionDataTask *task = nil;
        task = [self dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull URLResponse, id _Nullable responseObject, NSError * _Nullable error) {
            
            __typeof(self) __strong strong_self = weak_self;
            
            if(handler){
                
                BOOL success = responseObject && !error;
                handler(success, responseObject, URLResponse, error);
            }
            
            if(!strong_self.isSharedObject){
                /// avoid memory leak
                [strong_self invalidateSessionCancelingTasks:NO];
            }
        }];
        
        [task resume];
    }while(0);
    
    if(!bStatus){
        
        if(handler){
            
            NSError *error = [NSError errorWithDomain:@"RC_NetworkProtocol_RequestError" code:iType userInfo:@{NSLocalizedFailureReasonErrorKey : error_msg ?: @"failed to send request"}];
            
            dispatch_async(self.completionQueue ?: RC_HTTP_Default_CompletionQueue, ^{
                
                handler(NO, nil, nil, error);
                
                if(!self.isSharedObject){
                    /// avoid memory leak
                    [self invalidateSessionCancelingTasks:NO];
                }
            });
        }
    }
}

- (void)rc_setTimeout:(NSTimeInterval)timeout{
    
    [self.requestSerializer setTimeoutInterval:timeout];
}

@end
