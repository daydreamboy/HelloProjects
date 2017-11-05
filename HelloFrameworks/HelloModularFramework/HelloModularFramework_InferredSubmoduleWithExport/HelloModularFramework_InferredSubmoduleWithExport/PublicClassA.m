//
//  PublicClassA.m
//  HelloModularFramework_InferredSubmoduleWithExport
//
//  Created by wesley_chen on 03/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PublicClassA.h"

@implementation PublicClassA
+ (void)doSomething {
    NSLog(@"%@: %@", NSStringFromClass(self), NSStringFromSelector(_cmd));
}
@end
