//
//  CreateDynamicClassViewController.m
//  HelloCreateDynamicClass
//
//  Created by wesley_chen on 04/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CreateDynamicClassViewController.h"
#import "NSObject+Subclass.h"

typedef struct a {
    int field1;
    float field2;
} a;

@interface CreateDynamicClassViewController ()

@end

@implementation CreateDynamicClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self test_subclass_NSString_dynamically_with_inline_style];
    
    [self test_struct_list_a];
    [self test_struct_list_b];
}

#pragma mark - Test Methods

- (void)test_struct_list_a {
    // Note: a demo for inline syntax
    __unused struct selBlockPair *list = (struct selBlockPair []) {
        @selector(description),
        selBlockPair_cast ^id (id self) {
            return @"This is a MyCustomString string";
        },
        selBlockPair_nil
    };
    
    struct a *list_a = (struct a []) {
        10,
        3.14,
        {
            0,
            0
        }
    };
    
    while (list_a && list_a->field1) {
        printf("list_a -> field1: %d, field2: %f\n", list_a->field1, list_a->field2);
        list_a++;
    }
    
}

- (void)test_struct_list_b {
    struct a *list_b = (struct a []) {
        {
            10,
            3.14,
        },
        {
            0,
            0
        }
    };
    
    while (list_b && list_b->field1) {
        printf("list_b -> field1: %d, field2: %f\n", list_b->field1, list_b->field2);
        list_b++;
    }
}

- (void)test_subclass_NSString_dynamically_with_inline_style {
    // Note: use __strong to hold newClass object, because struct has no ARC
    __strong Class newClass = [NSString newSubclassNamed:@"MyCustomString" protocols:NULL impls:selBlockPair_list {
        @selector(description),
        selBlockPair_cast ^id (id self) {
            return @"This is a MyCustomString string";
        },
        NSSelectorFromString(@"hello:"),
        selBlockPair_cast ^id(id self, NSString *name) {
            NSLog(@"hello %@!", name);
            return nil;
        },
        selBlockPair_nil
    }];
    
    NSString *instanceOfMyCustomString = [newClass new];
    NSLog(@"%@", instanceOfMyCustomString);
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    [instanceOfMyCustomString performSelector:NSSelectorFromString(@"hello:") withObject:@"Andy"];
#pragma GCC diagnostic pop
}

@end
