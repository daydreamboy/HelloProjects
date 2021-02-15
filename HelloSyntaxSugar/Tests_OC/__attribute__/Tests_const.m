//
//  Tests_const.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "const_dummy.h"

@interface Tests_const : XCTestCase

@end

@implementation Tests_const

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_const {
    char types[4] = {
        XPL802_11ProtocolA,
        XPL802_11ProtocolB,
        XPL802_11ProtocolG,
        XPL802_11ProtocolN,
    };
    
    for (NSInteger i = 0; i < 100; ++i) {
        NSString *string = XPL802_11ProtocolToString(types[i % 4]);
        NSLog(@"1. %c, %@", types[i % 4], string);
    }
    
    for (NSInteger i = 0; i < 100; ++i) {
        NSString *string = XPL802_11ProtocolToString_issue(types[i % 4]);
        NSLog(@"2. %c, %@", types[i % 4], string);
    }
}

@end
