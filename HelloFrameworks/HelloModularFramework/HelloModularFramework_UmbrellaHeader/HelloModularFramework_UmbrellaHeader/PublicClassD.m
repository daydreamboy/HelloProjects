//
//  PublicClassD.m
//  HelloModularFramework_UmbrellaHeader
//
//  Created by wesley_chen on 02/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PublicClassD.h"

@implementation PublicClassD
+ (void)doSomething {
    NSLog(@"%@: %@", NSStringFromClass(self), NSStringFromSelector(_cmd));
}
@end
