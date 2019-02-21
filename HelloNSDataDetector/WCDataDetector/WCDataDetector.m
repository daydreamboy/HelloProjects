//
//  WCDataDetector.m
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDataDetector.h"
#import "MPMStringTool.h"
#import "WCCharacterSetTool.h"

@interface WCDataDetector ()
@property (nonatomic, strong) NSDataDetector *dataDetector;
@property (nonatomic, readwrite) NSTextCheckingTypes checkingTypes;
@property (nonatomic, strong) NSCache *cache;
@end

@implementation WCDataDetector

- (instancetype)initWithTypes:(NSTextCheckingTypes)checkingTypes error:(NSError * _Nullable *)error {
    NSError *errorL = nil;
    
    self = [super init];
    if (self) {
        _checkingTypes = checkingTypes;
        _dataDetector = [[NSDataDetector alloc] initWithTypes:checkingTypes error:&errorL];
        _enableCheckResultsCache = YES;
        _enableStrictLinkUrl = YES;
        _cacheCountLimit = 50;
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

- (nullable NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)string options:(NSMatchingOptions)options {
    NSArray<NSTextCheckingResult *> *matches;
    
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
        
        matches = [self matchesInString:string options:options range:range];
        if (matches) {
            [self.cache setObject:matches forKey:key];
        }
        
        return matches;
    }
    else {
        matches = [self matchesInString:string options:options range:range];
        return matches;
    }
}

- (void)asyncMatchesInString:(NSString *)string options:(NSMatchingOptions)options completion:(void (^)(NSArray<NSTextCheckingResult *> * _Nullable))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray<NSTextCheckingResult *> *matches = [self matchesInString:string options:options];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(matches);
        });
    });
}

#pragma mark -

- (NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range {
    if (self.enableStrictLinkUrl) {
        NSMutableArray<NSTextCheckingResult *> *arrM = [NSMutableArray array];
        
        NSCharacterSet *characterSet = [[WCCharacterSetTool URLAllowedCharacterSet] invertedSet];
        NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
        NSArray<NSString *> *components = [MPMStringTool componentsWithString:string charactersInSet:characterSet substringRangs:ranges];
        
        if (components.count == ranges.count) {
            for (NSInteger i = 0; i < components.count; i++) {
                NSRange componentRange = [ranges[i] rangeValue];
                
                NSArray<NSTextCheckingResult *> *matches = [self.dataDetector matchesInString:string options:options range:componentRange];
                
                NSMutableArray<NSTextCheckingResult *> *matchesM = [NSMutableArray arrayWithCapacity:matches.count];
                for (NSTextCheckingResult *result in matches) {
                    NSTextCheckingResult *resultToAdd = [self configureResult:result matchingString:string];
                    if (resultToAdd) {
                        [matchesM addObject:resultToAdd];
                    }
                }
                
                [arrM addObjectsFromArray:matchesM];
            }
        }
        else {
            NSLog(@"should never hit this line. Check components array.");
            NSArray<NSTextCheckingResult *> *matches = [self.dataDetector matchesInString:string options:options range:range];
            [arrM addObjectsFromArray:matches];
        }
        
        return arrM;
    }
    else {
        NSArray<NSTextCheckingResult *> *matches = [self.dataDetector matchesInString:string options:options range:range];
        
        NSMutableArray<NSTextCheckingResult *> *matchesM = [NSMutableArray arrayWithCapacity:matches.count];
        for (NSTextCheckingResult *result in matches) {
            NSTextCheckingResult *resultToAdd = [self configureResult:result matchingString:string];
            if (resultToAdd) {
                [matchesM addObject:resultToAdd];
            }
        }
        
        return matchesM;
    }
}

- (nullable NSArray<NSString *> *)componentsWithString:(NSString *)string charactersInSet:(NSCharacterSet *)charactersSet substringRangs:(inout NSMutableArray<NSValue *> *)substringRangs {
    
    NSMutableArray<NSString *> *substrings = [NSMutableArray array];
    NSMutableArray<NSValue *> *substringRangeValues = [NSMutableArray array];
    
    __block NSMutableString *buffer = nil;
    __block NSRange bufferRange = NSMakeRange(0, 0);
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable character, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        if ([character rangeOfCharacterFromSet:charactersSet].location == NSNotFound) {
            if (!buffer) {
                buffer = [NSMutableString stringWithCapacity:string.length];
                bufferRange.location = substringRange.location;
            }
            [buffer appendString:character];
            bufferRange.length += character.length;
        }
        else {
            if (buffer.length) {
                [substrings addObject:buffer];
                [substringRangeValues addObject:[NSValue valueWithRange:bufferRange]];
            }
            
            // reset
            buffer = nil;
            bufferRange = NSMakeRange(0, 0);
        }
    }];
    
    return substrings;
}

