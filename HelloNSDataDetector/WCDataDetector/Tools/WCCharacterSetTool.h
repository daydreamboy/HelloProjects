//
//  WCCharacterSetTool.h
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2019/2/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCCharacterSetTool : NSObject
/**
 Get a character set which contains characters allowed in http/https url

 @return the singleton of NSCharacterSet
 @discussion The charaters are !$%&'()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]_abcdefghijklmnopqrstuvwxyz~
 */
+ (NSCharacterSet *)URLAllowedCharacterSet;

@end
