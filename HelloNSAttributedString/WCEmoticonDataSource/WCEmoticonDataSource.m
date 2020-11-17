//
//  WCEmoticonDataSource.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2020/11/8.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCEmoticonDataSource.h"
#import "WCMacroTool.h"
#import "WCBundleTool.h"
#import "WCJSONTool.h"
#import "WCAttributedStringTool.h"

#define WCEmoticonBundleName    nil
#define WCEmoticonIconFileName  @"emoticon_icon.json"
#define WCEmoticonOrderFileName @"emoticon_order.json"
#define WCEmoticonTransPrefixed @"emoticon_trans2"

@interface WCEmoticon : NSObject <WCEmoticon>

///< [微笑]
@property (nonatomic, copy, readwrite) NSString *codeString;
///<  [Smile]
@property (nonatomic, copy, readwrite) NSString *displayString;
///< Smile
@property (nonatomic, copy, readwrite) NSString *imageName;
///< UIImage
@property (nonatomic, strong, readwrite) UIImage *image;

- (instancetype)initWithImage:(UIImage*)image imageName:(NSString *)imageName codeString:(NSString *)codeString;

@end

@implementation WCEmoticon

WCEmoticonSynthesize

- (instancetype)initWithImage:(UIImage*)image imageName:(NSString *)imageName codeString:(NSString *)codeString {
    self = [super init];
    if (self) {
        _image = image;
        _codeString = codeString;
        _imageName = imageName;
    }
    return self;
}

- (NSString *)codeString {
    return _codeString;
}

- (NSString *)displayString {
    return _displayString;
}

- (NSString *)imageName {
    return _imageName;
}

- (UIImage *)image {
    return _image;
}

@end

@interface WCEmoticonDataSource ()
#pragma mark > File Path
@property (nonatomic, copy, readwrite) NSString *emoticonOrderFilePath;
@property (nonatomic, copy, readwrite) NSString *emoticonIconFilePath;
@property (nonatomic, copy, readwrite) NSString *emoticonTransFilePath;
#pragma mark > File Content
@property (nonatomic, strong) NSDictionary *emoticonIcon;
@property (nonatomic, strong) NSArray *emoticonOrder;
#pragma mark > Sync Queue
/// icon file and read image
@property (nonatomic, strong) dispatch_queue_t imageQueue;
@property (nonatomic, strong) dispatch_queue_t fileQueue;
#pragma mark > Memory Data
/// code -> image
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<WCEmoticon>> *emoticonIconMap;
/// code -> localized string
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *emoticonDisplayMap;
@property (nonatomic, copy) NSString *currentLocaleCode;
@property (nonatomic, copy) NSRegularExpression *emoticonRegex;
@end

@implementation WCEmoticonDataSource

+ (instancetype)sharedInstance {
    static WCEmoticonDataSource *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCEmoticonDataSource alloc] init];
    });
    
    return sInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _emoticonIconMap = [NSMutableDictionary dictionary];
        _emoticonDisplayMap = [NSMutableDictionary dictionary];
        
        _imageQueue = dispatch_queue_create("WCEmoticonDataSource.imageQueue", DISPATCH_QUEUE_SERIAL);
        _fileQueue = dispatch_queue_create("WCEmoticonDataSource.fileQueue", DISPATCH_QUEUE_SERIAL);
        _emoticonOrderFilePath = [WCBundleTool pathForResource:WCEmoticonOrderFileName inResourceBundle:WCEmoticonBundleName];
        _emoticonIconFilePath = [WCBundleTool pathForResource:WCEmoticonIconFileName inResourceBundle:WCEmoticonBundleName];
        
        /*
        NSArray *supportedLangs = @[ @"en_US" ];
        
        _emoticonTransFilePath = [NSMutableArray arrayWithCapacity:supportedLangs.count];
        for (NSString *lang in supportedLangs) {
            NSString *fileName = [NSString stringWithFormat:@"%@%@.json", WCEmoticonTransPrefixed, lang];
            [_emoticonTransFilePath addObject:fileName];
        }
         */
    }
    return self;
}

#pragma mark - Preload

- (void)preloadEmoticonImageWithCompletion:(void (^)(void))completion {
    [self loadIconFileIfNeededWithAsync:YES completion:^{
        void (^finishBlock)(void) = ^{
            !completion ?: completion();
        };
        
        weakify(self);
        [self.emoticonIcon enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull code, id  _Nonnull fileName, BOOL * _Nonnull stop) {
            strongifyWithReturn(self, return);
            
            dispatch_async(self.imageQueue, ^{
                strongifyWithReturn(self, return);
                if (STR_IF_NOT_EMPTY(code) && STR_IF_NOT_EMPTY(fileName)) {
                    if (!self.emoticonIconMap[code]) {
                        self.emoticonIconMap[code] = [[WCEmoticon alloc] initWithImage:[UIImage imageNamed:fileName] imageName:fileName codeString:code];
                    }
                }
            });
        }];
        
        dispatch_async(self.imageQueue, ^{
            strongifyWithReturn(self, return);
            finishBlock();
        });
    }];
}

