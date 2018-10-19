//
//  StrictGenericPetHotel.h
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"

@interface RestrictedGenericPetHotel<__covariant ObjectType: Animal *> : NSObject
- (void)checkinPet:(Animal *)animal withName:(NSString *)name;
- (Animal *)checkoutPetWithName:(NSString *)name;
@end
