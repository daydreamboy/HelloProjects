//
//  WCDynamicFont.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicFont.h"
#import <objc/runtime.h>

const NSNotificationName WCDynamicFontDidChangeNotification = @"WCDynamicFontDidChangeNotification";
const NSString *WCDynamicFontDidChangeNotificationUserInfoProvider = @"WCDynamicFontDidChangeNotificationUserInfoProvider";
const NSString *WCDynamicFontDidChangeNotificationUserInfoProviderName = @"WCDynamicFontDidChangeNotificationUserInfoProviderName";

@interface WCDynamicFont ()
@property (nonatomic, weak, readonly) id host;
@property (nonatomic, strong, readonly, nullable) UIFont *defaultFont;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly, nullable) WCFontDidChangeBlockType fontDidChangeBlock;
- (instancetype)initWithHost:(id)host defaultFont:(UIFont *)defaultFont key:(NSString *)key fontDidChangeBlock:(nullable WCFontDidChangeBlockType)fontDidChangeBlock;
@end

@implementation WCDynamicFont

static void * const kAssociatedKeyDynamicFont = (void *)&kAssociatedKeyDynamicFont;

+ (BOOL)setDynamicFontWithHost:(id)host defaultFont:(UIFont *)defaultFont forKey:(NSString *)key fontDidChangeBlock:(nullable WCFontDidChangeBlockType)fontDidChangeBlock forceReplace:(BOOL)forceReplace {
    if (!host || ![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([key isKindOfClass:[NSString class]] && key.length == 0) {
        return NO;
    }
    
    if (forceReplace) {
        WCDynamicFont *dynamicFont = objc_getAssociatedObject(host, kAssociatedKeyDynamicFont);
        dynamicFont = [[WCDynamicFont alloc] initWithHost:self defaultFont:defaultFont key:key fontDidChangeBlock:fontDidChangeBlock];
        objc_setAssociatedObject(host, kAssociatedKeyDynamicFont, dynamicFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        WCDynamicFont *dynamicFont = objc_getAssociatedObject(host, kAssociatedKeyDynamicFont);
        if (dynamicFont) {
            return NO;
        }
        
        dynamicFont = [[WCDynamicFont alloc] initWithHost:host defaultFont:defaultFont key:key fontDidChangeBlock:fontDidChangeBlock];
        objc_setAssociatedObject(host, kAssociatedKeyDynamicFont, dynamicFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return YES;
}

- (instancetype)initWithHost:(id)host defaultFont:(UIFont *)defaultFont key:(NSString *)key fontDidChangeBlock:(nullable WCFontDidChangeBlockType)fontDidChangeBlock {
    self = [super init];
    if (self) {
        _host = host;
        _defaultFont = defaultFont;
        _key = key;
        _fontDidChangeBlock = fontDidChangeBlock;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWCDynamicFontDidChangeNotification:) name:WCDynamicFontDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WCDynamicFontDidChangeNotification object:nil];
}

#pragma mark - NSNotification

- (void)handleWCDynamicFontDidChangeNotification:(NSNotification *)notification {
    id<WCDynamicFontProvider> provider = notification.userInfo[WCDynamicFontDidChangeNotificationUserInfoProvider];
    NSString *providerName = notification.userInfo[WCDynamicFontDidChangeNotificationUserInfoProviderName];
    
    if ([self.host isKindOfClass:[UILabel class]]) {
        UIFont *font = [provider fontWithProviderName:providerName forKey:self.key];
        
        if ([font isKindOfClass:[UIFont class]]) {
            UILabel *label = (UILabel *)self.host;
            label.font = font;
            !self.fontDidChangeBlock ?: self.fontDidChangeBlock(label, font);
        }
    }
}

@end