- (void)preloadEmoticonOrderWithCompletion:(void (^)(void))completion {
    void (^finishBlock)(void) = ^{
        !completion ?: completion();
    };
    
    [self loadOrderFileIfNeededWithAsync:YES];
    
    weakify(self);
    dispatch_async(_fileQueue, ^{
        strongifyWithReturn(self, return);
        finishBlock();
    });
}

- (void)preloadEmoticonLocalizedDisplayStringWithLocaleCode:(NSString *)localeCode completion:(void (^)(void))completion {
    void (^finishBlock)(void) = ^{
        !completion ?: completion();
    };
    
    [self loadTransFileIfNeededWithLocaleCode:localeCode async:YES];
    
    weakify(self);
    dispatch_async(_fileQueue, ^{
        strongifyWithReturn(self, return);
        finishBlock();
    });
}

#pragma mark - Query

- (nullable NSString *)emoticonDisplayStringWithCode:(NSString *)code {
    if (!STR_IF_NOT_EMPTY(code)) {
        return nil;
    }
    
    if (!_emoticonDisplayMap) {
        [self loadTransFileIfNeededWithLocaleCode:code async:NO];
    }
    
    __block NSString *displayString;
    
    weakify(self);
    dispatch_sync(_fileQueue, ^{
        strongifyWithReturn(self, return);
        
        displayString = self.emoticonDisplayMap[code];
        if (!displayString) {
            displayString = self.emoticonDisplayMap[code];
        }
    });
    
    return displayString;
}

- (nullable id<WCEmoticon>)emoticonWithCode:(NSString *)code {
    if (!STR_IF_NOT_EMPTY(code)) {
        return nil;
    }
    
    if (!_emoticonIcon) {
        [self loadIconFileIfNeededWithAsync:NO completion:nil];
    }
    
    __block id<WCEmoticon> emoticon = self.emoticonIconMap[code];
    
    if (!emoticon) {
        weakify(self);
        dispatch_sync(_imageQueue, ^{
            strongifyWithReturn(self, return);
            
            emoticon = self.emoticonIconMap[code];
            if (!emoticon) {
                NSString *fileName = self.emoticonIcon[code];
                if (STR_IF_NOT_EMPTY(fileName)) {
                    emoticon = [[WCEmoticon alloc] initWithImage:[UIImage imageNamed:fileName] imageName:fileName codeString:code];
                    self.emoticonIconMap[code] = emoticon;
                }
            }
        });
    }
    
    return emoticon;
}

- (nullable NSDictionary<NSNumber *, NSDictionary *> *)emoticonInfoWithString:(NSString *)string {
    if (!STR_IF_NOT_EMPTY(string)) {
        return nil;
    }
    
    if (self.emoticonIconMap.count == 0) {
        return nil;
    }
    
    __block NSMutableDictionary *emoticonInfoM = [NSMutableDictionary dictionary];
    [self.emoticonRegex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        if (matchString) {
            NSRange range = result.range;
            
            id<WCEmoticon> emoticon = self.emoticonIconMap[matchString];
            if (!emoticon) {
                emoticon = [self emoticonWithCode:matchString];
            }
            
            NSMutableDictionary *infoM = [NSMutableDictionary dictionary];
            infoM[WCEmoticonInfoKey_range] = [NSValue valueWithRange:range];
            infoM[WCEmoticonInfoKey_emoticon] = emoticon;
            infoM[WCEmoticonInfoKey_matchString] = matchString;
            emoticonInfoM[@(range.location)] = infoM;
        }
    }];
    
    return emoticonInfoM;
}

#pragma mark - Utility

