//
//  SynthesizePropertyDerivedFromBaseClassViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/11/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SynthesizePropertyDerivedFromBaseClassViewController.h"
#import "MyCustomEmoticonGroupModel.h"
#import "MyEmoticonGroupModel.h"

@interface SynthesizePropertyDerivedFromBaseClassViewController ()

@end

@implementation SynthesizePropertyDerivedFromBaseClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_case_missing_call_super_method];
    [self test_case_synthesize_ivar_in_derived_class];
}

- (void)test_case_missing_call_super_method {
    MyCustomEmoticonGroupModel *myCustomEmoticonGroupModel = [[MyCustomEmoticonGroupModel alloc] initWithSomething];
    myCustomEmoticonGroupModel.resourceDicPath = @"path/to/resourceDic";
    
    NSLog(@"resourceDicPath: %@", myCustomEmoticonGroupModel.resourceDicPath); // WARNING: resourceDicPath is null
}

- (void)test_case_synthesize_ivar_in_derived_class {
    MyEmoticonGroupModel *myCustomEmoticonGroupModel = [[MyCustomEmoticonGroupModel alloc] initWithSomething];
    myCustomEmoticonGroupModel.resourceDicPath2 = @"path/to/resourceDic";
    
    NSLog(@"resourceDicPath2: %@", myCustomEmoticonGroupModel.resourceDicPath2);
}

@end
