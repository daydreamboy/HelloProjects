//
//  NSNumber+NSPredicate.m
//  Tests
//
//  Created by wesley_chen on 2019/1/2.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "NSNumber+NSPredicate.h"

@implementation NSNumber (NSPredicate)
- (NSNumber *)pow:(NSNumber *)n {
    return @(pow([self doubleValue], [n doubleValue]));
}
@end