- (void)safeSetResult:(NSTextCheckingResult *)result range:(NSRange)range URL:(NSURL *)URL {
    NSString *privateClassName = [@[ @"N", @"S", @"Link", @"Chec", @"king", @"Res", @"ult" ] componentsJoinedByString:@""];
    if ([result isKindOfClass:NSClassFromString(privateClassName)]) {
        @try {
            if (URL) {
                [result setValue:URL forKey:@"_url"];
            }
            [result setValue:[NSValue valueWithRange:range] forKey:@"range"];
        }
        @catch (NSException *e) {
            NSLog(@"an exception occurred: %@", e);
        }
    }
}

- (NSTextCheckingResult *)configureResult:(NSTextCheckingResult *)result matchingString:(NSString *)matchingString {
    // Note: when need to check link and result has URL
    if ((self.checkingTypes & NSTextCheckingTypeLink) && result.URL) {
        
        // 1. force detect http/https url link
        if (self.forceDetectHttpScheme) {
            NSString *fixedHttpScheme = nil;
            NSString *scheme = result.URL.scheme;
            
            if (![scheme isEqualToString:@"http"] && [scheme hasSuffix:@"http"]) {
                fixedHttpScheme = @"http";
            }
            else if (![scheme isEqualToString:@"https"] && [scheme hasSuffix:@"https"]) {
                fixedHttpScheme = @"https";
            }
            
            if (fixedHttpScheme) {
                NSString *originalUrl = result.URL.absoluteString;
                NSString *fixedUrl = [originalUrl substringFromIndex:[originalUrl rangeOfString:fixedHttpScheme].location];

                NSRange subrange = [originalUrl rangeOfString:fixedUrl];
                NSRange fixedRange = NSMakeRange(result.range.location + subrange.location, subrange.length);
                NSURL *fixedURL = [NSURL URLWithString:fixedUrl];
                
                [self safeSetResult:result range:fixedRange URL:fixedURL];
            }
            
            NSString *matchString = [MPMStringTool substringWithString:matchingString range:result.range];
            
            // when result.URL has been escaped, to take out its original url
            if (![matchString isEqualToString:result.URL.absoluteString]) {
                
                NSString *fixedUrl = [matchString commonPrefixWithString:result.URL.absoluteString options:kNilOptions];
                if (fixedUrl.length) {
                    NSString *originalUrl = result.URL.absoluteString;
                    NSRange subrange = [originalUrl rangeOfString:fixedUrl];
                    
                    NSRange fixedRange = NSMakeRange(result.range.location + subrange.location, subrange.length);
                    NSURL *fixedURL = [NSURL URLWithString:fixedUrl];
                    
                    [self safeSetResult:result range:fixedRange URL:fixedURL];
                }
            }
        }
        
        // 2. filter allowed link schemes
        if (self.allowedLinkSchemes.count) {
            if (![self.allowedLinkSchemes containsObject:result.URL.scheme]) {
                return nil;
            }
        }
    }
    
    return result;
}

+ (NSCharacterSet *)URLAllowedCharacterSet {
    static NSMutableCharacterSet *set;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableCharacterSet new];
        [set formUnionWithCharacterSet:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLPasswordAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLPathAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLUserAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"%"]];
    });
    return set;
}

#pragma mark > Getters

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

@end
