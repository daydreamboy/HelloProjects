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
@property (nonatomic, copy, readonly) NSString *unicodeString;
@property (nonatomic, assign, readonly) CGRect boundingRect;

- (CGPathRef)pathWithTransform:(CGAffineTransform)transform;

@end

@interface WCFontInfo : NSObject
@property (nonatomic, strong, readonly) NSArray<WCFontGlyphInfo *> *glyphInfos;
@property (nonatomic, copy, readonly) NSString *fileName;
@property (nonatomic, copy, readonly) NSString *filePath;
@property (nonatomic, copy, readonly) NSString *postScriptName;
@property (nonatomic, copy, readonly) NSString *familyName;
@property (nonatomic, copy, readonly) NSString *fullName;
@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, assign, readonly) CGFloat ascent;
@property (nonatomic, assign, readonly) CGFloat descent;
@property (nonatomic, assign, readonly) CGFloat leading;
@property (nonatomic, assign, readonly) CGFloat capHeight;
@property (nonatomic, assign, readonly) CGFloat xHeight;
@property (nonatomic, assign, readonly) CGFloat slantAngle;
@property (nonatomic, assign, readonly) CGFloat underlineThickness;
@property (nonatomic, assign, readonly) CGFloat underlinePosition;
@property (nonatomic, assign, readonly) CGRect boundingBox;
@property (nonatomic, assign, readonly) unsigned int unitsPerEm;
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

/**
 Find the adaptive font which fit the contrained size
 
 @param initialFont the initial font which for reference
 @param minimumFontSize the minimum font size
 @param contrainedSize the contrained size
 @param mutilpleLines the flag if multiple lines. If YES, use width/height of contrainedSize. If NO, use height of contrainedSize
 @param textString the text string. If nil, use @"abcdefg..." instead.
 
 @discussion If mutilpleLines = YES, textString should not be nil.
 */
+ (nullable UIFont *)adaptiveFontWithInitialFont:(UIFont *)initialFont minimumFontSize:(NSUInteger)minimumFontSize contrainedSize:(CGSize)contrainedSize mutilpleLines:(BOOL)mutilpleLines textString:(nullable NSString *)textString;

/**
 Find the maximum font which fit the contrained size
 
 @param initialFont the initial font which for reference
 @param minimumFontSize the minimum font size
 @param contrainedSize the contrained size
 @param mutilpleLines the flag if multiple lines. If YES, use width/height of contrainedSize. If NO, use height of contrainedSize
 @param textString the text string. If nil, use @"abcdefg..." instead.
 
 @discussion If mutilpleLines = YES, textString should not be nil.
 
 @see https://stackoverflow.com/a/17622215
 */
+ (nullable UIFont *)adaptiveMaximumFontWithInitialFont:(UIFont *)initialFont minimumFontSize:(NSUInteger)minimumFontSize contrainedSize:(CGSize)contrainedSize mutilpleLines:(BOOL)mutilpleLines textString:(nullable NSString *)textString;

#pragma mark - Load Font in Runtime

+ (BOOL)registerFontWithFilePath:(NSString *)filePath fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error;
+ (BOOL)registerFontWithData:(NSData *)data fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error;

+ (BOOL)unregisterIconFontWithName:(NSString *)name error:(NSError * _Nullable * _Nullable)error completionHandler:(nullable void (^)(NSError *error))completionHandler;

#pragma mark - Icon Image

+ (nullable UIImage *)imageWithIconFontName:(NSString *)iconFontName text:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

+ (nullable UIImageView *)imageViewWithIconFontName:(NSString *)iconFontName text:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

#pragma mark - Icon Text

+ (nullable NSString *)unicodePointStringWithIconText:(NSString *)iconText;

#pragma mark - Font File Info

+ (nullable WCFontInfo *)fontInfoWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
