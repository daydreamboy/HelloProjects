//
//  MPMDataDetector.m
//  MPMessageContainer
//
//  Created by wesley_chen on 2018/7/29.
//

#import "MPMDataDetector.h"
#import "MPMStringTool.h"

@interface MPMDataDetectorCheckResult ()
@end

@implementation MPMDataDetectorCheckResult
@end

@interface MPMDataDetector ()
@property (nonatomic, strong) NSDataDetector *dataDetector;
@property (nonatomic, readwrite) MPMDataDetectorCheckResultType checkingTypes;
@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, copy, readwrite) NSString *emoticonCodePattern;
@property (nonatomic, strong) NSRegularExpression *emoticonDetector;
@end

@implementation MPMDataDetector

- (instancetype)initWithTypes:(MPMDataDetectorCheckResultType)checkingTypes error:(NSError * _Nullable *)error {
    NSError *errorL = nil;
    
    self = [super init];
    if (self) {
        _checkingTypes = checkingTypes;
        
        NSTextCheckingTypes types = NSTextCheckingAllTypes;
        if (checkingTypes & MPMDataDetectorCheckResultTypeLink) {
            types |= NSTextCheckingTypeLink;
        }
        if (checkingTypes & MPMDataDetectorCheckResultTypePhoneNumber) {
            types |= NSTextCheckingTypePhoneNumber;
        }
        
        _dataDetector = [[NSDataDetector alloc] initWithTypes:types error:&errorL];
        _enableCheckResultsCache = YES;
        _cacheCountLimit = 50;
        _emoticonCodePattern = @"(\\/\\:[a-zA-Z0-9_^$<>'~!%&=\\-\\.\\*\\?\\@\\(\\)\\\"]+)";
    }
    if (!_dataDetector && errorL) {
        if (error) {
            *error = errorL;
        }
        return nil;
    }
    
    if (error) {
        *error = nil;
    }
    
    return self;
}

- (NSArray<MPMDataDetectorCheckResult *> *)matchesInString:(NSString *)string options:(NSMatchingOptions)options {
    NSArray<MPMDataDetectorCheckResult *> *matches;
    
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSRange range = NSMakeRange(0, string.length);
    if (self.enableCheckResultsCache) {
        NSString *key = [MPMStringTool MD5WithString:string];
        
        matches = [self.cache objectForKey:key];
        if (matches) {
            // Note: reset again to make the key/value as the recent one
            [self.cache setObject:matches forKey:key];
            return matches;
        }
        
        matches = [self searchMatchesInString:string options:options range:range];

        if (matches) {
            [self.cache setObject:matches forKey:key];
        }
        
        return matches;
    }
    else {
        matches = [self searchMatchesInString:string options:options range:range];
        return matches;
    }
}

- (void)asyncMatchesInString:(NSString *)string options:(NSMatchingOptions)options completion:(void (^)(NSArray<MPMDataDetectorCheckResult *> *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray<MPMDataDetectorCheckResult *> *matches = [self matchesInString:string options:options];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(matches);
        });
    });
}

- (NSArray<MPMDataDetectorCheckResult *> *)searchMatchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range {
    NSArray<NSTextCheckingResult *> *results = [self.dataDetector matchesInString:string options:options range:range];
    NSArray *arr = [self convertNSTextCheckingResultsToMPMDataDetectorCheckResults:results string:string];

    if (self.checkingTypes & MPMDataDetectorCheckResultTypeEmoticon) {
        NSMutableArray *arrM = [NSMutableArray array];
        NSInteger start = 0;
        for (NSInteger i = 0; i < arr.count; i++) {
            MPMDataDetectorCheckResult *result = arr[i];
            if (result.range.location > start) {
                NSString *substringToCheck = [MPMStringTool substringWithString:string atLocation:start length:(result.range.location - start)];
                [arrM addObjectsFromArray:[self searchEmoticonMatchesInString:substringToCheck options:kNilOptions]];
            }
            
            start = result.range.location + result.range.length;
            [arrM addObject:result];
            
            if (i == arr.count - 1) {
                if (start < string.length) {
                    NSString *substringToCheck = [MPMStringTool substringWithString:string atLocation:start length:(string.length - start)];
                    NSArray *emoticonResults = [self searchEmoticonMatchesInString:substringToCheck options:kNilOptions];
                    for (MPMDataDetectorCheckResult *result in emoticonResults) {
                        // Note: fix the location
                        result.range = NSMakeRange(start + result.range.location, result.range.length);
                        [arrM addObject:result];
                    }
                }
            }
        }
        return arrM;
    }
    
    return arr;
}

- (NSArray<MPMDataDetectorCheckResult *> *)convertNSTextCheckingResultsToMPMDataDetectorCheckResults:(NSArray<NSTextCheckingResult *> *)results string:(NSString *)string {
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        MPMDataDetectorCheckResult *r = [MPMDataDetectorCheckResult new];
        r.range = result.range;
        r.matchString = [MPMStringTool substringWithString:string range:result.range];
        if (result.resultType == NSTextCheckingTypePhoneNumber) {
            r.type = MPMDataDetectorCheckResultTypePhoneNumber;
        }
        else if (result.resultType == NSTextCheckingTypeLink) {
            r.type = MPMDataDetectorCheckResultTypeLink;
        }
        [arrM addObject:r];
    }
    
    NSArray *arr = [arrM sortedArrayUsingComparator:^NSComparisonResult(MPMDataDetectorCheckResult* _Nonnull value1, MPMDataDetectorCheckResult* _Nonnull value2) {
        NSComparisonResult result = NSOrderedSame;
        if (value1.range.location > value2.range.location) {
            result = NSOrderedDescending;
        }
        else if (value1.range.location < value2.range.location) {
            result = NSOrderedAscending;
        }
        return result;
    }];
    
    return arr;
}

#pragma mark -

- (NSArray<MPMDataDetectorCheckResult *> *)searchEmoticonMatchesInString:(NSString *)string options:(NSMatchingOptions)options {
    NSArray<NSTextCheckingResult *> *results = [self.emoticonDetector matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    NSArray *arr = [self convertNSTextCheckingResultsToMPMDataDetectorCheckResults:results string:string];
    return arr;
}

#pragma mark - Getters

- (NSCache *)cache {
    if (!_cache) {
        NSCache *cache = [NSCache new];
        cache.name = NSStringFromClass([self class]);
        // Note: 50 check results
        cache.countLimit = self.cacheCountLimit;
        _cache = cache;
    }
    
    return _cache;
}

- (NSRegularExpression *)emoticonDetector {
    if (!_emoticonDetector) {
        _emoticonDetector = [NSRegularExpression regularExpressionWithPattern:self.emoticonCodePattern options:kNilOptions error:nil];
    }
    
    return _emoticonDetector;
}

@end
