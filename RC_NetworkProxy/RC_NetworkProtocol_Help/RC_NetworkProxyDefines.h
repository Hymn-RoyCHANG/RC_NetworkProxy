//
//  RC_NetworkProxyDefines.h
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#ifndef RC_NetworkProxyDefines_h
#define RC_NetworkProxyDefines_h

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const RC_HTTP_Default_SuccessCode;
FOUNDATION_EXTERN NSString *const RC_HTTP_Default_ErrorCode;
FOUNDATION_EXTERN const NSTimeInterval RC_HTTP_Default_Timeout;

#define RC_HTTP_Default_CompletionQueue \
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0UL)


#endif /* RC_NetworkProxyDefines_h */
