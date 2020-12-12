//
//  WCDynamicValueManager.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicValueManager.h"

#define kWCThemeValueProviderName @"WCThemeValue"

@interface WCDynamicValueManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<WCDynamicValueProvider>> *valueProviders;
@property (nonatomic, strong, readwrite, nullable) id<WCDynamicValueProvider> currentValueProvider;
@end

@implementation WCDynamicValueManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WCDynamicValueManager *sInstance;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCDynamicValueManager alloc] init];
    });
    
    return sInstance;
}

#pragma mark > Register Value Provider

- (BOOL)registerDynamicValueProvider:(id<WCDynamicValueProvider>)dynamicValueProvider forName:(NSString *)name {
    if (![dynamicValueProvider respondsToSelector:@selector(valueWithProviderName:forKey:)]) {
        return NO;
    }
    
    if (![name isKindOfClass:[NSString class]] || ([name isKindOfClass:[NSString class]] && name.length == 0)) {
        return NO;
    }
    
    if (self.valueProviders[name]) {
        return NO;
    }
    
    self.valueProviders[name] = dynamicValueProvider;
    
    if ([_currentValueProviderName isEqualToString:name]) {
        _currentValueProvider = dynamicValueProvider;
    }
    
    return YES;
}

- (BOOL)unregisterDynamicValueProvider:(id<WCDynamicValueProvider>)dynamicValueProvider {
    if (!dynamicValueProvider) {
        return NO;
    }
    
    __block NSString *keyToRemove = nil;
    [self.valueProviders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<WCDynamicValueProvider>  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj == dynamicValueProvider) {
            keyToRemove = key;
            *stop = YES;
        }
    }];
    
    if (keyToRemove) {
        [self.valueProviders removeObjectForKey:keyToRemove];
        return YES;
    }
    
    return NO;
}

- (BOOL)unregisterDynamicValueProviderForName:(NSString *)name {
    if (![name isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (self.valueProviders[name]) {
        [self.valueProviders removeObjectForKey:name];
        return YES;
    }
    
    return NO;
}

- (NSArray<NSString *> *)valueProviderNames {
    return [[self.valueProviders allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark > Change Value Provider

- (BOOL)setCurrentValueProviderName:(NSString *)currentValueProviderName {
    if (![currentValueProviderName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([currentValueProviderName isKindOfClass:[NSString class]] && currentValueProviderName.length == 0) {
        return NO;
    }
    
    if (![[self.valueProviders allKeys] containsObject:currentValueProviderName]) {
        return NO;
    }
    
    _currentValueProviderName = currentValueProviderName;
    _currentValueProvider = self.valueProviders[currentValueProviderName];
    
    NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
    userInfoM[WCDynamicValueChangeNotificationUserInfoProvider] = _currentValueProvider;
    userInfoM[WCDynamicValueChangeNotificationUserInfoProviderName] = _currentValueProviderName;
    
    [[NSUserDefaults standardUserDefaults] setObject:_currentValueProviderName forKey:kWCThemeValueProviderName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WCDynamicValueDidChangeNotification object:nil userInfo:userInfoM];
    
    return YES;
}

#pragma mark > Set Value

- (BOOL)setDynamicValueWithDefaultValue:(WCDynamicValue *)defaultValue forKey:(NSString *)key attachToObject:(id)object valueDidChangeBlock:(nullable WCValueDidChangeBlockType)valueDidChangeBlock {
    
    [WCDynamicValue setDynamicValueWithHost:object defaultValue:defaultValue forKey:key valueDidChangeBlock:valueDidChangeBlock forceReplace:NO];
    
    return YES;
}

- (WCDynamicValue *)dynamicValueWithDefaultValue:(WCDynamicValue *)defaultValue forKey:(NSString *)key attachToObject:(nullable id)object valueDidChangeBlock:(nullable WCValueDidChangeBlockType)valueDidChangeBlock {
    WCDynamicValue *value = [self.currentValueProvider valueWithProviderName:self.currentValueProviderName forKey:key];
    
    if (object) {
        [WCDynamicValue setDynamicValueWithHost:object defaultValue:defaultValue forKey:key valueDidChangeBlock:valueDidChangeBlock forceReplace:NO];
    }
    
    return value ?: defaultValue;
}

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        _valueProviders = [NSMutableDictionary dictionary];
        _currentValueProviderName = [[NSUserDefaults standardUserDefaults] stringForKey:kWCThemeValueProviderName];
    }
    return self;
}

@end
