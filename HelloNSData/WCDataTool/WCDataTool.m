//
//  WCDataTool.m
//  HelloNSData
//
//  Created by wesley_chen on 2018/8/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDataTool.h"

@implementation WCDataTool

+ (NSString *)MIMETypeWithData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x25:
            return @"application/pdf";
        case 0xD0:
            return @"application/vnd";
        case 0x46:
            return @"text/plain";
        default:
            return nil;
    }
    return nil;
}

@end
