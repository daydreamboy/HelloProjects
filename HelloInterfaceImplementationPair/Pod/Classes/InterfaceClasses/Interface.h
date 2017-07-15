//
//  Interface.h
//  HelloInterfaceProperty
//
//  Created by wesley_chen on 12/07/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterfaceProtocol.h"

typedef NS_ENUM(NSUInteger, InterfaceStyle) {
    InterfaceStyle1,
    InterfaceStyle2,
};

@interface Interface : NSObject
+ (id<InterfaceProtocol>)defaultManager;
+ (id<InterfaceProtocol>)sharedManager;
+ (id<InterfaceProtocol>)managerWithStyle:(InterfaceStyle)style;

@end
