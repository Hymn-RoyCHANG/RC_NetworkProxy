//
//  RC_HTTPRequest.h
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RC_HTTPResponse;


/// http method(usually we only use GET and POST...)
typedef NS_ENUM(NSInteger, RC_HTTPRequestMethod){
    
    /// unknown
    RC_HTTPRequestMethod_NONE = -1,
    /// GET http method
    RC_HTTPRequestMethod_GET = 1,
    /// POST http method
    RC_HTTPRequestMethod_POST,
};


/**************** http url maker ****************/


#define RC_HTTPURL(host_,api_) \
[RC_HTTPURLMaker rc_makeWithHost:(host_) api:(api_)]


@interface RC_HTTPURLMaker : NSObject

/**
    request url maker
    @discussion splice api to the host, e.g. http://aa.bb.com/cc/dd, the 'host' is 'http://aa.bb.com' and the 'api' is '/cc/dd'
 */
+ (NSString *)rc_makeWithHost:(nonnull NSString *)host api:(nullable NSString *)api;

@end



/**************** http response data parser ****************/


/// response data parser delegate
@protocol RC_HTTPResponseDataParser <NSObject>

@optional

/**
    final response data parsed from raw data returned by server
    @param rawData response raw data
    @param httpResponse original http url response
    @return final result
 */
- (RC_HTTPResponse *)rc_responseFromRawData:(id)rawData originalHTTPResponse:(nullable NSHTTPURLResponse *)httpResponse;

@end


/**************** http request ****************/


@interface RC_HTTPRequest : NSObject

- (instancetype)initWithURL:(nonnull NSString *)url method:(RC_HTTPRequestMethod)method parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary<NSString*, NSString*> *)headers NS_DESIGNATED_INITIALIZER;

+ (instancetype)rc_requestWithURL:(nonnull NSString *)url method:(RC_HTTPRequestMethod)method parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary<NSString*, NSString*> *)headers;

+ (instancetype)rc_POSTRequestWithURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary<NSString*, NSString*> *)headers;

+ (instancetype)rc_GETRequestWithURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary<NSString*, NSString*> *)headers;

+ (instancetype)rc_POSTRequestWithURL:(nonnull NSString *)url;

+ (instancetype)rc_GETRequestWithURL:(nonnull NSString *)url;

/**
    the delegate that parse response raw data
 */
@property (nonatomic, weak) id<RC_HTTPResponseDataParser> dataParser;

@property (nonatomic, copy) NSString *url;

/**
    http method
 */
@property (nonatomic, readonly) RC_HTTPRequestMethod method;

/// not copy
@property (nullable, nonatomic, strong) NSDictionary *parameters;

/// not copy
@property (nullable, nonatomic, strong) NSDictionary<NSString*, NSString*> *headers;

/**
     pre-request hook white-list flag that means do not prevent networking request
 */
@property (nonatomic, assign, getter=isWhiteList) BOOL whiteList;

/**
    http method string
 */
- (NSString *)rc_HTTPMethod;

@end

NS_ASSUME_NONNULL_END
