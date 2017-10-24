//
//  main.m
//  HelloInitializeMethod
//
//  Created by wesley_chen on 15/3/25.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@implementation BaseClass : NSObject
+ (void)initialize {
    if (self == [BaseClass self]) {
        NSLog(@"initialize method in %@ (BaseClass)", self);
    }
}
@end

@implementation DerivedClass1 : BaseClass
+ (void)initialize {
    NSLog(@"if category implements initialize method and this initialize won't be called");
}
@end

@implementation DerivedClass1 (Addition)
+ (void)initialize {
    [super initialize];
    NSLog(@"initialize(Addition) method in DerivedClass1");
}
@end

@implementation DerivedClass2 : BaseClass
//+ (void)initialize {
//    NSLog(@"initialize method in DerivedClass2");
//}
@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"main function");
        [DerivedClass1 class];
        [DerivedClass2 class];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
