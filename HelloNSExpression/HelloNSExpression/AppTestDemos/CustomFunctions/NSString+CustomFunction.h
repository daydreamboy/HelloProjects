//
//  NSString+CustomFunction.h
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CustomFunction)

- (NSString *)characterStringAtIndex:(NSNumber *)index;
- (NSString *)concatString:(NSString *)anotherString;
- (NSString *)uppercase;

#pragma mark - Malformed

- (NSUInteger)len;
- (NSString *)charAtIndex:(NSInteger)index;

@end
