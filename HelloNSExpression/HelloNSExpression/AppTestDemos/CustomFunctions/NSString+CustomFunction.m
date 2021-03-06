//
//  NSString+CustomFunction.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NSString+CustomFunction.h"

@implementation NSString (CustomFunction)

- (NSString *)characterStringAtIndex:(NSNumber *)index {
    return [self substringWithRange:NSMakeRange(index.integerValue, 1)];
}

- (NSString *)concatString:(NSString *)anotherString {
    return [NSString stringWithFormat:@"%@%@", self, anotherString];
}

- (NSString *)uppercase {
    return [self uppercaseString];
}

#pragma mark - Malformed

- (NSUInteger)len {
    return [self length];
}

- (NSString *)charAtIndex:(NSInteger)index {
    return [self substringWithRange:NSMakeRange(index, 1)];
}

@end
