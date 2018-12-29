//
//  NSString+WCExpression.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NSString+WCExpression.h"

@implementation NSString (WCExpression)

- (NSString *)exp_characterStringAtIndex:(NSNumber *)index {
    return [self substringWithRange:NSMakeRange(index.integerValue, 1)];
}

- (NSString *)exp_concatString:(NSString *)anotherString {
    return [NSString stringWithFormat:@"%@%@", self, anotherString];
}

- (NSString *)exp_uppercase {
    return [self uppercaseString];
}

@end
