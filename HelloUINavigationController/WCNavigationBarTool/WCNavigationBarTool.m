//
//  WCNavigationBarTool.m
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/4/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCNavigationBarTool.h"
#import <objc/runtime.h>

#ifndef SYSTEM_VERSION_LESS_THAN
#define SYSTEM_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#endif

#define SYNTHESIZE_ASSOCIATED_OBJ(getterName, setterName, type)                                                 \
- (void)setterName:(type)object {                                                                               \
    if (object) {                                                                                               \
        objc_setAssociatedObject(self, @selector(getterName), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);       \
    }                                                                                                           \
}                                                                                                               \
- (type)getterName {                                                                                            \
    return objc_getAssociatedObject(self, @selector(getterName));                                               \
}

@interface UINavigationBar (wnbt)
@property (nonatomic, strong) UIView *wnbt_hairLine;
@property (nonatomic, strong) UIView *wnbt_shadowImageView;
@end

@implementation UINavigationBar (wnbt)
@dynamic wnbt_hairLine;
@dynamic wnbt_shadowImageView;

SYNTHESIZE_ASSOCIATED_OBJ(wnbt_hairLine, setWnbt_hairLine, UIView *);
SYNTHESIZE_ASSOCIATED_OBJ(wnbt_shadowImageView, setWnbt_shadowImageView, UIView *);

@end

@implementation UIImage (wnbt)
+ (UIImage *)wnbt_imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f / [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

// abbr. wnbt
@implementation WCNavigationBarTool

+ (void)setNavBar:(UINavigationBar *)navigationBar hairLineColor:(nullable UIColor *)color {
    
    if (![navigationBar isKindOfClass:[UINavigationBar class]] || (color && ![color isKindOfClass:[UIColor class]])) {
        return;
    }
    
    if (color) {
        CGFloat alpha = CGColorGetAlpha(color.CGColor);
        if (alpha == (CGFloat)0.0) {
            if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
                UIImageView *shadowImageView = [self findShadowImageViewWithView:navigationBar];
                if (shadowImageView) {
                    navigationBar.wnbt_shadowImageView = shadowImageView;
                    navigationBar.wnbt_shadowImageView.hidden = YES;
                }
                else {
                    NSLog(@"[%@] not found shadowImageView", NSStringFromClass(self));
                }
            }
            else {
                [navigationBar setShadowImage:[UIImage new]];
            }
        }
        else {
            if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
                UIImageView *shadowImageView = [self findShadowImageViewWithView:navigationBar];
                if (shadowImageView) {
                    UIView *line = [[UIView alloc] initWithFrame:shadowImageView.bounds];
                    line.backgroundColor = color;
                    [shadowImageView addSubview:line];
                    
                    navigationBar.wnbt_hairLine = line;
                    navigationBar.wnbt_shadowImageView = shadowImageView;
                    navigationBar.wnbt_shadowImageView.hidden = NO;
                }
                else {
                    NSLog(@"[%@] not found shadowImageView", NSStringFromClass(self));
                }
            }
            else {
                [navigationBar setShadowImage:[UIImage wnbt_imageWithColor:color]];
            }
        }
    }
    else {
        if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
            navigationBar.wnbt_shadowImageView.hidden = NO;
            [navigationBar.wnbt_hairLine removeFromSuperview];
        }
        else {
            navigationBar.shadowImage = nil;
        }
    }
}

+ (void)setNavBar:(UINavigationBar *)navigationBar transparent:(BOOL)transparent {
    
    if (![navigationBar isKindOfClass:[UINavigationBar class]]) {
        return;
    }
    
    navigationBar.barTintColor = nil;
    navigationBar.translucent = YES;
    
    if (transparent) {
        [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        navigationBar.shadowImage = [UIImage new];
    }
    else {
        [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        navigationBar.shadowImage = nil;
    }
}

#pragma mark - Private Methods

// @see https://stackoverflow.com/a/19227158
+ (UIImageView *)findShadowImageViewWithView:(UIView *)view {
    if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in [view subviews]) {
        return [self findShadowImageViewWithView:subview];
    }
    
    return nil;
}

@end
