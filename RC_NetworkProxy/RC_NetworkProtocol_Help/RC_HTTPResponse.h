//
//  RC_HTTPResponse.h
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RC_HTTPRequest;


/**************** http response ****************/


@interface RC_HTTPResponse : NSObject

- (instancetype)initWithMessage:(nullable NSString *)message code:(nullable NSString *)code NS_DESIGNATED_INITIALIZER;

+ (instancetype)rc_responseWithMessage:(nullable NSString *)message code:(nullable NSString *)code;

+ (instancetype)rc_responseWithMessage:(nullable NSString *)message;

+ (instancetype)rc_response;

/// success or fail, default is NO
@property (nonatomic, assign, getter=isSucceed) BOOL success;

/// url session data task, default is nil
@property (nullable, nonatomic, strong) NSURLSessionDataTask *task;

/// response raw data, default is nil
@property (nullable, nonatomic, strong) id rawData;

/// dictionary if 'rawData' can be converted to json, otherwise nil
@property (nullable, nonatomic, strong) NSDictionary *jsonResult;

/// http status code
@property (nonatomic, copy) NSString *code;

/// response message
@property (nonatomic, copy) NSString *message;

/// original request instance, take ownship by response
@property (nullable, nonatomic, strong) RC_HTTPRequest *request;

@end

NS_ASSUME_NONNULL_END
