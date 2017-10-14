//
//  IsaSwizzlingIssueViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 3/8/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "IsaSwizzlingIssueViewController.h"
#import <objc/runtime.h>

@interface BaseClass : NSObject {
    int a;
    int b;
}
@end
@implementation BaseClass @end

@interface PlainSubclass : BaseClass @end
@implementation PlainSubclass @end

@interface StorageSubclass : BaseClass {
@public
    int c;
}
@end
@implementation StorageSubclass @end


@implementation IsaSwizzlingIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // @see http://stackoverflow.com/questions/8512793/objective-c-how-to-change-the-class-of-an-object-at-runtime
    BaseClass *base = [[BaseClass alloc] init];
    int *random = (int *)malloc(sizeof(int));
    NSLog(@"%@", base);
    
    object_setClass(base, [PlainSubclass class]);
    NSLog(@"%@", base);
    
    object_setClass(base, [StorageSubclass class]);
    NSLog(@"%@", base);
    
    StorageSubclass *storage = (id)base;
    storage->c = 0xDEADBEEF; // Warning: maybe cause EXC_BAD_ACCESS any time
    NSLog(@"%X == %X", storage->c, *random);
}

@end
