//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2019/7/18.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "WCObjCRuntimeTool.h"

@protocol ProtocolA <NSObject>
@end

@protocol ProtocolB <NSObject>
@end

@protocol ProtocolC <NSObject>
@end

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test {
    Class output;
    
    // Case 1
    output = [WCObjCRuntimeTool createSubclassWithClassName:nil baseClassName:nil protocolNames:nil selBlockPairs:nil];
    XCTAssertTrue(output != NULL);
    XCTAssertTrue([[NSString stringWithUTF8String:class_getName(output)] hasPrefix:@"NSObject_"]);
    
    // Case 2
    NSArray *protocolNames = @[ NSStringFromProtocol(@protocol(ProtocolA)), NSStringFromProtocol(@protocol(ProtocolB)) ];
    output = [WCObjCRuntimeTool createSubclassWithClassName:nil baseClassName:nil protocolNames:protocolNames selBlockPairs:nil];
    XCTAssertTrue(output != NULL);
    XCTAssertTrue([[NSString stringWithUTF8String:class_getName(output)] hasPrefix:@"NSObject_"]);
    XCTAssertTrue([output conformsToProtocol:@protocol(ProtocolA)]);
    XCTAssertTrue([output conformsToProtocol:@protocol(ProtocolB)]);
    XCTAssertFalse([output conformsToProtocol:@protocol(ProtocolC)]);
}


@end
