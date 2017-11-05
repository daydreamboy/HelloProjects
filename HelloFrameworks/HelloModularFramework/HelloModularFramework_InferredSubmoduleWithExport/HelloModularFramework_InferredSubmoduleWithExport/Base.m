//
//  PublicClassA.m
//  HelloModularFramework_Default
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Base.h"

@implementation Base
+ (void)doSomething {
    NSLog(@"%@: %@", NSStringFromClass(self), NSStringFromSelector(_cmd));
}
@end
