//
//  RestrictedByProtocolGenericPetHotel.h
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Swim.h"

@interface RestrictedByProtocolGenericPetHotel<__covariant ObjectType: id<Swim>> : NSObject
- (void)checkinPet:(id<Swim>)animal withName:(NSString *)name;
- (id<Swim>)checkoutPetWithName:(NSString *)name;
@end
