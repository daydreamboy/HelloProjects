//
//  BaseClass3.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "BaseClass3.h"

@implementation BaseClass3
- (instancetype)init {
    self = [super init];
    if (self) {
        _number = 3;
        NSLog(@"BaseClass2 self.number: %ld", (long)self.number);
        NSLog(@"BaseClass2 _number: %ld", (long)_number);
    }
    return self;
}
@end
