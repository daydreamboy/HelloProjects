//
//  DefineRestrictedGenericClassViewController.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DefineRestrictedGenericClassViewController.h"
#import "GenericPetHotel.h"
#import "RestrictedGenericPetHotel.h"
#import "Cat.h"

@implementation DefineRestrictedGenericClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_use_strict_generic_class];
}

#pragma mark - Test Methods

- (void)test_use_strict_generic_class {
    GenericPetHotel<NSString *> *catHotel = [GenericPetHotel new];
    // Note: this is not my expectation to use GenericPetHotel class
    [catHotel checkinPet:[NSString new] withName:@"a string"];
    
    // Error: Can't use NSString as a generic type
    /*
    RestrictedGenericPetHotel<NSString *> *catHotel2 = [RestrictedGenericPetHotel new];
     */
    //[catHotel2 checkinPet:[NSString new] withName:@"a string"];
    
    RestrictedGenericPetHotel<Cat *> *catHotel3 = [RestrictedGenericPetHotel new];
    [catHotel3 checkinPet:[NSString new] withName:@"a string"];
    [catHotel3 checkinPet:[Cat new] withName:@"a cat"];
}

@end
