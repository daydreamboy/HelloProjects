//
//  WCDynamicColorManager.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCDynamicColor.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The manager for manage a set of dynamic colors
 */
@interface WCDynamicColorManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - Color

@property (nonatomic, strong, readonly) NSArray<NSString *> *colorProviderNames;
@property (nonatomic, copy, readonly, nullable) NSString *currentColorProviderName;
@property (nonatomic, strong, readonly, nullable) id<WCDynamicColorProvider> currentColorProvider;

#pragma mark > Change Color Provider

- (BOOL)setCurrentColorProviderName:(NSString *)currentProviderName;

#pragma mark > Register Font Provider

- (BOOL)registerDynamicColorProvider:(id<WCDynamicColorProvider>)dynamicColorProvider forName:(NSString *)name;
- (BOOL)unregisterDynamicColorProvider:(id<WCDynamicColorProvider>)dynamicColorProvider;
- (BOOL)unregisterDynamicColorProviderForName:(NSString *)name;

#pragma mark - Create Color

/**
 Get a dynamic color
 
 @param defaultColor the default color
 @param key the key
 @param object the object which observe the color change event
 @param colorWillChangeBlock the color change event
 
 @return The dynamic color which is an opaque type. If the key not exists, return the defaultColor
 @discussion This method is wrapped by WCThemeGetDynamicColor macro. You should use WCThemeGetDynamicColor macro instead of this method.
 */
+ (UIColor *)dynamicColorWithDefaultColor:(UIColor *)defaultColor forKey:(NSString *)key attachToObject:(nullable id)object colorWillChangeBlock:(nullable WCColorWillChangeBlockType)colorWillChangeBlock;

#pragma mark - Color Change Observer

+ (BOOL)addColorDidChangeObserver:(id)observer callback:(nullable void (^)(id<WCDynamicColorProvider> colorProvider, NSString *colorProviderName))callback;
+ (BOOL)removeColorDidChangeObserver:(id)observer;

#pragma mark - Utility Macro

/**
 Get a dynamic color
 
 @param object the object which observe the color change event
 @param key the key
 @param defaultColor the default color
 @param block the color change event. The block type is WCColorWillChangeBlockType
 
 @return The dynamic color which is an opaque type. If the key not exists, return the defaultColor
 */
#define WCThemeGetDynamicColor(object, key, defaultColor, block) \
[[WCDynamicColorManager sharedManager] dynamicColorWithDefaultColor:(defaultColor) forKey:(key) attachToObject:(object) colorWillChangeBlock:(block)]

@end

NS_ASSUME_NONNULL_END
