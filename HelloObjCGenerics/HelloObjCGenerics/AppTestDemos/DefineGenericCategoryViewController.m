//
//  DefineGenericCategoryViewController.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DefineGenericCategoryViewController.h"
#import "NSMutableArray+Cat.h"
#import "Cat.h"

@interface DefineGenericCategoryViewController ()

@end

@implementation DefineGenericCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_use_generic_category];
}

#pragma mark - Test Methods

- (void)test_use_generic_category {
    NSMutableArray<Cat *> *arrM = [NSMutableArray array];
    Cat *cat = [arrM giveMeACat];
    NSLog(@"cat: %@", cat);
}


@end
