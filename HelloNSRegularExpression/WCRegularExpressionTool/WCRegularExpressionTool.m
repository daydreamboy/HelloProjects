//
//  WCRegularExpressionTool.m
//  HelloNSRegularExpression
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCRegularExpressionTool.h"

@implementation WCRegularExpressionTool

+ (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string pattern:(NSString *)pattern {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    return match;
}

+ (BOOL)enumerateMatchesInString:(NSString *)string pattern:(NSString *)pattern usingBlock:(void (^)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop))block {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return NO;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return NO;
    }
    
    if (block) {
        // Note: string should not nil
        [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            BOOL shouldStop = NO;
            block(result, flags, &shouldStop);
            *stop = shouldStop;
        }];
        
        return YES;
    }
    else {
        return NO;
    }
}

@end
