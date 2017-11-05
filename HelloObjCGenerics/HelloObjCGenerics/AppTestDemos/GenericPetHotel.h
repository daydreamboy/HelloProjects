//
//  GenericPetHotel.h
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenericPetHotel<__covariant ObjectType> : NSObject
- (void)checkinPet:(ObjectType)animal withName:(NSString *)name;
- (ObjectType)checkoutPetWithName:(NSString *)name;
@end
