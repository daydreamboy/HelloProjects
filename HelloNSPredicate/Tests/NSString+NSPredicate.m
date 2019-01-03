//
//  NSString+NSPredicate.m
//  Tests
//
//  Created by wesley_chen on 2019/1/3.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "NSString+NSPredicate.h"

@implementation NSString (NSPredicate)
- (NSString *)characterStringAtIndex:(NSNumber *)index {
    return [self substringWithRange:NSMakeRange(index.integerValue, 1)];
}

- (NSString *)uppercase {
    return [self uppercaseString];
}
@end
