//
//  PrivateClass.m
//  HelloConvertStaticLibraryToDynamicFramework
//
//  Created by wesley_chen on 11/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PrivateClass.h"

using namespace std;

class CAClass {
    int a;
public:
    void test();
};

void CAClass::test() {
//    std::cout << "hello" << std::endl;
}

@implementation PrivateClass

- (void)helloPrivateClass {
    NSLog(@"call helloPrivateClass");
}

@end
