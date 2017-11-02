//
//  PublicClassA.m
//  HelloModularFramework_DefaultModuleMap
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PublicClassA.h"

@implementation PublicClassA
+ (void)doSomething {
    NSLog(@"PublicClassA: %@", NSStringFromSelector(_cmd));
}
@end
