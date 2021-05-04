//
//  WCPinYinTable.h
//  HelloNSString
//
//  Created by wesley_chen on 2020/8/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCPinYinStringType) {
    WCPinYinStringTypePinYin,
    WCPinYinStringTypeWithTone,
    WCPinYinStringTypeFirstSyllable,
    WCPinYinStringTypeFirstLetter,
};

typedef NS_OPTIONS(NSUInteger, WCPinYinStringPatternOption) {
    /// 完整拼音（包括非汉字部分）（例如chenmengyu 2020）
    WCPinYinStringPatternOptionOriginalPinYin = 1 << 0,
    /// 单字拼音（每个汉字的拼音的有序组合，以及和其他字符的有序组合，例如chen meng yu的单字拼音的有序组合是chen, meng, yu, chenmeng, chengmengyu，最后一种情况是全拼）
    WCPinYinStringPatternOptionSinglePinYin = 1 << 1,
    /// 简拼（每个汉字的第一个音节的有序组合，例如chen meng yu的有序组合是ch, chm, chmy，但不能是my）
    WCPinYinStringPatternOptionSimplePinYin = 1 << 2,
    /// 首字母拼（每个汉字的第一个字母的有序组合，例如chen meng yu的有序组合是c, cm, cmy，但不能是my）
    WCPinYinStringPatternOptionFirstLetter = 1 << 3,
    /// 全部选项
    WCPinYinStringPatternOptionAll = WCPinYinStringPatternOptionOriginalPinYin | WCPinYinStringPatternOptionSinglePinYin | WCPinYinStringPatternOptionSimplePinYin | WCPinYinStringPatternOptionFirstLetter,
};

@interface WCPinYinInfo : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) unichar unicode;
@property (nonatomic, copy) NSString *unicodeString;
@property (nonatomic, copy) NSString *pinYin;
@property (nonatomic, assign) NSInteger tone;
@property (nonatomic, copy) NSString *pinYinWithTone;
@property (nonatomic, copy) NSString *firstLetter;
@property (nonatomic, copy) NSString *firstSyllable;
@property (nonatomic, strong, nullable) NSArray<WCPinYinInfo *> *alternatives;
@end

/**
 A table for querying PinYin info of chinese characters
 */
@interface WCPinYinTable : NSObject

/**
 The time for loading configuration file
 */
@property (nonatomic, assign, readonly) NSTimeInterval loadTimeInterval;
/**
 The flag for loading configuration file. YES if loaded, NO if not loaded yet
 */
@property (atomic, assign, readonly) BOOL loaded;

+ (instancetype)sharedInstance;

/**
 Preload the configuration file with file path
 
 @param filePath the configuration file
 @param completion the callback
 @param async the flag if load the file asynchronous or synchronous
 */
- (void)preloadWithFilePath:(NSString *)filePath completion:(nullable void (^)(BOOL success))completion async:(BOOL)async;

/**
 Preload the configuration file with file path
 
 @param completion the callback
 @param async the flag if load the file asynchronous or synchronous
 
 @discussion Use this method must configure macro `kResourceBundleName`
 */
- (void)preloadWithCompletion:(nullable void (^)(BOOL success))completion async:(BOOL)async;

/**
 Clean up all WCPinYinInfo objects
 
 @discussion This method called usually when you will never use WCPinYinTable sharedInstance
 */
- (void)cleanup;

/**
 Get PinYin info with a character
 
 @param textCharacter the character which length is 1
 
 @return the WCPinYinInfo object. Return nil if the textCharacter
 */
- (nullable WCPinYinInfo *)pinYinInfoWithTextCharacter:(NSString *)textCharacter;

/**
 Get multiple PinYin infos with a character which maybe a polyphone
 
 @param textCharacter the character which length is 1
 
 @return the WCPinYinInfo array
 */
- (nullable NSArray<WCPinYinInfo *> *)pinYinInfosWithTextCharacter:(NSString *)textCharacter;

/**
 Convert text to PinYin string
 
 @param text the text string
 @param type the WCPinYinStringType
 @param separator the separator. If nil, use @" " by default
 
 @return the PinYin string
 */
- (nullable NSString *)pinYinStringWithText:(NSString *)text type:(WCPinYinStringType)type separator:(nullable NSString *)separator;

/**
 Get match patterns of the text
 
 @param text the text string
 @param options the WCPinYinStringPatternOption
 
 @return the PinYin match patterns
 */
- (nullable NSOrderedSet<NSString *> *)pinYinMatchPatternsWithText:(NSString *)text options:(WCPinYinStringPatternOption)options;

#pragma mark - UNAVAILABLE

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
