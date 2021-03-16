//
//  WCPinYinTable.m
//  HelloNSString
//
//  Auto generated by generate_objc_dict.rb on 2020-08-05 23:37:33 +0800.
//  !!! Don't modify it manually
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCPinYinTable.h"
#import <QuartzCore/QuartzCore.h>

#define kResourceBundleName @"WCPinYinTable"

static dispatch_queue_t sQueue;

@implementation WCPinYinInfo
@end

@interface WCPinYinTable ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, WCPinYinInfo *> *unicode2PinYinStorage;
@property (nonatomic, assign, readwrite) NSTimeInterval loadTimeInterval;
@property (atomic, assign, readwrite) BOOL loaded;
@end

@implementation WCPinYinTable

+ (instancetype)sharedInstance {
    static dispatch_once_t sOnceToken;
    static WCPinYinTable *sInstance;
    
    dispatch_once(&sOnceToken, ^{
        if (!sQueue) {
            sQueue = dispatch_queue_create("com.wc.WCPinYinTable", DISPATCH_QUEUE_SERIAL);
        }
        
        sInstance = [[WCPinYinTable alloc] init];
        sInstance.unicode2PinYinStorage = [NSMutableDictionary dictionary];
    });
    
    return sInstance;
}

- (void)preloadWithCompletion:(nullable void (^)(BOOL success))completion async:(BOOL)async {
    if (self.loaded) {
        !completion ?: completion(YES);
    }
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:kResourceBundleName ofType:@"bundle"];
    if (bundlePath && [[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        NSString *filePath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"Unicode2Pinyin" ofType:@"txt"];
        [self preloadWithFilePath:filePath completion:completion async:async];
    }
    else {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Unicode2Pinyin" ofType:@"txt"];
        [self preloadWithFilePath:filePath completion:completion async:async];
    }
}

- (void)preloadWithFilePath:(NSString *)filePath completion:(nullable void (^)(BOOL success))completion async:(BOOL)async {
    if (self.loaded) {
        !completion ?: completion(YES);
    }
    
    dispatch_block_t taskBlock = ^{
        NSTimeInterval timeStart = CACurrentMediaTime();
        BOOL isDirectory = NO;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (fileExists && !isDirectory) {
            NSError *error;
            NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            if (error || content.length == 0) {
                self.loadTimeInterval = CACurrentMediaTime() - timeStart;
                !completion ?: completion(NO);
            }
            else {
                NSArray<NSString *> *lines = [content componentsSeparatedByString:@"\n"];
                __block NSMutableDictionary *tempMap = [NSMutableDictionary dictionaryWithCapacity:lines.count];
                @autoreleasepool {
                    [lines enumerateObjectsUsingBlock:^(NSString * _Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSMutableArray *lineComponents = [[line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] mutableCopy];
                        [lineComponents removeObject:@""];
                        
                        if (lineComponents.count > 1) {
                            NSString *unicodeString = lineComponents[0];
                            if (unicodeString.length == 4) {
                                // @see https://stackoverflow.com/a/3648562
                                unsigned unicode = 0;
                                NSScanner *scanner = [NSScanner scannerWithString:unicodeString];
                                [scanner scanHexInt:&unicode];
                                
                                if (unicode) {
                                    WCPinYinInfo *info = [[self class] createPinYinInfoWithUnicode:unicode unicodeString:unicodeString pinYinInfoString:lineComponents[1]];
                                    
                                    NSMutableArray<WCPinYinInfo *> *tempAlternatives = [NSMutableArray arrayWithCapacity:lineComponents.count];
                                    for (NSInteger i = 2; i < lineComponents.count; ++i) {
                                        WCPinYinInfo *alternative = [[self class] createPinYinInfoWithUnicode:unicode unicodeString:unicodeString pinYinInfoString:lineComponents[i]];
                                        [tempAlternatives addObject:alternative];
                                    }
                                    
                                    info.alternatives = tempAlternatives;
                                    
                                    tempMap[@(info.unicode)] = info;
                                }
                            }
                        }
                    }];
                }
                
                self.unicode2PinYinStorage = tempMap;
                
                self.loadTimeInterval = CACurrentMediaTime() - timeStart;
                self.loaded = YES;
                !completion ?: completion(YES);
            }
        }
        else {
            self.loadTimeInterval = CACurrentMediaTime() - timeStart;
            !completion ?: completion(NO);
        }
    };
    
    if (async) {
        dispatch_async(sQueue, ^{
            taskBlock();
        });
    }
    else {
        dispatch_sync(sQueue, ^{
            taskBlock();
        });
    }
}

