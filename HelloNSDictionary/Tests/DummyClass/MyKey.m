//
//  MyKey.m
//  Tests
//
//  Created by wesley_chen on 2021/6/12.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "MyKey.h"

@implementation MyKey
- (void)dealloc {
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}
@end
