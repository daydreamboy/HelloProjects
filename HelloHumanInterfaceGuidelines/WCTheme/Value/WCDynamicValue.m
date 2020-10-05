//
//  WCDynamicValue.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicValue.h"
#import <objc/runtime.h>

const NSNotificationName WCDynamicValueDidChangeNotification = @"WCDynamicValueDidChangeNotification";
const NSString *WCDynamicValueChangeNotificationUserInfoProvider = @"WCDynamicValueChangeNotificationUserInfoProvider";
const NSString *WCDynamicValueChangeNotificationUserInfoProviderName = @"WCDynamicValueChangeNotificationUserInfoProviderName";

@interface WCDynamicValue ()

@property (nonatomic, assign, readwrite) BOOL boolValue;
@property (nonatomic, assign, readwrite) char charValue;
@property (nonatomic, assign, readwrite) double doubleValue;
@property (nonatomic, assign, readwrite) float floatValue;
@property (nonatomic, assign, readwrite) int intValue;
@property (nonatomic, assign, readwrite) NSInteger integerValue;
@property (nonatomic, assign, readwrite) long long longLongValue;
@property (nonatomic, assign, readwrite) long longValue;
@property (nonatomic, assign, readwrite) short shortValue;
@property (nonatomic, assign, readwrite) unsigned char unsignedCharValue;
@property (nonatomic, assign, readwrite) NSUInteger unsignedIntegerValue;
@property (nonatomic, assign, readwrite) unsigned int unsignedIntValue;
@property (nonatomic, assign, readwrite) unsigned long long unsignedLongLongValue;
@property (nonatomic, assign, readwrite) unsigned long unsignedLongValue;
@property (nonatomic, assign, readwrite) unsigned short unsignedShortValue;

@property (nonatomic, copy, readwrite) NSString *stringValue;

@property (nonatomic, assign, readwrite) CGPoint pointValue;
@property (nonatomic, assign, readwrite) CGSize sizeValue;
@property (nonatomic, assign, readwrite) CGRect rectValue;
@property (nonatomic, assign, readwrite) UIEdgeInsets insetValue;

@property (nonatomic, weak, readwrite) id host;
@property (nonatomic, strong, readwrite, nullable) WCDynamicValue *defaultValue;
@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, copy, readwrite, nullable) WCValueDidChangeBlockType valueDidChangeBlock;
- (instancetype)initWithHost:(id)host defaultValue:(WCDynamicValue *)defaultValue key:(NSString *)key valueDidChangeBlock:(nullable WCValueDidChangeBlockType)valueDidChangeBlock;
@end

@implementation WCDynamicValue

static void * const kAssociatedKeyDynamicValue = (void *)&kAssociatedKeyDynamicValue;

+ (instancetype)valueWithBool:(BOOL)value {
    WCDynamicValue *object = [[WCDynamicValue alloc] init];
    object.boolValue = value;
    
    return object;
}

+ (instancetype)valueWithChar:(char)value {
    WCDynamicValue *object = [[WCDynamicValue alloc] init];
    object.charValue = value;
    
    return object;
}

+ (instancetype)valueWithDouble:(double)value {
    WCDynamicValue *object = [[WCDynamicValue alloc] init];
    object.doubleValue = value;
    
    return object;
}

+ (BOOL)setDynamicValueWithHost:(id)host defaultValue:(WCDynamicValue *)defaultValue forKey:(NSString *)key valueDidChangeBlock:(nullable WCValueDidChangeBlockType)valueDidChangeBlock forceReplace:(BOOL)forceReplace {
    if (!host || ![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([key isKindOfClass:[NSString class]] && key.length == 0) {
        return NO;
    }
    
    if (forceReplace) {
        WCDynamicValue *dynamicValue = objc_getAssociatedObject(host, kAssociatedKeyDynamicValue);
        dynamicValue = [[WCDynamicValue alloc] initWithHost:self defaultValue:defaultValue key:key valueDidChangeBlock:valueDidChangeBlock];
        objc_setAssociatedObject(host, kAssociatedKeyDynamicValue, dynamicValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        WCDynamicValue *dynamicValue = objc_getAssociatedObject(host, kAssociatedKeyDynamicValue);
        if (dynamicValue) {
            return NO;
        }
        
        dynamicValue = [[WCDynamicValue alloc] initWithHost:host defaultValue:defaultValue key:key valueDidChangeBlock:valueDidChangeBlock];
        objc_setAssociatedObject(host, kAssociatedKeyDynamicValue, dynamicValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return YES;
}

- (instancetype)initWithHost:(id)host defaultValue:(WCDynamicValue *)defaultValue key:(NSString *)key valueDidChangeBlock:(nullable WCValueDidChangeBlockType)valueDidChangeBlock {
    self = [super init];
    if (self) {
        _host = host;
        _defaultValue = defaultValue;
        _key = key;
        _valueDidChangeBlock = valueDidChangeBlock;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWCDynamicValueDidChangeNotification:) name:WCDynamicValueDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WCDynamicValueDidChangeNotification object:nil];
}

#pragma mark - NSNotification

- (void)handleWCDynamicValueDidChangeNotification:(NSNotification *)notification {
    id<WCDynamicValueProvider> provider = notification.userInfo[WCDynamicValueChangeNotificationUserInfoProvider];
    NSString *providerName = notification.userInfo[WCDynamicValueChangeNotificationUserInfoProviderName];
    
    WCDynamicValue *value = [provider valueWithProviderName:providerName forKey:self.key];
    
    if ([value isKindOfClass:[WCDynamicValue class]]) {
        !self.valueDidChangeBlock ?: self.valueDidChangeBlock(self.host, value);
    }
}

@end
