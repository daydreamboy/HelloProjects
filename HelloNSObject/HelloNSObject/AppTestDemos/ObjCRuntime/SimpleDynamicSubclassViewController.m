//
//  UseWCObjCRuntimeViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 3/11/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "SimpleDynamicSubclassViewController.h"

#import <objc/runtime.h>
#import "NSObject+WCObjCRuntime.h"
#import "WCRTMethod.h"

// Example 1: Conditional subclassing
// NSFoo class exist or not exists (commented out), won't affect MyFoo class, which is created dynamically
@interface NSFoo : NSObject
@end
@implementation NSFoo
- (void)bar {
    NSLog(@"bar: %@", self);
}
- (void)dealloc {
    NSLog(@"dealloc: %@", self);
}
@end

static void BarOverride(id self, SEL _cmd)
{
    // Note: call [super bar]
    Class superClass = NSClassFromString(@"NSFoo");
    void (*superIMP)(id, SEL) = (void *)[superClass instanceMethodForSelector:@selector(bar)];
    superIMP(self, _cmd);
}

// Note: subclass MyFoo from NSFoo
static Class CreateMyFooInheritFromNSFoo(void)
{
    Class NSFoo = NSClassFromString(@"NSFoo");
    if (!NSFoo) {
        return nil;
    }
    
    Class MyFoo = [NSFoo rt_createSubclassNamed:@"MyFoo"];
    
    // Note: add `bar` method to MyFoo class
    SEL sel = @selector(bar);
    WCRTMethod *nsBar = [NSFoo rt_methodForSelector:sel];
    WCRTMethod *myBar = [WCRTMethod methodWithSelector:sel implementation:(IMP)BarOverride signature:[nsBar signature]];
    [MyFoo rt_addMethod:myBar];
    
    return MyFoo;
}

// Note: get MyFoo class
static Class MyFoo(void)
{
    static Class cls = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cls = CreateMyFooInheritFromNSFoo();
    });
    
    return cls;
}


@implementation SimpleDynamicSubclassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Class MyFooClass = MyFoo();
    if (MyFooClass) {
        id foo = [[MyFooClass alloc] init];
        
        NSLog(@"metaClass: %p", object_getClass(MyFooClass));
        NSLog(@"class: %p", object_getClass(foo));
        NSLog(@"object: %p", foo);
        NSLog(@"%@", foo);
        [foo performSelector:@selector(bar)];
    }
}

@end
