//
//  UIImage+WCFont.h
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (WCFont)

+ (UIImage *)tbfont_imageWithFont:(nullable UIFont *)font text:(nullable NSString *)text color:(nullable UIColor *)color;

+ (UIImage *)tbfont_iconfontImageWithName:(NSString *)name fontSize:(CGFloat)size color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
