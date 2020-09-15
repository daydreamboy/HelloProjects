//
//  WCDynamicInternalColor.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicInternalColor.h"
#import "WCDynamicInternalColor_Internal.h"
#import "WCDynamicColorManager.h"

@implementation WCDynamicInternalColor

- (instancetype)initWithDefaultColor:(UIColor *)defaultColor key:(NSString *)key {
    self = [super init];
    if (self) {
        _defaultColor = defaultColor;
        _key = key;
    }
    return self;
}

#pragma mark -

- (void)set {
    [[self actualColor] set];
}

- (void)setFill {
    [[self actualColor] setFill];
}

- (void)setStroke {
    [[self actualColor] setStroke];
}

- (BOOL)getWhite:(CGFloat *)white alpha:(CGFloat *)alpha {
    return [[self actualColor] getWhite:white alpha:alpha];
}

- (BOOL)getHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha {
    return [[self actualColor] getHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

- (BOOL)getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
    return [[self actualColor] getRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)colorWithAlphaComponent:(CGFloat)alpha {
    return [[self actualColor] colorWithAlphaComponent:alpha];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _defaultColor;
}

// Note:
// Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -hash not defined for the UIColor <WCDynamicInternalColor: 0x6000003c2940>; need to first convert colorspace.'
- (NSUInteger)hash {
    return [_defaultColor hash];
}

// Note: 
// Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -isEqual: not defined for the UIColor <WCDynamicInternalColor: 0x60000099afd0>; need to first convert colorspace.'
- (BOOL)isEqual:(id)object {
    return self == object;
}

- (CGColorRef)CGColor {
    return [self actualColorRef];;
}

- (id)copyWithZone:(NSZone *)zone {
    WCDynamicInternalColor *color = [[self class] allocWithZone:zone];
    color.key = self.key;
    color.defaultColor = self.defaultColor;
    
    return color;
}

- (CGColorRef)actualColorRef {
    if (self.isDynamicColor) {
        id<WCDynamicColorProvider> provider = [[WCDynamicColorManager sharedManager] currentColorProvider];
        NSString *providerName = [[WCDynamicColorManager sharedManager] currentColorProviderName];
        
        UIColor *color = [provider colorWithProviderName:providerName forKey:self.key];
        return color ? color.CGColor : self.defaultColor.CGColor;
    }
    else {
        return self.defaultColor.CGColor;
    }
}

- (UIColor *)actualColor {
    return [UIColor colorWithCGColor:[self actualColorRef]];
}

- (BOOL)isDynamicColor {
    return YES;
}

@end
