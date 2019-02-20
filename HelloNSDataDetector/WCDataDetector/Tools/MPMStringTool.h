//
//  MPMStringTool.h
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPMStringTool : NSObject
@end

@interface MPMStringTool ()

+ (NSString *)MD5WithString:(NSString *)string;

#pragma mark - Handle String As Plain

#pragma mark > Substring String

/**
 Safe get substring with the location and the length
 
 @param string the whole string
 @param location the start location
 @param length the length of substring
 @return the substring. Return nil if the locatio or length is invalid, e.g. location out of the string index [0..string.length]
 */
+ (NSString *)substringWithString:(NSString *)string atLocation:(NSUInteger)location length:(NSUInteger)length;

/**
 Safe get substring with the length which started at the location
 
 @param string the whole string
 @param range the range
 @return the substring. Return nil if the range is invalid.
 @discussion this method will internally call +[MPMStringTool substringWithString:atLocation:length:]
 */
+ (NSString *)substringWithString:(NSString *)string range:(NSRange)range;
@end

