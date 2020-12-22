//
//  WCPropertyDictionary.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2020/12/22.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCPropertyDictionary.h"
#import <objc/runtime.h>

static void *WCPropertyDictionary_KVOContext = &WCPropertyDictionary_KVOContext;

@interface WCPropertyDictionary () {
    NSMutableDictionary *_storage;
}
@end

@implementation WCPropertyDictionary


- (instancetype)init {
    self = [super init];
    if (self) {
        _storage = [NSMutableDictionary dictionary];
        
        NSArray<NSString *> *properties = [[self class] propertyNamesWithClass:[self class]];
        for (NSString *name in properties) {
            [self addObserver:self forKeyPath:name options:NSKeyValueObservingOptionNew context:WCPropertyDictionary_KVOContext];
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    return [_storage copy];
}

- (NSMutableDictionary *)toMutableDictionary {
    return [_storage mutableCopy];
}

#pragma mark -

- (void)dealloc {
    NSArray<NSString *> *properties = [[self class] propertyNamesWithClass:[self class]];
    for (NSString *name in properties) {
        [self removeObserver:self forKeyPath:name context:WCPropertyDictionary_KVOContext];
    }
}

// @see https://stackoverflow.com/a/38594823
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self && context == WCPropertyDictionary_KVOContext) {
        id value = change[NSKeyValueChangeNewKey];
        _storage[keyPath] = value;
    }
}

#pragma mark - Utility

+ (NSArray<NSString *> *)propertyNamesWithClass:(Class)clz {
    if (clz == NULL) {
        return @[];
    }
    
    static NSMutableDictionary *sCache;
    if (!sCache) {
        sCache = [NSMutableDictionary dictionary];
    }
    
    NSString *key = NSStringFromClass(clz);
    if (key.length == 0) {
        return @[];
    }
    
    NSArray *propertyNames = sCache[key];
    if (!propertyNames) {
        // @see https://stackoverflow.com/a/20665145
        NSMutableArray *arrM = [NSMutableArray array];
        unsigned int numberOfProperties;
        objc_property_t *propertyArray = class_copyPropertyList(clz, &numberOfProperties);
        for (NSUInteger i = 0; i < numberOfProperties; i++) {
            objc_property_t property = propertyArray[i];
            if (property != NULL) {
                const char *cString = property_getName(property);
                if (cString != NULL) {
                    NSString *name = [[NSString alloc] initWithUTF8String:cString];
                    [arrM addObject:name];
                }
            }
        }
        
        propertyNames = arrM;
        sCache[key] = arrM;
    }
    
    return [propertyNames copy];
}

@end
