//
//  WCDataDetector.m
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDataDetector.h"
#import <CommonCrypto/CommonDigest.h>

@interface WCStringTool : NSObject
@end

@interface WCStringTool ()
+ (NSString *)MD5WithString:(NSString *)string;
@end

@implementation WCStringTool
+ (NSString *)MD5WithString:(NSString *)string {
    if (string.length) {
        const char *cStr = [string UTF8String];
        unsigned char result[16];
        CC_MD5(cStr, (unsigned int)strlen(cStr), result);
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
    else {
        return nil;
    }
}
@end

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
        *error = errorL;
        return nil;
    }
    
    *error = nil;
    return self;
}

- (NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)string options:(NSMatchingOptions)options {
    NSArray<NSTextCheckingResult *> *matches;
    
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSRange range = NSMakeRange(0, string.length);
    if (self.enableCheckResultsCache) {
        NSString *key = [WCStringTool MD5WithString:string];
        
        matches = [self.cache objectForKey:key];
        if (matches) {
            // Note: reset again to make the key/value as the recent one
            [self.cache setObject:matches forKey:key];
            return matches;
        }
        
        matches = [self.dataDetector matchesInString:string options:options range:range];
        if (matches) {
            [self.cache setObject:matches forKey:key];
        }
        
        return matches;
    }
    else {
        matches = [self.dataDetector matchesInString:string options:options range:range];
        return matches;
    }
}

- (void)asyncMatchesInString:(NSString *)string options:(NSMatchingOptions)options completion:(void (^)(NSArray<NSTextCheckingResult *> *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray<NSTextCheckingResult *> *matches = [self matchesInString:string options:options];
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(matches);
        });
    });
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

@end
