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
};

typedef NS_OPTIONS(NSUInteger, WCPinYinStringPatternOption) {
    /// 全拼（仅汉字部分）（例如chenmengyu）
    WCPinYinStringPatternOptionFullPinYin = 1 << 0,
    /// 完整拼音（包括非汉字部分）（例如chenmengyu 2020）
    WCPinYinStringPatternOptionOriginalPinYin = 1 << 1,
    /// 简拼（每个汉字的第一个音节的有序组合，例如chen meng yu的有序组合是ch, chm, chmy，但不能是my）
    WCPinYinStringPatternOptionSimplePinYin = 1 << 2,
    /// 首字母拼（每个汉字的第一个字母的有序组合，例如chen meng yu的有序组合是c, cm, cmy，但不能是my）
    WCPinYinStringPatternOptionFirstLetter = 1 << 3,
    /// 单字拼音（每个汉字的拼音，例如chen meng yu的单字拼音是chen, meng, yu）
    WCPinYinStringPatternOptionSinglePinYin = 1 << 4,
    /// 全部选项
    WCPinYinStringPatternOptionAll = WCPinYinStringPatternOptionFullPinYin | WCPinYinStringPatternOptionOriginalPinYin | WCPinYinStringPatternOptionSimplePinYin | WCPinYinStringPatternOptionFirstLetter | WCPinYinStringPatternOptionSinglePinYin,
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

@interface WCPinYinTable : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval loadTimeInterval;
@property (atomic, assign, readonly) BOOL loaded;

+ (instancetype)sharedInstance;

- (void)preloadWithFilePath:(NSString *)filePath completion:(nullable void (^)(BOOL success))completion async:(BOOL)async;
- (void)cleanup;
- (nullable WCPinYinInfo *)pinYinInfoWithTextCharacter:(NSString *)textCharacter;
- (nullable NSString *)pinYinStringWithText:(NSString *)text type:(WCPinYinStringType)type separator:(nullable NSString *)separator;
- (nullable NSOrderedSet<NSString *> *)pinYinMatchPatternsWithText:(NSString *)text options:(WCPinYinStringPatternOption)options;

#pragma mark - UNAVAILABLE

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
