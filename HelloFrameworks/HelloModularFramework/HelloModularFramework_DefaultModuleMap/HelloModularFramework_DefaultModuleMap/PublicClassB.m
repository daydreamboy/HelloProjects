//
//  PublicClassB.m
//  HelloModularFramework_DefaultModuleMap
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PublicClassB.h"

@implementation PublicClassB
+ (void)doSomething {
    NSLog(@"PublicClassB: %@", NSStringFromSelector(_cmd));
}
@end
