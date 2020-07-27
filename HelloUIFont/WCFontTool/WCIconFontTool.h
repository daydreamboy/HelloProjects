//
//  WCIconFontTool.h
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCIconFontTool : NSObject

#pragma mark - Load Icon in Runtime

+ (BOOL)registerIconFontWithFilePath:(NSString *)filePath fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error;
+ (BOOL)registerIconFontWithData:(NSData *)data fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error;

+ (nullable UIFont *)fontWithName:(NSString *)fontName fontSize:(CGFloat)fontSize;

#pragma mark - Icon Image

+ (UIImage *)imageWithIconFontName:(NSString *)iconFontName text:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

#pragma mark - Icon Text

+ (nullable NSString *)unicodePointStringWithIconText:(NSString *)iconText;

@end

NS_ASSUME_NONNULL_END
