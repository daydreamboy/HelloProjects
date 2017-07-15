//
//  Interface.m
//  HelloInterfaceProperty
//
//  Created by wesley_chen on 12/07/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Interface.h"
#import "Impl1.h"
#import "Impl2.h"

@implementation Interface

+ (id<InterfaceProtocol>)defaultManager {
    return [self createInstanceForInterfaceProtocol];
}

+ (id<InterfaceProtocol>)sharedManager {
    static id<InterfaceProtocol> sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [self createInstanceForInterfaceProtocol];
    });
    
    return sInstance;
}

+ (id<InterfaceProtocol>)managerWithStyle:(InterfaceStyle)style {
    switch (style) {
        case InterfaceStyle1:
        default:
            return [Impl1 new];
        case InterfaceStyle2:
            return [Impl2 new];
    }
}

#pragma mark - Private Methods

+ (id<InterfaceProtocol>)createInstanceForInterfaceProtocol {
    return [Impl1 new];
}

@end
