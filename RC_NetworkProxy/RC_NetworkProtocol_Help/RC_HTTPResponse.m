//
//  RC_HTTPResponse.m
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import "RC_HTTPResponse.h"
#import "RC_HTTPRequest.h"
#import "RC_NetworkProxyDefines.h"

@implementation RC_HTTPResponse

#pragma mark - ======== override super ========

- (void)dealloc{
    
    self.rawData = nil;
    self.task = nil;
    self.request = nil;
    self.jsonResult = nil;
    
#if DEBUG
    NSLog(@"\n'%@' send '%@'", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
}

- (instancetype)init{
    
    self->_success = NO;
    return [self initWithMessage:nil code:RC_HTTP_Default_ErrorCode];
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"\n<%@: %p>:\n{\n url = %@,\n method = %@,\n success = %@,\n code = %@,\n message = %@,\n raw = %@\n}\n", NSStringFromClass([self class]), self, [self.request url], [self.request rc_HTTPMethod], (self.isSucceed ? @"YES" : @"NO"), self.code, self.message, [self.rawData description]];
}

#pragma mark - ======== property setter / getter ========

#pragma mark - ======== private method ========

#pragma mark - ======== public method ========

- (instancetype)initWithMessage:(nullable NSString *)message code:(nullable NSString *)code{

    if(self = [super init]){
        
        _code = code;
        _message = message;
        _success = NO;
    }

    return self;
}

+ (instancetype)rc_responseWithMessage:(nullable NSString *)message code:(nullable NSString *)code{

    return [[self alloc] initWithMessage:message code:code];
}

+ (instancetype)rc_responseWithMessage:(nullable NSString *)message{

    return [[self alloc] initWithMessage:message code:RC_HTTP_Default_ErrorCode];
}

+ (instancetype)rc_response{
    
    return [[self alloc] initWithMessage:nil code:RC_HTTP_Default_ErrorCode];
}

#pragma mark - ======== delegate method ========

@end
