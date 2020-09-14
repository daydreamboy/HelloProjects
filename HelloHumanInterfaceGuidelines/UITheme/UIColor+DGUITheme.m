//
//  UIColor+DGUITheme.m
//  
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "UIColor+DGUITheme.h"
#import "DGUIThemeManager.h"

@interface ThemeDynamicColor : UIColor
@property(nonatomic, copy) UIColor *(^themeProvider)(__kindof NSString * _Nullable colorKey, __kindof NSString * _Nullable defaultColorHexValue);
@property(nonatomic, copy, nullable) NSString *colorKey;
@property(nonatomic, copy, nullable) NSString *defaultHexValue;
@property(nonatomic, copy) NSString *currentThemeIdentifier;
@property(nonatomic, strong) UIColor *realColor;  ///  To optimize the dynamic color
@end


@implementation ThemeDynamicColor
- (void)set {
    [self.dgui_rawColor set];
}

- (void)setFill {
    [self.dgui_rawColor setFill];
}

- (void)setStroke {
    [self.dgui_rawColor setStroke];
}

- (BOOL)getWhite:(CGFloat *)white alpha:(CGFloat *)alpha {
    return [self.dgui_rawColor getWhite:white alpha:alpha];
}

- (BOOL)getHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha {
    return [self.dgui_rawColor getHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

- (BOOL)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    return [self.dgui_rawColor getRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)colorWithAlphaComponent:(CGFloat)alpha {
    return [self.dgui_rawColor colorWithAlphaComponent:alpha];
}

- (CGColorRef)CGColor {
    CGColorRef colorRef = [UIColor colorWithCGColor:self.dgui_rawColor.CGColor].CGColor;
    return colorRef;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *result = [self.dgui_rawColor methodSignatureForSelector:aSelector];
    return result;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.dgui_rawColor];
}

- (id)copyWithZone:(NSZone *)zone {
    ThemeDynamicColor *color = [[self class] allocWithZone:zone];
    color.themeProvider = self.themeProvider;
    color.colorKey = self.colorKey;
    return color;
}

- (BOOL)isEqual:(id)object {
    return self == object;
}

- (NSUInteger)hash {
    return (NSUInteger)self.themeProvider;
}

@dynamic dgui_isDynamicColor;

- (UIColor *)dgui_rawColor {
    if([self.currentThemeIdentifier isEqualToString:DGUIThemeManager.sharedManager.currentThemeIdentifier] && self.realColor) {
        return self.realColor;
    } else {
        NSString *identifier = DGUIThemeManager.sharedManager.currentThemeIdentifier;
        UIColor *color  = nil;
        if(self.themeProvider) {
            color = self.themeProvider(self.colorKey, self.defaultHexValue);
        }
        self.currentThemeIdentifier = identifier;
        self.realColor = color ? color : [UIColor clearColor];
        return self.realColor.dgui_rawColor;
    }
}

- (BOOL)isDynamicColor {
    return !!self.themeProvider;
}

@end




@implementation UIColor (DGUITheme)

+ (UIColor *)dgui_colorWithThemeProvider:(UIColor * _Nonnull (^)(__kindof NSString * _Nullable, __kindof NSString * _Nullable))provider colorKey:(__kindof NSString * _Nullable)colorKey defaultColorHexValue:(__kindof NSString * _Nullable)defaultHexValue {
    ThemeDynamicColor *color = ThemeDynamicColor.new;
    color.themeProvider = provider;
    color.colorKey = colorKey;
    color.defaultHexValue = defaultHexValue;
    return color;
}


- (BOOL)dgui_isDynamicColor {
    if ([self respondsToSelector:@selector(isDynamicColor)]) {
        return self.isDynamicColor;
    }
    return NO;
}


- (UIColor *)dgui_rawColor {
    return self;
}

@end