- (void)cleanup {
    dispatch_sync(sQueue, ^{
        [[WCPinYinTable sharedInstance].unicode2PinYinStorage removeAllObjects];
    });
}

- (nullable WCPinYinInfo *)pinYinInfoWithTextCharacter:(NSString *)textCharacter {
    if (![textCharacter isKindOfClass:[NSString class]] || textCharacter.length != 1) {
        return nil;
    }
    
    unichar buffer[2] = {0};
    [textCharacter getBytes:buffer maxLength:sizeof(unichar) usedLength:NULL encoding:NSUTF16StringEncoding options:0 range:NSMakeRange(0, textCharacter.length) remainingRange:NULL];
    NSNumber *unicode = [NSNumber numberWithUnsignedShort:buffer[0]];
    
    return self.unicode2PinYinStorage[unicode];
}

- (nullable NSArray<WCPinYinInfo *> *)pinYinInfosWithTextCharacter:(NSString *)textCharacter {
    if (![textCharacter isKindOfClass:[NSString class]] || textCharacter.length != 1) {
        return nil;
    }
    
    unichar buffer[2] = {0};
    [textCharacter getBytes:buffer maxLength:sizeof(unichar) usedLength:NULL encoding:NSUTF16StringEncoding options:0 range:NSMakeRange(0, textCharacter.length) remainingRange:NULL];
    NSNumber *unicode = [NSNumber numberWithUnsignedShort:buffer[0]];
    
    NSMutableArray *pinYinInfos = [NSMutableArray arrayWithCapacity:5];
    WCPinYinInfo *info = self.unicode2PinYinStorage[unicode];
    
    if (info) {
        [pinYinInfos addObject:info];
        if (info.alternatives.count) {
            [pinYinInfos addObjectsFromArray:info.alternatives];
        }
    }
    
    return pinYinInfos;
}

