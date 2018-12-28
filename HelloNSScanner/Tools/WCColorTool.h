//
//  WCColorTool.h
//  HelloNSScanner
//
//  Created by wesley_chen on 2018/12/28.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCColorTool : NSObject

@end

@interface WCColorTool ()

/**
 Convert hex string to UIColor with the specific prefix
 
 @param string the hex string with foramt @"<prefix>RRGGBB" or @"<prefix>RRGGBBAA"
 @param prefix the prefix. For safety, prefix not allow the `%` character
 @return the UIColor object. return nil if string is not valid.
 @discussion If the prefix contains `%` character, will return nil.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)string prefix:(nullable NSString *)prefix;

@end
