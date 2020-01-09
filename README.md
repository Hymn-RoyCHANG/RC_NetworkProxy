# RC_NetworkProxy
RC_NetworkProxy is a simple network proxy protocol for sending 'POST / 'GET' and so on
RC_NetworkProxy是一个用来发送‘POST’、‘GET’等的简单网络‘代理’协议

## what does it mean

you can use but not only ‘AFNetworking’ to implement the protocol. currently, it implements the protocol using version 3.1.2 of 'AFNetworking'.

### how to custom the network proxy protoco 
```ruby
@interface SomeProtocol_Imp : SomeSuperObj  <RC_NetworkProtocol>
//... your code here...
@end
```

## how to use
2 ways to use:
### Podfile
1. setp 1
```ruby
pod 'RC_NetworkPorxy', '~> 0.1.4'
```
2. step 2
```ruby
#import <RC_NetworkPorxy/RC_NetworkPorxy.h>
```
### add files to your project
download the source code files and add them to your project
```ruby
#import "RC_NetworkPorxy.h"
```
### usage
>\
```objc
NSString *host = @"http:/xxx.yyy.zzz.com";
NSString *api = @"/add/bookmark/";
/// full string is: http:/xxx.yyy.zzz.com//add/bookmark/
NSString *url = RC_HTTPURL(host, api);
/// or
/// NSString *url = @"http:/xxx.yyy.zzz.com/aaa/bbb/cccc"

NSDictionary<NSString*, NSString*> *headers = @{"xxx" : @"yyy"};
NSDictionary *params = @{@"param1" : @"value1", @"param2" : @"value2"};
/// here is http post method
RC_HTTPRequest *request = [RC_HTTPRequest rc_POSTRequestWithURL:url parameters:params headers:headers];

[RC_NetworkProxy rc_sendRequest:request completionHandler:^(RC_HTTPResponse * _Nonnull response) {
    
    /// default block is in multi-thread
    NSLog(@"\nmain-thread: %@\n", ([NSThread isMainThread] ? @"YES" : @"NO"));
    NSLog(@"%@", [response description]);
}];
```
