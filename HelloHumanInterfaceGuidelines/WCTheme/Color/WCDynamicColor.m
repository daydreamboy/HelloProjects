//
//  WCDynamicColor.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicColor.h"
#import <objc/runtime.h>
#import "WCDynamicInternalColor_Internal.h"

// >= `12.0`
#ifndef IOS12_OR_LATER
#define IOS12_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"12.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

const NSNotificationName WCDynamicColorDidChangeNotification = @"WCDynamicColorDidChangeNotification";
const NSString *WCDynamicColorChangeNotificationUserInfoProvider = @"WCDynamicColorChangeNotificationUserInfoProvider";
const NSString *WCDynamicColorChangeNotificationUserInfoProviderName = @"WCDynamicColorChangeNotificationUserInfoProviderName";

@interface WCDynamicColor ()
@property (nonatomic, weak, readonly) id host;
@property (nonatomic, strong, readonly, nullable) UIColor *defaultColor;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly, nullable) WCColorWillChangeBlockType colorWillChangeBlock;
- (instancetype)initWithHost:(id)host defaultColor:(UIColor *)defaultColor key:(NSString *)key colorWillChangeBlock:(nullable WCColorWillChangeBlockType)colorWillChangeBlock;
@end

@implementation WCDynamicColor

static void * const kAssociatedKeyDynamicColor = (void *)&kAssociatedKeyDynamicColor;

+ (BOOL)setDynamicColorWithHost:(id)host defaultColor:(UIColor *)defaultColor forKey:(NSString *)key colorWillChangeBlock:(nullable WCColorWillChangeBlockType)colorWillChangeBlock forceReplace:(BOOL)forceReplace {
    if (!host || ![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([key isKindOfClass:[NSString class]] && key.length == 0) {
        return NO;
    }
    
    if (forceReplace) {
        WCDynamicColor *dynamicColor = objc_getAssociatedObject(host, kAssociatedKeyDynamicColor);
        dynamicColor = [[WCDynamicColor alloc] initWithHost:self defaultColor:defaultColor key:key colorWillChangeBlock:colorWillChangeBlock];
        objc_setAssociatedObject(host, kAssociatedKeyDynamicColor, dynamicColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        WCDynamicColor *dynamicColor = objc_getAssociatedObject(host, kAssociatedKeyDynamicColor);
        if (dynamicColor) {
            return NO;
        }
        
        dynamicColor = [[WCDynamicColor alloc] initWithHost:host defaultColor:defaultColor key:key colorWillChangeBlock:colorWillChangeBlock];
        objc_setAssociatedObject(host, kAssociatedKeyDynamicColor, dynamicColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return YES;
}

- (instancetype)initWithHost:(id)host defaultColor:(UIColor *)defaultColor key:(NSString *)key colorWillChangeBlock:(nullable WCColorWillChangeBlockType)colorWillChangeBlock {
    self = [super init];
    if (self) {
        _host = host;
        _defaultColor = defaultColor;
        _key = key;
        _colorWillChangeBlock = colorWillChangeBlock;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWCDynamicColorDidChangeNotification:) name:WCDynamicColorDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WCDynamicColorDidChangeNotification object:nil];
}

#pragma mark - NSNotification

- (void)handleWCDynamicColorDidChangeNotification:(NSNotification *)notification {
    id<WCDynamicColorProvider> provider = notification.userInfo[WCDynamicColorChangeNotificationUserInfoProvider];
    NSString *providerName = notification.userInfo[WCDynamicColorChangeNotificationUserInfoProviderName];
    
    if (![self.host isKindOfClass:[UIView class]]) {
        return;
    }
    
    UIColor *color = [provider colorWithProviderName:providerName forKey:self.key];
    if (![color isKindOfClass:[UIColor class]]) {
        return;
    }
    
    BOOL shouldProcess = YES;
    if ([self.host isKindOfClass:[UILabel class]]) {
        if (self.colorWillChangeBlock) {
            shouldProcess = self.colorWillChangeBlock(self.host, color);
        }
        
        if (shouldProcess) {
            UILabel *label = (UILabel *)self.host;
            if (IOS12_OR_LATER) {
                [label setNeedsDisplay];
            }
            else {
                // Note: iOS 11-, use setNeedsDisplay not refresh textColor, must set it again by setTextColor:
                if ([WCDynamicInternalColor checkIsDynamicInternalColor:label.textColor]) {
                    label.textColor = [[WCDynamicInternalColor alloc] initWithDefaultColor:color key:nil];
                }
            }
        }
    }
    else if ([self.host isKindOfClass:[UITextView class]]) {
        if (self.colorWillChangeBlock) {
            shouldProcess = self.colorWillChangeBlock(self.host, color);
        }
        
        if (shouldProcess) {
            UITextView *textView = (UITextView *)self.host;
            [textView setNeedsDisplay];
        }
    }
    else if ([self.host isKindOfClass:[UITextField class]]) {
        if (self.colorWillChangeBlock) {
            shouldProcess = self.colorWillChangeBlock(self.host, color);
        }
        
        if (shouldProcess) {
            UITextField *textField = (UITextField *)self.host;
            [textField setNeedsDisplay];
        }
    }
    else {
        if (self.colorWillChangeBlock) {
            shouldProcess = self.colorWillChangeBlock(self.host, color);
        }
        
        if (shouldProcess) {
            UIView *view = (UIView *)self.host;
            view.backgroundColor = color;
        }
    }
}

@end

