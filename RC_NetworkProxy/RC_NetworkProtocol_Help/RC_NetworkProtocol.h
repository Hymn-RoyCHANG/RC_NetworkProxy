//
//  RC_NetworkProtocol.h
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#ifndef _RC_NETWORK_PROTOCOL_H_
#define _RC_NETWORK_PROTOCOL_H_

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RC_HTTPRequest;
@class RC_HTTPResponse;

/**
    networking protocol response handler
    @param success whether http request is successful
    @param responseData response data from server
    @param URLResponse url response, usually it's 'NSHTTPURLResponse' instance
    @param error error information
 */
typedef void (^RC_NetworkProtocolHandler)(BOOL success, id _Nullable responseData, NSURLResponse * _Nullable URLResponse, NSError * _Nullable error);

/**
    networking protocol
 */
@protocol RC_NetworkProtocol <NSObject>

@required

/**
    singleton protocol
 */
+ (id<RC_NetworkProtocol>)rc_sharedProtocol;

/**
    convenient protocol constructor
 */
+ (id<RC_NetworkProtocol>)rc_protocol;

/**
    add http header
 */
- (void)rc_addHTTPHeaders:(NSDictionary<NSString*, NSString*> *)headers;

/**
    send http request
 */
- (void)rc_sendRequest:(RC_HTTPRequest *)request completionHandler:(RC_NetworkProtocolHandler)handler;

@optional

/**
    set http timeout
 */
- (void)rc_setTimeout:(NSTimeInterval)timeout;

@end

NS_ASSUME_NONNULL_END

#endif /*_RC_NETWORK_PROTOCOL_H_*/
