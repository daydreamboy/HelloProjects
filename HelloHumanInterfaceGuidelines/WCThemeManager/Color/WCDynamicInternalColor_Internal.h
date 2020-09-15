//
//  WCDynamicInternalColor+Internal.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicInternalColor.h"
#import "WCDynamicColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCDynamicInternalColor ()
@property (nonatomic, assign, readwrite, getter=isDynamicColor) BOOL dynamicColor;
@property (nonatomic, strong, readwrite) UIColor *defaultColor;
@property (nonatomic, copy, readwrite, nullable) NSString *key;

- (instancetype)initWithDefaultColor:(UIColor *)defaultColor key:(nullable NSString *)key;

+ (BOOL)checkIsDynamicInternalColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
