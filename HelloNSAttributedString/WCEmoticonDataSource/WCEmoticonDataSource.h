//
//  WCEmoticonDataSource.h
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2020/11/8.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define WCEmoticonSynthesize \
@synthesize codeString = _codeString; \
@synthesize displayString = _displayString; \
@synthesize imageName = _imageName; \
@synthesize image = _image; \

@protocol WCEmoticon <NSObject>
///< [微笑]
@property (nonatomic, copy, readonly) NSString *codeString;
///< Smile
@property (nonatomic, copy, readonly) NSString *imageName;
///< UIImage
@property (nonatomic, strong, readonly) UIImage *image;
@end

@interface WCEmoticonDataSource : NSObject

@property (nonatomic, assign, readonly) NSUInteger emoticonCount;

+ (instancetype)sharedInstance;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

#pragma mark - Preload

- (void)preloadEmoticonImageWithCompletion:(void (^)(void))completion;
- (void)preloadEmoticonOrderWithCompletion:(void (^)(void))completion;
- (void)preloadEmoticonLocalizedDisplayStringWithLocaleCode:(NSString *)localeCode completion:(void (^)(void))completion;

#pragma mark - Query

- (nullable id<WCEmoticon>)emoticonWithCode:(NSString *)code;
- (nullable NSString *)emoticonDisplayStringWithCode:(NSString *)code;
- (nullable NSDictionary<NSNumber *, NSDictionary *> *)emoticonInfoWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
