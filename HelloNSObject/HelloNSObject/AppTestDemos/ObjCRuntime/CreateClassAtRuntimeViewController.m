//
//  CreateClassAtRuntimeViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 3/10/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "CreateClassAtRuntimeViewController.h"
#import <objc/runtime.h>

static NSString *MySubclass_description(id self, SEL _cmd)
{
    return [NSString stringWithFormat:@"<%@ %p>", [self class], self];
//    return [NSString stringWithFormat:@"<%@ %p: foo=%@>", [self class], self, [self foo]];
}

@implementation CreateClassAtRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Tutorial from https://www.mikeash.com/pyblog/friday-qa-2010-11-6-creating-classes-at-runtime-in-objective-c.html
    
    // Step 1: create a pair of Class and its MetaClass
    Class MySubclass = objc_allocateClassPair([NSObject class], "MySubclass", 0);
    NSLog(@"MySubclass: %p", MySubclass);
    NSLog(@"meta class of MySubclass: %p", object_getClass(MySubclass));
    
    // Step 2: add an instance method to Class (class method for MetaClass)
    Method method = class_getInstanceMethod([NSObject class], @selector(description));
    const char *types = method_getTypeEncoding(method);
    
    class_addMethod(MySubclass, @selector(description), (IMP)MySubclass_description, types);
    
    // Step 3: add an ivar to Class
    class_addIvar(MySubclass, "foo", sizeof(id), rint(log2(sizeof(id))), @encode(id));
    
    // Step 4: register the Class
    if (MySubclass != NULL) {
        objc_registerClassPair(MySubclass);
    }
}

- (void)dealloc {
    // Step 6: must use objc_disposeClassPair to release the Class, which is balancing with objc_registerClassPair
    Class MySubclass = NSClassFromString(@"MySubclass");
    if (MySubclass != NULL) {
        objc_disposeClassPair(MySubclass);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Step 5: use Class to create instance and use instance to call instance method
    id myInstance = [[NSClassFromString(@"MySubclass") alloc] init];
    NSLog(@"%@", myInstance);
}

@end
