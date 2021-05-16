//
//  KeyedSubscriptingObject.m
//  Tests
//
//  Created by wesley_chen on 2019/5/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "KeyedSubscriptingObject.h"

@interface KeyedSubscriptingObject ()
@property (nonatomic, strong) NSMutableDictionary *internalDictionary;
@end

@implementation KeyedSubscriptingObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _internalDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (nullable id)objectForKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        return _internalDictionary[key];
    }
    
    return nil;
}

- (void)setObject:(nullable id)object forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        _internalDictionary[key] = object;
    }
}

@end
