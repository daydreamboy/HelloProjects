//
//  UIColor+DGUITheme.h
//  
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ThemeDynamicColorProtocol <NSObject>
@property(nonatomic, strong, readonly) UIColor *dgui_rawColor;
@property(nonatomic, assign, readonly) BOOL dgui_isDynamicColor;
@optional
@property(nonatomic, assign, readonly) BOOL isDynamicColor;
@end

@interface UIColor (DGUITheme) <ThemeDynamicColorProtocol>


+ (UIColor *)dgui_colorWithThemeProvider:(UIColor * _Nonnull (^)(__kindof NSString * _Nullable, __kindof NSString * _Nullable))provider
                                colorKey:(__kindof NSString * _Nullable)colorKey
                    defaultColorHexValue:(__kindof NSString * _Nullable)defaultHexValue;

@end

NS_ASSUME_NONNULL_END
