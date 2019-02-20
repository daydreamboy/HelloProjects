//
//  WCDataDetector.m
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDataDetector.h"
#import "MPMStringTool.h"

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
    NSArray<NSTextCheckingResult *> *matches = [self.dataDetector matchesInString:string options:options range:range];
    
    NSMutableArray<NSTextCheckingResult *> *matchesM = [NSMutableArray arrayWithCapacity:matches.count];
    for (NSTextCheckingResult *result in matches) {
        NSTextCheckingResult *resultToAdd = [self configureResult:result];
        if (resultToAdd) {
            [matchesM addObject:resultToAdd];
        }
    }
    
    return matchesM;
}

- (nullable NSTextCheckingResult *)configureResult:(NSTextCheckingResult *)result {
    // Note: when need to check link and result has URL
    if ((self.checkingTypes & NSTextCheckingTypeLink) && result.URL) {
        
        // 1. force detect http/https
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

                NSRange fixedRange = [originalUrl rangeOfString:fixedUrl];
                NSURL *fixedURL = [NSURL URLWithString:fixedUrl];
                
                NSString *privateClassName = [@[ @"NS", @"Link", @"Checking", @"Result" ] componentsJoinedByString:@""];
                if ([result isKindOfClass:NSClassFromString(privateClassName)]) {
                    @try {
                        [result setValue:fixedURL forKey:@"_url"];
                        [result setValue:[NSValue valueWithRange:fixedRange] forKey:@"range"];
                    }
                    @catch (NSException *e) {
                        NSLog(@"an exception occurred: %@", e);
                    }
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
