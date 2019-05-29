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
- (void)checkinPet:(ObjectType)animal withName:(NSString *)name;
- (ObjectType)checkoutPetWithName:(NSString *)name;
@end
