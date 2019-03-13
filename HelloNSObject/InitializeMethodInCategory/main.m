//
//  main.m
//  InitializeMethodInCategory
//
//  Created by wesley_chen on 2019/3/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BaseClass : NSObject @end
@implementation BaseClass
+ (void)initialize {
    if (self == [BaseClass self]) {
        NSLog(@"initialize method in %@ (BaseClass)", self);
    }
}
@end

@interface DerivedClass1 : BaseClass @end
@implementation DerivedClass1
+ (void)initialize {
    NSLog(@"if category implements initialize method and this initialize won't be called");
}
@end

@implementation DerivedClass1 (Addition)
+ (void)initialize {
    [super initialize]; // Note: make BaseClass's +initialize called
    NSLog(@"initialize(Addition) method in DerivedClass1");
}
@end

@interface DerivedClass2 : BaseClass @end
@implementation DerivedClass2
+ (void)initialize {
    // Note: no super caller here, but still trigger BaseClass's +initialize called
    NSLog(@"initialize method in DerivedClass2");
}
@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"main function");
        [DerivedClass1 class];
        [DerivedClass2 class];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
