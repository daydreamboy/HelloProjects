//
//  Impl2.m
//  HelloInterfaceProperty
//
//  Created by wesley_chen on 12/07/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Impl2.h"

@interface Impl2 ()
@property (nonatomic, copy) void (^helloWhoBlock)(NSString *);
@end

@implementation Impl2

@synthesize someString = _someString;
@synthesize readonlyString = _readonlyString;
@synthesize numberInteger = _numberInteger;
@synthesize helloBlock = _helloBlock;

#pragma mark - Public Methods

- (void)setHelloBlock:(void (^)(void))helloBlock {
    _helloBlock = [helloBlock copy];
}

- (void)setHelloWhoBlock:(void (^)(NSString *))helloWhoBlock {
    _helloWhoBlock = [helloWhoBlock copy];
}

- (void)helloToPersion:(NSString *)who {
    if (_helloWhoBlock) {
        _helloWhoBlock([NSString stringWithFormat:@"%@~~", who]);
    }
}

@end
