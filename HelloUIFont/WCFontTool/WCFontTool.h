//
//  WCFontTool.h
//  HelloUIFont
//
//  Created by wesley_chen on 2018/11/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCFontGlyphInfo : NSObject

@property (nonatomic, assign, readonly) UTF16Char unicode;
@property (nonatomic, assign, readonly) CGFontIndex index;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *character;

@end

@interface WCFontInfo : NSObject
@property (nonatomic, strong, readonly) NSArray<WCFontGlyphInfo *> *glyphInfos;
@end


@interface WCFontTool : NSObject

#pragma mark - Get Font Names

/**
 The table for font name information

 @return the table which is key-value paired. The key is font family name, and the value is the array of font names under the family name
 @note 1. The key of the table is not sorted, but the value (NSArray) is sorted.
       2. If the family name has no font name, the value is empty array.
 */
+ (NSDictionary<NSString *, NSArray *> *)allFontNamesTable;

/**
 All font family names which is sorted

 @return the array of font family names
 */
+ (NSArray<NSString *> *)allFontFamilyNames;

/**
 All font names which is sorted

 @return the array of font names
 */
+ (NSArray<NSString *> *)allFontNames;

#pragma mark - Get Font

/**
 Get font with the formatted string, e.g. @"Verdana-BoldItalic 20"

 @param formattedName the format is @"(font name) (font size)" separated by space
 @return the font. Return nil if font name is wrong or font size is not a number.
 */
+ (nullable UIFont *)fontWithFormattedName:(NSString *)formattedName;

/**
 Only get the system font with the formatted string,

 @param formattedName the format, e.g. @"System-Bold 20", @"System 20", @"System-Italic 20"
 @return the system font
 */
+ (nullable UIFont *)systemFontWithFormattedName:(NSString *)formattedName;

+ (nullable UIFont *)fontWithName:(NSString *)fontName fontSize:(CGFloat)fontSize;

#pragma mark - Load Font in Runtime

+ (BOOL)registerFontWithFilePath:(NSString *)filePath fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error;
+ (BOOL)registerFontWithData:(NSData *)data fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error;

+ (BOOL)unregisterIconFontWithName:(NSString *)name error:(NSError * _Nullable * _Nullable)error completionHandler:(void (^)(NSError *error))completionHandler;

#pragma mark - Icon Image

+ (UIImage *)imageWithIconFontName:(NSString *)iconFontName text:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

#pragma mark - Icon Text

+ (nullable NSString *)unicodePointStringWithIconText:(NSString *)iconText;

#pragma mark - Font File Info

+ (nullable WCFontInfo *)fontInfoWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
