//
//  WCPinYinTable.h
//  HelloNSString
//
//  Created by wesley_chen on 2020/8/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

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

#pragma mark - UNAVAILABLE

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
