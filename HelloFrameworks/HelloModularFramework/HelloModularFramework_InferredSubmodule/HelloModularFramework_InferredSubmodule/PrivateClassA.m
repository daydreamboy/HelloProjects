//
//  PrivateClassA.m
//  HelloModularFramework_Default
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PrivateClassA.h"

@implementation PrivateClassA
+ (void)doSomething {
    NSLog(@"PrivateClassA: %@", NSStringFromSelector(_cmd));
}
@end
