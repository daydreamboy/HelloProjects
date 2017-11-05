//
//  PublicClassC.m
//  HelloModularFramework_InferredSubmodule
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PublicClassC.h"

@implementation PublicClassC
+ (void)doSomething {
    NSLog(@"PublicClassC: %@", NSStringFromSelector(_cmd));
}
@end
