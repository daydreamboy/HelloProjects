//
//  WCDynamicValueManager.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDynamicValue.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCDynamicValueManager : NSObject

@property (nonatomic, strong, readonly) NSArray<NSString *> *valueProviderNames;
@property (nonatomic, copy, readonly, nullable) NSString *currentValueProviderName;
@property (nonatomic, strong, readonly, nullable) id<WCDynamicValueProvider> currentValueProvider;

+ (instancetype)sharedManager;

#pragma mark - Value

#pragma mark > Change Value Provider

- (BOOL)setCurrentValueProviderName:(NSString *)currentProviderName;
- (BOOL)setCurrentValueProviderName:(NSString *)currentValueProviderName persistent:(BOOL)persistent postNotification:(BOOL)postNotification;

#pragma mark > Register Value Provider

- (BOOL)registerDynamicValueProvider:(id<WCDynamicValueProvider>)dynamicValueProvider forName:(NSString *)name;
- (BOOL)unregisterDynamicValueProvider:(id<WCDynamicValueProvider>)dynamicValueProvider;
- (BOOL)unregisterDynamicValueProviderForName:(NSString *)name;

#pragma mark > Set Value

- (BOOL)setDynamicValueWithDefaultValue:(WCDynamicValue *)defaultValue forKey:(NSString *)key attachToObject:(id)object valueDidChangeBlock:(nullable WCValueDidChangeBlockType)valueDidChangeBlock;

- (WCDynamicValue *)dynamicValueWithDefaultValue:(WCDynamicValue *)defaultValue forKey:(NSString *)key attachToObject:(nullable id)object valueDidChangeBlock:(nullable WCValueDidChangeBlockType)valueDidChangeBlock;

@end

#pragma mark - Utility Macros

/**
 Set Dynamic Value
 
 @param label the UILabel object
 @param key the key for the keyed value
 @param defaultValue_ the default value if the provider not find the keyed value
 @param block the callback when its value did change. The block type see WCValueDidChangeBlockType
 
 @return YES if set successfully, NO if not
 
 @discussion This method will initialize the label's value
 */
#define WCThemeSetDynamicValue(object, key, defaultValue, block) \
[[WCDynamicValueManager sharedManager] setDynamicValueWithDefaultValue:(defaultValue) forKey:(key) attachToObject:(object) valueDidChangeBlock:(block)]

/**
 Get Dynamic Value
 
 */
#define WCThemeGetDynamicValue(object, key, defaultValue, block) \
[[WCDynamicValueManager sharedManager] dynamicValueWithDefaultValue:(defaultValue) forKey:(key) attachToObject:(object) valueDidChangeBlock:(block)]

NS_ASSUME_NONNULL_END
