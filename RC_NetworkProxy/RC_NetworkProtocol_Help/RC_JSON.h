//
//  RC_JSON.h
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
    json data type
 */
typedef NS_ENUM(NSInteger, RC_JSON_Type){
    
    /// unknown
    RC_JSON_Type_None = 0,
    /// json array
    RC_JSON_Type_Array = 1,
    /// json dictionary
    RC_JSON_Type_Dictionary = 2,
};

/**
    json data object
 */
@interface RC_JSON : NSObject

- (instancetype)initWithData:(nonnull id)data NS_DESIGNATED_INITIALIZER;

+ (instancetype)rc_JSONWithData:(nonnull id)data;

/**
    maybe is nil when failed to convert
 */
@property (nonatomic, readonly) id data;
@property (nonatomic, readonly) RC_JSON_Type type;

/**
    json array data
 */
- (NSArray *)rc_JSONArray;

/**
    json dictionary data
 */
- (NSDictionary *)rc_JSONDictionary;

@end

NS_ASSUME_NONNULL_END
