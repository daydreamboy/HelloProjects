//
//  WCStringTool.h
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCStringTool : NSObject

@end

@interface WCStringTool ()
+ (nullable NSArray<NSValue *> *)rangesOfSubstringWithString:(NSString *)string substring:(NSString *)substring;
+ (CGSize)textSizeWithMultipleLineString:(NSString *)string width:(CGFloat)width font:(UIFont *)font mode:(NSLineBreakMode)lineBreakMode widthToFit:(BOOL)widthToFit NS_AVAILABLE_IOS(8_0);
@end
