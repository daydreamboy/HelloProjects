//
//  CreateDynamicParamModelViewController.m
//  HelloObjCRuntime
//
//  Created by wesley_chen on 03/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "CreateDynamicParamModelViewController.h"

#import "SomeSDK.h"

@interface CreateDynamicParamModelViewController ()

@end

@implementation CreateDynamicParamModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
}

- (void)test1 {
    [[SomeSDK sharedInstance] requestWithParamA:^(id<ParamA> param) {
        param.name = @"A";
        param.url = @"www.google.com";
    } completion:^{
        
    }];
    
    [[SomeSDK sharedInstance] requestWithParamB:^(id<ParamB> param) {
        param.key = @"this is a key";
        param.dict = @{ @"a": @97 };
    } completion:^{
        
    }];
}

@end
