//
//  RC_NetworkProxy.h
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RC_NetworkProtocol_Help.h"


NS_ASSUME_NONNULL_BEGIN

/// proxy request handler
typedef void (^RC_NetworkProxyHandler)(RC_HTTPResponse *response);

/**
    global reponse data handler
    @param data raw data returned by server
 */
typedef RC_HTTPResponse* _Nonnull (^RC_ResponseDataHandler)(id data);

/// request handler callback
typedef void (^RC_RequestHookCompletionHandler)(RC_HTTPRequest *request);

/// request hook handler
typedef void (^RC_RequestHookHandler)(RC_HTTPRequest *request, RC_RequestHookCompletionHandler completion);


/**
    networking proxy
    @seealso 'RC_NetworkProtocol_Imp.h'
 */
@interface RC_NetworkProxy : NSObject

/**
    register global request hook handler
    @note you must call 'rc_unregisterRequestHookHandler' when the handler is no longer used
 */
+ (void)rc_registerRequestHookHandler:(RC_RequestHookHandler)handler;
+ (void)rc_unregisterRequestHookHandler;

/**
    register global server response data handler
    @param handler data handler
    @discussion method 'rc_registerResponseDataHandler' and 'rc_unregisterResponseDataHandler' are nested calls. @seealso RC_HTTPRequest's property 'dataParser', you can use it to parse the specified data, its priority is higher than global data handler
    @note you must call 'rc_unregisterResponseDataHandler' when the handler is no longer used
 */
+ (void)rc_registerResponseDataHandler:(RC_ResponseDataHandler)handler;
+ (void)rc_unregisterResponseDataHandler;


/**************** send request ****************/

/**
    sending request by using shared protocol
 */
+ (id<RC_NetworkProtocol>)rc_sendRequest:(RC_HTTPRequest *)request completionHandler:(RC_NetworkProxyHandler)handler;

/**
   sending request by using non-shared protocol
*/
+ (id<RC_NetworkProtocol>)rc_sendOnceRequest:(RC_HTTPRequest *)request completionHandler:(RC_NetworkProxyHandler)handler;

@end

NS_ASSUME_NONNULL_END
