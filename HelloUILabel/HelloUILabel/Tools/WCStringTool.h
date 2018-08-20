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
+ (CGSize)textSizeWithSingleLineString:(NSString *)string attributes:(NSDictionary *)attributes;

// numberOfLines = 0
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0);
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0);

// numberOfLines > 0
+ (CGSize)textSizeWithFixedLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font numberOfLines:(NSUInteger)numberOfLines mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0);
@end
