//
//  SetIVarDirectlyViewController.m
//  HelloObjCRuntime
//
//  Created by wesley_chen on 03/04/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "SetIVarDirectlyViewController.h"
#import <objc/runtime.h>

@interface Foo : NSObject
@property (nonatomic, readwrite) NSString *string;
@property (nonatomic, readonly) NSInteger count;
@end

@implementation Foo
@end

@interface SetIVarDirectlyViewController ()
@end

@implementation SetIVarDirectlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @see http://alanduncan.me/2013/10/02/set-an-ivar-via-the-objective-c-runtime/
    [self setIVarOfPrimitiveType];
    [self setIVarOfObjectType];
}

- (void)setIVarOfPrimitiveType {
    Foo *myFoo = [[Foo alloc] init];
    char *property_name;
    CFTypeRef myFooRef;
    
    property_name = "_count";

    Ivar ivar = class_getInstanceVariable(Foo.class, property_name);
    assert(ivar);

    myFooRef = CFBridgingRetain(myFoo);
    int *ivarPtr = (int *)((uint8_t *)myFooRef + ivar_getOffset(ivar));

    *ivarPtr = 15;
    NSLog(@"%ld", (long)myFoo.count);
}

- (void)setIVarOfObjectType {
    Foo *myFoo = [[Foo alloc] init];
    char *property_name;
    CFTypeRef myFooRef;
    
    property_name = "_string";
    Ivar ivar2 = class_getInstanceVariable(Foo.class, property_name);
    assert(ivar2);
    
    myFooRef = CFBridgingRetain(myFoo);
    uintptr_t *ivarPtr2 = (uintptr_t *)((uint8_t *)myFooRef + ivar_getOffset(ivar2));
    
    NSString *string = @"test"; // @{}
    NSLog(@"%p", string);
    
    //    uintptr_t *ptr = (__bridge void *)string;
    //    NSLog(@"%p", ptr);
    
    *ivarPtr2 = (uintptr_t)(__bridge void *)string;
    
    CFBridgingRelease(myFooRef);
    
    NSLog(@"%@", myFoo.string);
}

@end