- (nullable NSAttributedString *)emoticonizedStringWithString:(NSString *)string attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes {
    
    NSTextCheckingResult *result = [self.emoticonRegex firstMatchInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    if (result.range.location != NSNotFound && result.range.length != 0) {
        UIFont *font = attributes[NSFontAttributeName];
        
        NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
        
        NSDictionary<NSNumber *, NSDictionary *> *emoticonInfo = [[WCEmoticonDataSource sharedInstance] emoticonInfoWithString:string];
        
        NSMutableArray *ranges = [NSMutableArray array];
        NSMutableArray<NSAttributedString *> *emoticonStrings = [NSMutableArray array];
        for (NSNumber *emoticonIndex in emoticonInfo) {
            NSDictionary *info = emoticonInfo[emoticonIndex];
            id<WCEmoticon> emoticon = info[WCEmoticonInfoKey_emoticon];
            if (emoticon.image) {
                NSValue *range = info[WCEmoticonInfoKey_range];
                [ranges addObject:range];
                
                [emoticonStrings addObject:({
                    NSAttributedString *emoticonString = [WCAttributedStringTool attributedStringWithImage:emoticon.image imageSize:CGSizeZero alignToFont:font];
                    NSMutableAttributedString *emoticonStringM = [[NSMutableAttributedString alloc] initWithAttributedString:emoticonString];
                    [emoticonStringM addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, emoticonStringM.length)];
                    emoticonStringM;
                })];
            }
        }
        
        if (ranges.count) {
            NSAttributedString *emoticonizedString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:attrStringM ranges:ranges replacementAttributedStrings:emoticonStrings replacementRanges:nil];
            return emoticonizedString;
        }
        else {
            return attrStringM;
        }
    }
    else {
        return [[NSAttributedString alloc] initWithString:string attributes:attributes];
    }
}

#pragma mark - Getter

- (NSUInteger)emoticonCount {
    [self loadOrderFileIfNeededWithAsync:NO];
    
    __block NSUInteger count;
    weakify(self);
    dispatch_sync(_fileQueue, ^{
        strongifyWithReturn(self, return);
        count = [self.emoticonOrder count];
    });
    return count;
}

#pragma mark - Sync

- (void)loadOrderFileIfNeededWithAsync:(BOOL)async {
    if (!_emoticonOrder) {
        weakify(self);
        void (^task)(void) = ^{
            strongifyWithReturn(self, return);
            if (!self.emoticonOrder) {
                self.emoticonOrder = [WCJSONTool JSONArrayWithData:[NSData dataWithContentsOfFile:self.emoticonOrderFilePath] allowMutable:NO];
            }
        };
        if (async) {
            dispatch_async(_fileQueue, ^{
                task();
            });
        }
        else {
            dispatch_sync(_fileQueue, ^{
                task();
            });
        }
    }
}

- (void)loadIconFileIfNeededWithAsync:(BOOL)async completion:(void (^)(void))completion {
    if (!_emoticonIcon) {
        weakify(self);
        void (^task)(void) = ^{
            strongifyWithReturn(self, return);
            if (!self.emoticonIcon) {
                self.emoticonIcon = [WCJSONTool JSONDictWithData:[NSData dataWithContentsOfFile:self.emoticonIconFilePath] allowMutable:NO];
                NSMutableString *patternM = [NSMutableString stringWithString:@"("];
                NSArray *keys = [self.emoticonIcon allKeys];
                for (NSUInteger i = 0; i < keys.count; ++i) {
                    NSString *key = keys[i];
                    NSString *escapedString = [key stringByReplacingOccurrencesOfString:@"[" withString:@"\\["];
                    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"]" withString:@"\\]"];
                    if (i == keys.count - 1) {
                        [patternM appendFormat:@"%@", escapedString];
                    }
                    else {
                        [patternM appendFormat:@"%@|", escapedString];
                    }
                }
                [patternM appendString:@")"];
                
                self.emoticonRegex = [[NSRegularExpression alloc] initWithPattern:patternM options:kNilOptions error:nil];
            }
            
            BLOCK_SAFE_RUN(completion);
        };
        
        if (async) {
            dispatch_async(_imageQueue, ^{
                task();
            });
        }
        else {
            dispatch_sync(_imageQueue, ^{
                task();
            });
        }
    }
    else {
        BLOCK_SAFE_RUN(completion);
    }
}

- (void)loadTransFileIfNeededWithLocaleCode:(NSString *)localeCode async:(BOOL)async {
    if (!_emoticonDisplayMap) {
        weakify(self);
        void (^task)(void) = ^{
            strongifyWithReturn(self, return);
            if (!self.emoticonDisplayMap) {
                self.currentLocaleCode = localeCode;
                
                NSString *fileName = [NSString stringWithFormat:@"%@%@.json", WCEmoticonTransPrefixed, localeCode];
                self.emoticonTransFilePath = [WCBundleTool pathForResource:fileName inResourceBundle:WCEmoticonBundleName];
                
                self.emoticonDisplayMap = [WCJSONTool JSONDictWithData:[NSData dataWithContentsOfFile:self.emoticonTransFilePath] allowMutable:NO];
            }
        };
        
        if (async) {
            dispatch_async(_fileQueue, ^{
                task();
            });
        }
        else {
            dispatch_sync(_fileQueue, ^{
                task();
            });
        }
    }
}

@end
