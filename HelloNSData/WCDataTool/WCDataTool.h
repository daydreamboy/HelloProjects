//
//  WCDataTool.h
//  HelloNSData
//
//  Created by wesley_chen on 2018/8/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDataTool : NSObject

/**
 Get MIME type of the data

 @param data the NSData
 @return the MIME type which refer to https://www.freeformatter.com/mime-types-list.html
 
 @discussion supported MIME types are following
 @code
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
 @endcode
 @see https://stackoverflow.com/a/32765708
 */
+ (NSString *)MIMETypeWithData:(NSData *)data;

@end
