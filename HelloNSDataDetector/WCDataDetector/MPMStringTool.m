//
//  MPMStringTool.m
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MPMStringTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MPMStringTool

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

#pragma mark - Handle String As Plain

#pragma mark > Substring String

+ (NSString *)substringWithString:(NSString *)string atLocation:(NSUInteger)location length:(NSUInteger)length {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (location < string.length) {
        if (length < string.length - location) {
            return [string substringWithRange:NSMakeRange(location, length)];
        }
        else {
            // Now substring from loc to the end of string
            return [string substringFromIndex:location];
        }
    }
    else {
        return nil;
    }
}

+ (NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    return [self substringWithString:string atLocation:range.location length:range.length];
}

@end
