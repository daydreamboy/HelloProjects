//
//  WCNSObjectTool.m
//  HelloKeyValueObserving
//
//  Created by wesley_chen on 2018/9/25.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "WCNSObjectTool.h"

@implementation WCNSObjectTool

#pragma mark - Safe KVC

+ (nullable id)safeValueWithObject:(NSObject *)object forKey:(NSString *)key {
    return [WCNSObjectTool safeValueWithObject:object forKey:key typeClass:[NSObject class]];
}

+ (nullable id)safeValueWithObject:(NSObject *)object forKey:(NSString *)key typeClass:(Class)typeClass {
    if (![object isKindOfClass:[NSObject class]] || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    id returnValue = nil;
    @try {
        returnValue = [object valueForKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        if ([returnValue isKindOfClass:typeClass]) {
            return returnValue;
        }
        else {
            return nil;
        }
    }
}

@end
