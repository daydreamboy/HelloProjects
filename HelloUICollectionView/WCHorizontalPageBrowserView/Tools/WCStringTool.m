//
//  WCStringTool.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2019/5/27.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"
#import <CommonCrypto/CommonDigest.h>

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
