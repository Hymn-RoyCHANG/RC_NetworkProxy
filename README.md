# RC_NetworkProxy
**RC_NetworkProxy** is a simple network proxy protocol for sending **POST** / **GET** and so on
\
**RC_NetworkProxy**是一个用来发送**POST**、**GET**等的简单网络‘代理’协议

## 1. What does it mean

You can use but not only **‘AFNetworking’** to implement the protocol. Currently, it implements the protocol using version **3.1.2** of **'AFNetworking'**.

### 1.1 How to custom the network proxy protocol
```objc
/// the network proxy protocol
@protocol RC_NetworkProtocol <NSObject>

@required
...
@optional
...
@end

/// -------- custom your protocol --------

@interface SomeProtocol_Imp : SomeSuperObj <RC_NetworkProtocol>
//... your code here...
@end

/// implementation
@implementation SomeProtocol_Imp

/// -------- required --------

+ (id<RC_NetworkProtocol>)rc_sharedProtocol{

    /// your code here
    return your_shared_protocol_instance;
}

+ (id<RC_NetworkProtocol>)rc_protocol{
    
    /// your code here
    return your_protocol_instance;
}

- (void)rc_addHTTPHeaders:(NSDictionary<NSString*, NSString*> *)headers{
    
    /// your code here
}

- (void)rc_sendRequest:(RC_HTTPRequest *)request completionHandler:(RC_NetworkProtocolHandler)handler{

    /// your code here
}

/// -------- optional --------

- (void)rc_setTimeout:(NSTimeInterval)timeout{
    /// your code here
}

@end
```

## 2. How to use
Two ways to use:
### 2.1 Podfile
```ruby
...
pod 'RC_NetworkPorxy', '~> 0.1.5'
....
pod install
```
### 2.2 Add files to your project
download the source code files and add them to your project
```objc
#import "RC_NetworkPorxy.h"
```
### 2.3 Usage
```objc
/// url
NSString *host = @"http:/xxx.yyy.zzz.com";
NSString *api = @"/add/bookmark/";
/// full string is: http:/xxx.yyy.zzz.com//add/bookmark/
NSString *url = RC_HTTPURL(host, api);
/// or
/// NSString *url = @"http:/xxx.yyy.zzz.com/aaa/bbb/cccc";

/// http headers
NSDictionary<NSString*, NSString*> *headers = @{"xxx" : @"yyy"};

/// request body / parameters
NSDictionary *params = @{@"param1" : @"value1", @"param2" : @"value2"};

/// here is http post method
RC_HTTPRequest *request = [RC_HTTPRequest rc_POSTRequestWithURL:url parameters:params headers:headers];

/// sending request
[RC_NetworkProxy rc_sendRequest:request completionHandler:^(RC_HTTPResponse * _Nonnull response) {
    
    /// default block is in multi-thread
    NSLog(@"\nmain-thread: %@\n", ([NSThread isMainThread] ? @"YES" : @"NO"));
    NSLog(@"%@", [response description]);
}];
```
## 3. Parsing the response data
### 3.1 Global response data parser
Register the global data parser before you use it. After that the data parser works for every http request, unless you specify the data parsing delegate for a certain http request (***[view section 3.2](https://github.com/Hymn-RoyCHANG/RC_NetworkProxy#32-the-specified-data-parser)***).
```objc
//// sample code
[RC_NetworkProxy rc_registerResponseDataHandler:^RC_HTTPResponse * _Nonnull(id  _Nonnull data) {
    /// assume that the aim data structure is dictionary
    RC_JSON *json = [RC_JSON rc_JSONWithData:data];
    NSDictionary *dic = [json rc_JSONDictionary];
    NSString *code = [dic objectForKey:@"code"];
    NSString *msg = [dic objectForKey:@"message"];
    NSDictionary *result = [dic objectForKey:@"result"];

    RC_HTTPResponse *resp = [RC_HTTPResponse rc_responseWithMessage:msg code:code];
    /// success or failure ， required
    resp.success = [code isEqualToString:@"200"];
   /// the data we want to process next
    resp.jsonResult = result;

    return resp;
}];
```
### 3.2 The specified data parser
you can use the **'RC_HTTPResponseDataParser'** to parse the response data for a certain request. It has higher priority than the global response data parser

```objc
@protocol RC_HTTPResponseDataParser <NSObject>

@optional

- (RC_HTTPResponse *)rc_responseFromRawData:(id)rawData originalHTTPResponse:(nullable NSHTTPURLResponse *)httpResponse;

@end

/// --------

@interface RC_HTTPRequest : NSObject
...
@property (nonatomic, weak) id<RC_HTTPResponseDataParser> dataParser;
...
@end
```
## 4. Global Hook
by registering the global hook you can do something before sending a request

### 4.1 Register the global hook
```objc
/// sample code
[RC_NetworkProxy rc_registerRequestHookHandler:^(RC_HTTPRequest * _Nonnull request, RC_RequestHookCompletionHandler  _Nonnull completion) {

    /// e.g. we change the original 'request' instance
    RC_HTTPRequest *new_request = [xxx_obj makeSomeChange:request];
    if(completion){
        
        completion(new_request);
    }
}];
```
### 4.2 Hook White list
```objc
@interface RC_HTTPRequest : NSObject
...
@property (nonatomic, assign, getter=isWhiteList) BOOL whiteList;
...
@end
```
**Note: the preprocessing of the request will be ignored when property ‘whiteList’ is ‘YES’**

# License
**RC_NetworkProxy** is available under the MIT license. See the [LICENSE](https://github.com/Hymn-RoyCHANG/RC_NetworkProxy/blob/master/LICENSE) file for more info.
