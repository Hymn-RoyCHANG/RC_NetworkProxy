//
//  RC_NetworkProtocol_Imp.h
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "RC_NetworkProtocol_Help.h"

NS_ASSUME_NONNULL_BEGIN

/**
    here the code is based on 'AFNetworking'
    @note dependent on 'AFNetworking', '~> 3.2.1'
 */
@interface AFHTTPSessionManager (RC_NetworkProtocol) <RC_NetworkProtocol>

@end

NS_ASSUME_NONNULL_END
