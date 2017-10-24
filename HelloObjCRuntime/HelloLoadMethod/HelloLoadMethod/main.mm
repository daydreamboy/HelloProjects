//
//  main.m
//  HelloLoadMethod
//
//  Created by wesley_chen on 15/3/25.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

// Warning here: Cannot find interface declaration for 'LoadClass'
@implementation LoadClass : NSObject
+ (void)load {
    NSLog(@"load method in LoadClass");
}

// must specify __attribute__((constructor)) for the function
__attribute__((constructor)) void constructorLoad(void) {
    NSLog(@"constructorLoad function");
}
@end

@implementation LoadClass (Addition)
+ (void)load {
    NSLog(@"load method in LoadClass(Addition)");
}
@end

@implementation DerivedClass : LoadClass
+ (void)load {
    NSLog(@"load method in DerivedClass");
}
@end

@implementation DerivedClass (Addition)
+ (void)load {
    NSLog(@"load method in DerivedClass(Addition)");
}
@end

// A C++ class
class Math {
public:
    Math() {
        NSLog(@"constructor in Math class");
    }
};

// A C++ static object
static Math m = Math();

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"main function");
        DerivedClass *d = [[DerivedClass alloc] init];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
