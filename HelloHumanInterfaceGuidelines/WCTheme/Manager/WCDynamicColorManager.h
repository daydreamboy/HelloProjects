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

+ (UIColor *)dynamicColorWithDefaultColor:(UIColor *)defaultColor forKey:(NSString *)key attachToObject:(nullable id)object colorWillChangeBlock:(nullable WCColorWillChangeBlockType)colorWillChangeBlock;

+ (BOOL)addColorDidChangeObserver:(id)observer callback:(nullable void (^)(id<WCDynamicColorProvider> colorProvider, NSString *colorProviderName))callback;
+ (BOOL)removeColorDidChangeObserver:(id)observer;

#define WCThemeGetDynamicColor(object, key, defaultColor, block) \
[[WCDynamicColorManager sharedManager] dynamicColorWithDefaultColor:(defaultColor) forKey:(key) attachToObject:(object) colorWillChangeBlock:(block)]

@end

NS_ASSUME_NONNULL_END
