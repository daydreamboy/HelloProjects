//
//  UseProtocolRestrictGenericClassViewController.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "UseProtocolRestrictGenericClassViewController.h"
#import "RestrictedByProtocolGenericPetHotel.h"
#import "Cat.h"
#import "Duck.h"

@implementation UseProtocolRestrictGenericClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_use_strict_generic_class];
}

#pragma mark - Test Methods

- (void)test_use_strict_generic_class {
    
    // Error: Cat is not confirm protocol Swim
    /*
    RestrictedByProtocolGenericPetHotel<Cat *> *catHotel = [RestrictedByProtocolGenericPetHotel new];
    [catHotel checkinPet:[NSString new] withName:@"a string"];
    [catHotel checkinPet:[Cat new] withName:@"a cat"];
     */
    
    RestrictedByProtocolGenericPetHotel<Duck *> *duckHotel = [RestrictedByProtocolGenericPetHotel new];
    [duckHotel checkinPet:[NSString new] withName:@"a string"];
    [duckHotel checkinPet:[Cat new] withName:@"a cat"];
    [duckHotel checkinPet:[Duck new] withName:@"a duck"];
}

@end
