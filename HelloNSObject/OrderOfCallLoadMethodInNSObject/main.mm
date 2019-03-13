//
//  main.m
//  TryLoadMethodOfNSObject
//
//  Created by wesley_chen on 2019/3/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BaseClass : NSObject
@end
@implementation BaseClass : NSObject
+ (void)load {
    NSLog(@"load method in BaseClass");
}

// must specify __attribute__((constructor)) for the function
__attribute__((constructor)) void constructorLoad(void) {
    NSLog(@"constructorLoad function");
}
@end

@implementation BaseClass (Addition)
+ (void)load {
    NSLog(@"load method in BaseClass(Addition)");
}
@end

@interface DerivedClass : BaseClass
@end
@implementation DerivedClass : BaseClass
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
        __unused DerivedClass *d = [[DerivedClass alloc] init];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
