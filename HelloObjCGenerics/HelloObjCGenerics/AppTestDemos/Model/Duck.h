//
//  Duck.h
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"
#import "Swim.h"

@interface Duck : Animal<Swim>

@end
