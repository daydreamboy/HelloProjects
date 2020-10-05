//
//  WCThemeManager.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/10/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCThemeManager.h"
#import "WCDynamicColorManager.h"
#import "WCDynamicFontManager.h"
#import "WCDynamicValueManager.h"

typedef NS_ENUM(NSUInteger, WCThemeProviderType) {
    WCThemeProviderTypeFont,
    WCThemeProviderTypeColor,
    WCThemeProviderTypeValue,
};

@implementation WCThemeManager

+ (BOOL)registerProviders:(NSDictionary<NSString *, id> *)providers forType:(WCThemeProviderType)type {
    if (![providers isKindOfClass:[NSDictionary class]] || providers.count == 0) {
        return NO;
    }
    
    switch (type) {
        case WCThemeProviderTypeFont: {
            [providers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<WCDynamicFontProvider>  _Nonnull obj, BOOL * _Nonnull stop) {
                [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:obj forName:key];
            }];
            return YES;
        }
        case WCThemeProviderTypeColor: {
            [providers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<WCDynamicColorProvider>  _Nonnull obj, BOOL * _Nonnull stop) {
                [[WCDynamicColorManager sharedManager] registerDynamicColorProvider:obj forName:key];
            }];
            return YES;
        }
        case WCThemeProviderTypeValue: {
            [providers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<WCDynamicValueProvider>  _Nonnull obj, BOOL * _Nonnull stop) {
                [[WCDynamicValueManager sharedManager] registerDynamicValueProvider:obj forName:key];
            }];
            return YES;
        }
        default:
            break;
    }
    
    return NO;
}

+ (BOOL)registerFontProviders:(NSDictionary<NSString *, id<WCDynamicFontProvider>> *)fontProviders {
    return [self registerProviders:fontProviders forType:WCThemeProviderTypeFont];
}

+ (BOOL)registerColorProviders:(NSDictionary<NSString *, id<WCDynamicColorProvider>> *)colorProviders {
    return [self registerProviders:colorProviders forType:WCThemeProviderTypeColor];
}

+ (BOOL)registerValueProviders:(NSDictionary<NSString *, id<WCDynamicValueProvider>> *)valueProviders {
    return [self registerProviders:valueProviders forType:WCThemeProviderTypeValue];
}

@end
