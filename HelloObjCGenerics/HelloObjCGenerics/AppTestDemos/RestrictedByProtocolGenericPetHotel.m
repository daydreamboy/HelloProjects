//
//  RestrictedByProtocolGenericPetHotel.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "RestrictedByProtocolGenericPetHotel.h"

@implementation RestrictedByProtocolGenericPetHotel {
    NSMutableDictionary<NSString *, id> *_pets;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pets = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public Methods

- (void)checkinPet:(id)animal withName:(NSString *)name {
    _pets[name] = animal;
}

- (id)checkoutPetWithName:(NSString *)name {
    return _pets[name];
}

@end
