//
//  WCDynamicColor.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicColor.h"
#import <objc/runtime.h>

const NSNotificationName WCDynamicColorDidChangeNotification = @"WCDynamicColorDidChangeNotification";
const NSString *WCDynamicColorDidChangeNotificationUserInfoProvider = @"WCDynamicColorDidChangeNotificationUserInfoProvider";
const NSString *WCDynamicColorDidChangeNotificationUserInfoProviderName = @"WCDynamicColorDidChangeNotificationUserInfoProviderName";

@interface WCDynamicColor ()
@property (nonatomic, weak, readonly) id host;
@property (nonatomic, strong, readonly, nullable) UIColor *defaultColor;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly, nullable) WCColorDidChangeBlockType colorDidChangeBlock;
- (instancetype)initWithHost:(id)host defaultColor:(UIColor *)defaultColor key:(NSString *)key colorDidChangeBlock:(nullable WCColorDidChangeBlockType)colorDidChangeBlock;
@end

@implementation WCDynamicColor

static void * const kAssociatedKeyDynamicColor = (void *)&kAssociatedKeyDynamicColor;

+ (BOOL)setDynamicColorWithHost:(id)host defaultColor:(UIColor *)defaultColor forKey:(NSString *)key colorDidChangeBlock:(nullable WCColorDidChangeBlockType)colorDidChangeBlock forceReplace:(BOOL)forceReplace {
    if (!host || ![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([key isKindOfClass:[NSString class]] && key.length == 0) {
        return NO;
    }
    
    if (forceReplace) {
        WCDynamicColor *dynamicColor = objc_getAssociatedObject(host, kAssociatedKeyDynamicColor);
        dynamicColor = [[WCDynamicColor alloc] initWithHost:self defaultColor:defaultColor key:key colorDidChangeBlock:colorDidChangeBlock];
        objc_setAssociatedObject(host, kAssociatedKeyDynamicColor, dynamicColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        WCDynamicColor *dynamicColor = objc_getAssociatedObject(host, kAssociatedKeyDynamicColor);
        if (dynamicColor) {
            return NO;
        }
        
        dynamicColor = [[WCDynamicColor alloc] initWithHost:host defaultColor:defaultColor key:key colorDidChangeBlock:colorDidChangeBlock];
        objc_setAssociatedObject(host, kAssociatedKeyDynamicColor, dynamicColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return YES;
}

- (instancetype)initWithHost:(id)host defaultColor:(UIColor *)defaultColor key:(NSString *)key colorDidChangeBlock:(nullable WCColorDidChangeBlockType)colorDidChangeBlock {
    self = [super init];
    if (self) {
        _host = host;
        _defaultColor = defaultColor;
        _key = key;
        _colorDidChangeBlock = colorDidChangeBlock;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWCDynamicColorDidChangeNotification:) name:WCDynamicColorDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WCDynamicColorDidChangeNotification object:nil];
}

#pragma mark - NSNotification

- (void)handleWCDynamicColorDidChangeNotification:(NSNotification *)notification {
    id<WCDynamicColorProvider> provider = notification.userInfo[WCDynamicColorDidChangeNotificationUserInfoProvider];
    NSString *providerName = notification.userInfo[WCDynamicColorDidChangeNotificationUserInfoProviderName];
    
    if ([self.host isKindOfClass:[UIView class]]) {
        if ([self.host isKindOfClass:[UILabel class]]) {
            UIColor *color = [provider colorWithProviderName:providerName forKey:self.key];
            if (color) {
                UILabel *label = (UILabel *)self.host;
                [label setNeedsDisplay];
            }
        }
        else if ([self.host isKindOfClass:[UITextView class]]) {
            UIColor *color = [provider colorWithProviderName:providerName forKey:self.key];
            if (color) {
                UITextView *textView = (UITextView *)self.host;
                [textView setNeedsDisplay];
            }
        }
        else if ([self.host isKindOfClass:[UITextField class]]) {
            UIColor *color = [provider colorWithProviderName:providerName forKey:self.key];
            if (color) {
                UITextField *textField = (UITextField *)self.host;
                [textField setNeedsDisplay];
            }
        }
        else {
            UIColor *color = [provider colorWithProviderName:providerName forKey:self.key];
            if (color) {
                UIView *view = (UIView *)self.host;
                view.backgroundColor = color;
            }
        }
    }
}

@end

