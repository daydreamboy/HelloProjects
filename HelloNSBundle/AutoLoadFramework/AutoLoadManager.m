//
//  AutoLoadManager.m
//  AutoLoadFramework
//
//  Created by wesley_chen on 10/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AutoLoadManager.h"

@interface ClassA : NSObject
@end
@implementation ClassA
@end

@interface ClassB : NSObject
@end
@implementation ClassB
@end

@implementation AutoLoadManager
+ (void)doSomething {
    NSLog(@"AutoLoadManager - doSomething");
}
@end
