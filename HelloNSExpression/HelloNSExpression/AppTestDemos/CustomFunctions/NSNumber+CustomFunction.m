//
//  NSNumber+CustomFunction.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NSNumber+CustomFunction.h"

@implementation NSNumber (CustomFunction)

// @see https://nshipster.com/nsexpression/
- (NSNumber *)factorial {
    return @(tgamma([self doubleValue] + 1));
}

- (NSNumber *)pow:(NSNumber *)n {
    return @(pow([self doubleValue], [n doubleValue]));
}

// @see https://spin.atomicobject.com/2015/03/24/evaluate-string-expressions-ios-objective-c-swift/
- (NSNumber *)squareAndSubtractFive {
    return @(self.doubleValue * self.doubleValue - 5);
}

// @see https://spin.atomicobject.com/2015/03/24/evaluate-string-expressions-ios-objective-c-swift/
- (NSNumber*)gaussianWithMean:(NSNumber *)mean andVariance:(NSNumber *)variance {
    double value = [self doubleValue];
    double valueMinusMean = value - [mean doubleValue];
    return @(exp(- (valueMinusMean * valueMinusMean) / [variance doubleValue]));
}

@end
