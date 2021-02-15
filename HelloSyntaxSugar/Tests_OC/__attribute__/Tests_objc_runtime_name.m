//
//  Tests_objc_runtime_name.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "objc_runtime_name_dummy.h"

@interface Tests_objc_runtime_name : XCTestCase <MySecretProtcol>

@end

@implementation Tests_objc_runtime_name

- (void)test_objc_runtime_name {
    NSLog(@"class: %@", NSStringFromClass([MySecretClass class])); // class: 544cd1f719a0cb56dce50fd51b39852d
    NSLog(@"protocol: %@", NSStringFromProtocol(@protocol(MySecretProtcol))); // protocol: 7eceb275788590faefc1097c0f903ce5
    
    // TODO: annotation
    //id<MyService> service =
}

@end
