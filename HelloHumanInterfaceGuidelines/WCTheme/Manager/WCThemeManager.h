//
//  WCThemeManager.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/10/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WCDynamicFontProvider;
@protocol WCDynamicColorProvider;
@protocol WCDynamicValueProvider;

@interface WCThemeManager : NSObject

+ (BOOL)registerFontProviders:(NSDictionary<NSString *, id<WCDynamicFontProvider>> *)fontProviders;
+ (BOOL)registerColorProviders:(NSDictionary<NSString *, id<WCDynamicColorProvider>> *)colorProviders;
+ (BOOL)registerValueProviders:(NSDictionary<NSString *, id<WCDynamicValueProvider>> *)valueProviders;

@end

NS_ASSUME_NONNULL_END
