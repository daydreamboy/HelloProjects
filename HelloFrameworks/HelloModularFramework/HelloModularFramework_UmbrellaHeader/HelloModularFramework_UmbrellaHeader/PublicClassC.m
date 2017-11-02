//
//  PublicClassC.m
//  HelloModularFramework_UmbrellaHeader
//
//  Created by wesley_chen on 02/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PublicClassC.h"

@implementation PublicClassC
+ (void)doSomething {
    NSLog(@"%@: %@", NSStringFromClass(self), NSStringFromSelector(_cmd));
}
@end
