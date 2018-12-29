//
//  NSArray+CustomFunction.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NSArray+CustomFunction.h"

@implementation NSArray (CustomFunction)
- (id)elementAtIndex:(NSNumber *)index {
    NSInteger i = [index integerValue];
    if (0 <= i && i < self.count) {
        return [self objectAtIndex:i];
    }
    
    return nil;
}
@end
