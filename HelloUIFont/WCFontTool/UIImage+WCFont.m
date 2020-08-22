//
//  UIImage+WCFont.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UIImage+WCFont.h"
#import "WCIconFont.h"

@implementation UIImage (WCFont)

+ (UIImage *)tbfont_imageWithFont:(UIFont *)font text:(NSString *)text color:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.text = text;
    label.textColor = color;
    [label sizeToFit];
    
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, 0);
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)tbfont_iconfontImageWithName:(NSString *)name fontSize:(CGFloat)size color:(UIColor *)color{
    NSString *text = [TBIconFont iconFontUnicodeWithName:name];
    UIFont *iconFont = [TBIconFont iconFontWithSize:size];
    return [self tbfont_imageWithFont:iconFont text:text color:color];
}

@end
