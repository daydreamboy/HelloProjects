//
//  WCCharacterSetTool.h
//  HelloNSCharacterSet
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCCharacterSetTool : NSObject

/**
 Get an array of characters in some one NSCharacterSet (e.g. URLQueryAllowedCharacterSet)

 @param characterSet the instance of NSCharacterSet
 @return an array of characters, and each element is NSString
 @see https://stackoverflow.com/a/15742659
 */
+ (NSArray<NSString *> *)charactersInCharacterSet:(NSCharacterSet *)characterSet;
@end
