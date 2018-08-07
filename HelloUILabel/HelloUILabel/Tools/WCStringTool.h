//
//  WCStringTool.h
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/23.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCStringTool : NSObject
@end

@interface WCStringTool ()
+ (CGSize)textSizeWithSingleLineString:(NSString *)string font:(UIFont *)font;
+ (CGSize)textSizeWithMultiLineString:(NSString *)string font:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes;
@end
