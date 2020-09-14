//
//  UIColor+HexCategory.h
//  
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexCategory)
// #RBG, #RGBA, #RRGGBB, #RRGGBBAA,
+ (UIColor *)dg_colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
