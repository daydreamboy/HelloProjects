//
//  Tests_Category_hook_setter.m
//  Tests_OC
//
//  Created by wesley_chen on 2020/4/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BaseClassC.h"


@interface BaseClassC (Set_Ivar)
@property (nonatomic, strong) NSDictionary *data;
@end

@implementation BaseClassC (Set_Ivar)
//@synthesize data = _data;
- (void)setData:(NSDictionary *)data {
    // TODO: set value to _data ivar
//    _data = data;
}
@end


@interface Tests_Category_hook_setter : XCTestCase

@end

@implementation Tests_Category_hook_setter

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_ {
    
}

@end
