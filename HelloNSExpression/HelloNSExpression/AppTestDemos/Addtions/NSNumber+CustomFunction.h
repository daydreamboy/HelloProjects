//
//  NSNumber+CustomFunction.h
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CustomFunction)
- (NSNumber *)factorial;
- (NSNumber *)squareAndSubtractFive;
- (NSNumber*)gaussianWithMean:(NSNumber*)mean andVariance:(NSNumber*)variance;
@end
