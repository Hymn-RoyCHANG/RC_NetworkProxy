//
//  RC_HTTPRequest.m
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import "RC_HTTPRequest.h"

typedef NSString* RC_HTTPMethod;

const RC_HTTPMethod RC_HTTPMethod_POST = @"POST";
const RC_HTTPMethod RC_HTTPMethod_GET = @"GET";
const RC_HTTPMethod RC_HTTPMethod_PUT = @"PUT";
const RC_HTTPMethod RC_HTTPMethod_DELETE = @"DELETE";
const RC_HTTPMethod RC_HTTPMethod_PATCH = @"PATCH";


/**************** http url maker ****************/


@implementation RC_HTTPURLMaker : NSObject

+ (BOOL)rc_validateString:(NSString *)str{
    
    if(!str){
        
        return NO;
    }
    
    if(![str isKindOfClass:[NSString class]]){
        
        return NO;
    }
    
    return (1 > [str length] ? NO : YES);
}

+ (NSString *)rc_makeWithHost:(NSString *)host api:(NSString *)api{
    
    if(![self rc_validateString:host]){
        
        return nil;
    }
    
    if([self rc_validateString:api]){
        
        return [[NSURL URLWithString:api relativeToURL:[NSURL URLWithString:host]] absoluteString];
    }
    else{
        
        return [[NSURL URLWithString:host] absoluteString];
    }
}

@end


/**************** http request ****************/


@implementation RC_HTTPRequest

#pragma mark - ======== override super ========

- (void)dealloc{
    
    self.headers = nil;
    self.parameters = nil;
    self.dataParser = nil;
    
#if DEBUG
    NSLog(@"\n'%@' send '%@'", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
}

- (instancetype)init{

    NSString *url = nil;
    return [self initWithURL:url method:RC_HTTPRequestMethod_NONE parameters:nil headers:nil];
}

#pragma mark - ======== property setter / getter ========

#pragma mark - ======== private method ========

#pragma mark - ======== public method ========

- (instancetype)initWithURL:(nonnull NSString *)url method:(RC_HTTPRequestMethod)method parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary *)headers{

    if(self = [super init]){
        
        _url = url;
        _method = method;
        _parameters = parameters;
        _headers = headers;
    }

    return self;
}

+ (instancetype)rc_requestWithURL:(nonnull NSString *)url method:(RC_HTTPRequestMethod)method parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary *)headers{

    return [[self alloc] initWithURL:url method:method parameters:parameters headers:headers];
}

+ (instancetype)rc_POSTRequestWithURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary *)headers{

    return [[self alloc] initWithURL:url method:RC_HTTPRequestMethod_POST parameters:parameters headers:headers];
}

+ (instancetype)rc_GETRequestWithURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary *)headers{

    return [[self alloc] initWithURL:url method:RC_HTTPRequestMethod_GET parameters:parameters headers:headers];
}

+ (instancetype)rc_POSTRequestWithURL:(nonnull NSString *)url{

    return [self rc_POSTRequestWithURL:url parameters:nil headers:nil];
}

+ (instancetype)rc_GETRequestWithURL:(nonnull NSString *)url{

    return [self rc_GETRequestWithURL:url parameters:nil headers:nil];
}

- (NSString *)rc_HTTPMethod{
    
    NSString *str = nil;
    
    switch(self.method){
            
        case RC_HTTPRequestMethod_GET:{str = RC_HTTPMethod_GET;}break;
        case RC_HTTPRequestMethod_POST:{str = RC_HTTPMethod_POST;}break;
        default:break;
    }
    
    return str;
}

#pragma mark - ======== delegate method ========

@end
