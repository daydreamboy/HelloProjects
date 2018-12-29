//
//  NSNumber+WCExpression.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NSNumber+WCExpression.h"

@implementation NSNumber (WCExpression)

- (NSNumber *)exp_factorial {
    return @(tgamma([self doubleValue] + 1));
}

- (NSNumber *)exp_pow:(NSNumber *)n {
    return @(pow([self doubleValue], [n doubleValue]));
}

@end
