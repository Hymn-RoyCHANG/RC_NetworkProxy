//
//  RC_JSON.m
//
//  Created by Roy CHANG on 2020/1/2.
//  Copyright © 2020 Roy CHANG. All rights reserved.
//

#import "RC_JSON.h"

@implementation RC_JSON

#pragma mark - ======== override super ========

- (void)dealloc{
    
    _data = nil;
#if DEBUG
    NSLog(@"\n'%@' send '%@'", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
}

- (instancetype)init{
    
    id data = nil;
    return [self initWithData:data];
}

#pragma mark - ======== property setter / getter ========

#pragma mark - ======== private method ========

- (void)rc_parseData:(id)data{
    
    _type = RC_JSON_Type_None;
    _data = nil;

    if(!data){

        return;
    }

    if([data isKindOfClass:[NSDictionary class]]){

        _data = [NSDictionary dictionaryWithDictionary:((NSDictionary*)data)];
        _type = RC_JSON_Type_Dictionary;
        return;
    }

    NSData *json_data = nil;
    if([data isKindOfClass:[NSData class]]){

        json_data = (NSData*)data;
    }
    else if([data isKindOfClass:[NSString class]]){

        NSString *str = (NSString*)data;
        json_data = [str dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if(!json_data){
        
        return;
    }

    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingMutableContainers error:&error];
    if(error || !result){
        
        return;
    }
    
    _data = result;
    if([result isKindOfClass:[NSDictionary class]]){
        
        _type = RC_JSON_Type_Dictionary;
    }
    else if([result isKindOfClass:[NSArray class]]){
        
        _type = RC_JSON_Type_Array;
    }
}

#pragma mark - ======== public method ========

- (instancetype)initWithData:(nonnull id)data{
    
    if(self = [super init]){
        
        [self rc_parseData:data];
    }
    
    return self;
}

+ (instancetype)rc_JSONWithData:(nonnull id)data{
    
    return [[self alloc] initWithData:data];
}

- (NSArray *)rc_JSONArray{

    if(RC_JSON_Type_Array != self.type || !self.data/* || ![self.data isKindOfClass:[NSArray class]]*/){

        return nil;
    }

    return self.data;
}

- (NSDictionary *)rc_JSONDictionary{

    if(RC_JSON_Type_Dictionary != self.type || !self.data/* || ![self.data isKindOfClass:[NSDictionary class]]*/){

        return nil;
    }

    return self.data;
}

#pragma mark - ======== delegate method ========


@end