- (nullable NSString *)pinYinStringWithText:(NSString *)text type:(WCPinYinStringType)type separator:(nullable NSString *)separator {
    if (![text isKindOfClass:[NSString class]] || (separator && ![separator isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSString *separatorL = separator ?: @" ";
    
    NSMutableString *stringM = [NSMutableString stringWithCapacity:text.length * 10];
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSUInteger lengthByUnichar = [substring length];
        
        if (lengthByUnichar == 1) {
            unichar buffer[2] = {0};
            
            [substring getBytes:buffer maxLength:sizeof(unichar) usedLength:NULL encoding:NSUTF16StringEncoding options:0 range:NSMakeRange(0, substring.length) remainingRange:NULL];
            
            NSNumber *unicode = [NSNumber numberWithUnsignedShort:buffer[0]];
            WCPinYinInfo *info = self.unicode2PinYinStorage[unicode];
            if (info) {
                if (type == WCPinYinStringTypePinYin) {
                    [stringM appendString:info.pinYin];
                }
                else if (type == WCPinYinStringTypeWithTone) {
                    [stringM appendString:info.pinYinWithTone];
                }
                else if (type == WCPinYinStringTypeFirstSyllable) {
                    [stringM appendString:info.firstSyllable];
                }
                else {
                    [stringM appendString:info.pinYin];
                }
                
                if (substringRange.location != text.length - 1) {
                    [stringM appendString:separatorL];
                }
            }
            else {
                [stringM appendString:substring];
            }
        }
        else {
            [stringM appendString:substring];
        }
    }];
    
    return [stringM copy];
}

- (nullable NSOrderedSet<NSString *> *)pinYinMatchPatternsWithText:(NSString *)text options:(WCPinYinStringPatternOption)options {
    if (![text isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    WCPinYinStringPatternOption optionsL = options == kNilOptions ? WCPinYinStringPatternOptionOriginalPinYin : options;
    
    NSMutableArray<NSMutableOrderedSet *> *originalPinYinSetArray = [NSMutableArray arrayWithCapacity:text.length * 2];
    NSMutableArray<NSMutableOrderedSet *> *simplePinYinSetArray = [NSMutableArray arrayWithCapacity:text.length * 2];
    NSMutableArray<NSMutableOrderedSet *> *firstLetterPinYinSetArray = [NSMutableArray arrayWithCapacity:text.length * 2];
    NSMutableArray<NSMutableOrderedSet *> *singlePinYinSetArray = [NSMutableArray arrayWithCapacity:text.length * 2];
    
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSMutableOrderedSet *originalPinYin = [NSMutableOrderedSet new];
        NSMutableOrderedSet *simplePinYin = [NSMutableOrderedSet new];
        NSMutableOrderedSet *firstLetterPinYin = [NSMutableOrderedSet new];
        NSMutableOrderedSet *singlePinYin = [NSMutableOrderedSet new];
        
        NSArray<WCPinYinInfo *> *infos = [self pinYinInfosWithTextCharacter:substring];
        if (infos.count) {
            for (WCPinYinInfo *info in infos) {                
                // Original PinYin
                [originalPinYin addObject:info.pinYin];
                
                // Simple PinYin
                [simplePinYin addObject:info.firstSyllable];
                
                // First Letter PinYin
                [firstLetterPinYin addObject:info.firstLetter];
                
                // Single PinYin
                [singlePinYin addObject:info.pinYin];
            }
        }
        else {
            // Original PinYin
            [originalPinYin addObject:substring];
            
            // First Letter PinYin
            [firstLetterPinYin addObject:substring];
        }
        
        [originalPinYinSetArray addObject:originalPinYin];
        [simplePinYinSetArray addObject:simplePinYin];
        [firstLetterPinYinSetArray addObject:firstLetterPinYin];
        [singlePinYinSetArray addObject:singlePinYin];
    }];

    
    // Merge all pattern set if needed
    NSMutableOrderedSet *patterns = [NSMutableOrderedSet orderedSetWithCapacity:text.length * 20];
    
    if (optionsL & WCPinYinStringPatternOptionFirstLetter) {
        NSMutableOrderedSet *patternsFirstLetter = [[self class] joinEachElementsByOrder:firstLetterPinYinSetArray];
        
        [patterns unionOrderedSet:patternsFirstLetter];
    }
    
    if (optionsL & WCPinYinStringPatternOptionSimplePinYin) {
        NSMutableOrderedSet *patternsSimplePinYin = [[self class] joinEachElementsByOrder:simplePinYinSetArray];
        
        [patterns unionOrderedSet:patternsSimplePinYin];
    }
    
    if (optionsL & WCPinYinStringPatternOptionSinglePinYin) {
        NSMutableOrderedSet *patternsSinglePinYin = [[self class] joinEachElementsByOrder:singlePinYinSetArray];
        
        [patterns unionOrderedSet:patternsSinglePinYin];
    }
    
    if (optionsL & WCPinYinStringPatternOptionOriginalPinYin) {
        NSMutableOrderedSet *patternsOriginalPinYin = [[self class] joinEachElementsByOrder:originalPinYinSetArray];
        
        [patterns unionOrderedSet:patternsOriginalPinYin];
    }
    
    return [patterns copy];
}

#pragma mark -

+ (WCPinYinInfo *)createPinYinInfoWithUnicode:(unsigned)unicode unicodeString:(NSString *)unicodeString pinYinInfoString:(NSString *)pinYinInfoString {
    NSString *pinYin = [[pinYinInfoString componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSString *tone = [[pinYinInfoString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    WCPinYinInfo *info = [WCPinYinInfo new];
    info.text = [NSString stringWithFormat:@"%C", (unichar)unicode];
    info.unicode = unicode;
    info.unicodeString = [NSString stringWithFormat:@"0x%@", unicodeString];
    info.pinYin = pinYin;
    info.tone = [tone integerValue];
    info.pinYinWithTone = [self createMarkedVowelPinYinWithPinYin:info.pinYin tone:info.tone];
    info.firstLetter = [pinYin substringToIndex:1];
    info.firstSyllable = ({
        NSString *firstSyllable = [pinYin substringToIndex:1];
        
        if ([pinYin hasPrefix:@"zh"] || [pinYin hasPrefix:@"ch"] || [pinYin hasPrefix:@"sh"]) {
            firstSyllable = [pinYin substringToIndex:2];
        }
        
        firstSyllable;
    });
    
    return info;
}

// @see http://www.hwjyw.com/resource/content/2010/06/04/8183.shtml
+ (NSString *)createMarkedVowelPinYinWithPinYin:(NSString *)pinYin tone:(NSInteger)tone {
    NSDictionary *translateMap = @{
        @"a" : @[ @"a", @"ā", @"á", @"ă", @"à" ],
        @"o" : @[ @"o", @"ō", @"ó", @"ŏ", @"ò" ],
        @"e" : @[ @"e", @"ē", @"é", @"ĕ", @"è" ],
        @"i" : @[ @"i", @"ī", @"í", @"ĭ", @"ì" ],
        @"u" : @[ @"u", @"ū", @"ú", @"ŭ", @"ù" ],
        @"v" : @[ @"ü", @"ǖ", @"ǘ", @"ǚ", @"ǜ" ],
    };
    
    NSArray *lookups = @[
        @"a",
        @"o",
        @"e",
        @"iu",
        @"ui",
        @"i",
        @"u",
        @"v"
    ];
    
    NSMutableString *stringM = [NSMutableString stringWithString:pinYin];
    NSRange range;
    
    for (NSString *lookup in lookups) {
        if (lookup.length == 1) {
            range = [pinYin rangeOfString:lookup];
            if (range.location != NSNotFound) {
                NSString *letter = [pinYin substringWithRange:range];
                if (tone >= 0 && tone <= 4) {
                    NSArray *markedVowels = translateMap[letter];
                    NSString *markedVowel = markedVowels[tone];
                    [stringM replaceCharactersInRange:range withString:markedVowel];
                }
                break;
            }
        }
        else if (lookup.length == 2) {
            range = [pinYin rangeOfString:lookup];
            if (range.location != NSNotFound) {
                NSRange newRange = NSMakeRange(range.location + 1, 1);
                NSString *letter = [pinYin substringWithRange:newRange];
                if (tone >= 0 && tone < 4) {
                    NSArray *markedVowels = translateMap[letter];
                    NSString *markedVowel = markedVowels[tone];
                    [stringM replaceCharactersInRange:newRange withString:markedVowel];
                }
                break;
            }
        }
    }
    
    return [stringM copy];
}

/**
 Combination of elements in multiple columns by order. e.g.
 
 array1 (column1)  |  array2 (column2)  |  array3 (column3)
 a  | b1 | c1
   | b2 | c2
   | b3 |
 ==>
 a, b1, c1
 a, b1, c2
 a, b2, c1
 a, b2, c2
 a, b3, c1
 a, b3, c2
 */
+ (NSMutableOrderedSet *)joinEachElementsByOrder:(NSMutableArray<NSMutableOrderedSet *> *)patternsArray {
    NSMutableOrderedSet *allPatterns = [NSMutableOrderedSet orderedSet];
    
    if (patternsArray.count) {
        NSMutableOrderedSet *joinedPatterns = [patternsArray firstObject];
        [patternsArray removeObjectAtIndex:0];
        [allPatterns unionOrderedSet:joinedPatterns];
        
        while (patternsArray.count > 0) {
            NSMutableOrderedSet *tempPatterns = [NSMutableOrderedSet orderedSet];
            
            for (NSInteger i = 0; i < joinedPatterns.count; ++i) {
                NSString *element1 = [joinedPatterns objectAtIndex:i];
                
                NSMutableOrderedSet *nextPattersToMerge = [patternsArray firstObject];
                for (NSInteger j = 0; j < nextPattersToMerge.count; ++j) {
                    NSString *element2 = [nextPattersToMerge objectAtIndex:j];
                    
                    [tempPatterns addObject:[NSString stringWithFormat:@"%@%@", element1, element2]];
                }
            }
            
            joinedPatterns = tempPatterns;
            [allPatterns unionOrderedSet:joinedPatterns];
            
            [patternsArray removeObjectAtIndex:0];
        }
    }
        
    return allPatterns;
}

@end