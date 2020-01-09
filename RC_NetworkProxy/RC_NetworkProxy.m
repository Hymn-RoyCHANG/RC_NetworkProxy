//
//  RC_NetworkProxy.m
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import "RC_NetworkProxy.h"
#import "RC_NetworkProtocol_Imp.h"

RC_ResponseDataHandler g_rc_response_data_handler__ = nil;
RC_RequestHookHandler g_rc_request_hook_handler__ = nil;

@implementation RC_NetworkProxy

#pragma mark - ======== private method ========

+ (void)rc_network:(id<RC_NetworkProtocol>)network sendRequest:(RC_HTTPRequest *)request completionHandler:(RC_NetworkProxyHandler)handler{
    
    [network rc_sendRequest:request completionHandler:^(BOOL success, id _Nullable responseData, NSURLResponse * _Nullable URLResponse, NSError * _Nullable error) {
        
        if(!handler){
            
            return;
        }
        
        if(success){
            
            RC_HTTPResponse *resp = nil;
            
            /// delegate has the highest priority
            if(request.dataParser && [request.dataParser respondsToSelector:@selector(rc_responseFromRawData:originalHTTPResponse:)]){
                
                NSHTTPURLResponse *url_resp = [URLResponse isKindOfClass:[NSHTTPURLResponse class]] ? ((NSHTTPURLResponse*)URLResponse) : nil;
                resp = [request.dataParser rc_responseFromRawData:responseData originalHTTPResponse:url_resp];
            }
            
            if(!resp){
                
                if(g_rc_response_data_handler__){
                    /// perform handler if no delegate
                    resp = g_rc_response_data_handler__(responseData);
                }
                
                if(!resp){
                    /// finally create a instance if no parsers
                    resp = [RC_HTTPResponse rc_response];
                    resp.rawData = responseData;
                }
            }
            
            resp.request = request;
            handler(resp);
        }
        else{
            
            NSString *code = error ? ([NSString stringWithFormat:@"%ld", (long)[error code]]) : RC_HTTP_Default_ErrorCode;
            RC_HTTPResponse *resp = [RC_HTTPResponse rc_responseWithMessage:[error localizedDescription] code:code];
            resp.request = request;
            resp.rawData = responseData;
            
            handler(resp);
        }
    }];
}

#pragma mark - ======== public method ========

+ (void)rc_registerRequestHookHandler:(RC_RequestHookHandler)handler{
    
    if(handler){
        
        g_rc_request_hook_handler__ = [handler copy];
    }
}

+ (void)rc_unregisterRequestHookHandler{
    
    g_rc_request_hook_handler__ = nil;
}

+ (void)rc_registerResponseDataHandler:(RC_ResponseDataHandler)handler{
    
    if(handler){
        
        g_rc_response_data_handler__ = [handler copy];
    }
}

+ (void)rc_unregisterResponseDataHandler{
    
    g_rc_response_data_handler__ = nil;
}

+ (id<RC_NetworkProtocol>)rc_sendRequest:(RC_HTTPRequest *)request completionHandler:(RC_NetworkProxyHandler)handler{
    
    id<RC_NetworkProtocol> net = [AFHTTPSessionManager rc_sharedProtocol];
    if(!request.isWhiteList && g_rc_request_hook_handler__){
        
        g_rc_request_hook_handler__(request, ^(RC_HTTPRequest *req){
            
            [self rc_network:net sendRequest:req completionHandler:handler];
        });
    }
    else{
        
        [self rc_network:net sendRequest:request completionHandler:handler];
    }
    
    return net;
}

+ (id<RC_NetworkProtocol>)rc_sendOnceRequest:(RC_HTTPRequest *)request completionHandler:(RC_NetworkProxyHandler)handler{
    
    id<RC_NetworkProtocol> net = [AFHTTPSessionManager rc_protocol];
    if(!request.isWhiteList && g_rc_request_hook_handler__){
        
        g_rc_request_hook_handler__(request, ^(RC_HTTPRequest *req){
            
            [self rc_network:net sendRequest:req completionHandler:handler];
        });
    }
    else{
        
        [self rc_network:net sendRequest:request completionHandler:handler];
    }
    
    return net;
}

@end
