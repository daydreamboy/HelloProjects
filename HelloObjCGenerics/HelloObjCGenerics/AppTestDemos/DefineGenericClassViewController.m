//
//  DefineGenericClassViewController.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DefineGenericClassViewController.h"

#import "GenericPetHotel.h"
#import "Cat.h"

@interface DefineGenericClassViewController ()

@end

@implementation DefineGenericClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_use_generic_class];
}

#pragma mark - Test Methods

- (void)test_use_generic_class {
    GenericPetHotel<Cat *> *catHotel = [[GenericPetHotel<Cat *> alloc] init];
    // Note: this line will get a warning
    [catHotel checkinPet:[NSObject new] withName:@"NSObject"];
    [catHotel checkinPet:[Cat new] withName:@"a cat"];
}

@end
