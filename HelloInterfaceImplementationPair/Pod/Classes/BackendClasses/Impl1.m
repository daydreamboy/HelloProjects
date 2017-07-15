//
//  Impl.m
//  HelloInterfaceProperty
//
//  Created by wesley_chen on 12/07/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Impl1.h"

@interface Impl1 ()
// backend ivars
@property (nonatomic, copy) NSString *readonlyString;
// internal ivars
@property (nonatomic, copy) void (^helloWhoBlock)(NSString *who);

@end

@implementation Impl1

@synthesize someString = _someString;
/* // Note: also can define ivars in its extension
@synthesize readonlyString = _readonlyString;
 */
@synthesize numberInteger =  _numberInteger;
@synthesize helloBlock = _helloBlock;

- (instancetype)init {
    self = [super init];
    if (self) {
        _readonlyString = @"World";
    }
    return self;
}

#pragma mark - Public Methods

- (void)setHelloBlock:(void (^)(void))helloBlock {
    _helloBlock = [helloBlock copy];
}

- (void)setHelloWhoBlock:(void (^)(NSString *who))helloWhoBlock {
    _helloWhoBlock = helloWhoBlock;
}

- (void)helloToPersion:(NSString *)who {
    if (self.helloWhoBlock) {
        self.helloWhoBlock(who);
    }
}

@end
