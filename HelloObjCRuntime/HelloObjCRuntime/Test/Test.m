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

@protocol MyObject <NSObject>
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

- (void)test_createSubclassWithClassName_baseClassName_protocolNames_selBlockPairs {
    Class output;
    id object;
    NSString *className;
    
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
    
    // Case 3
    className = @"MyString";
    output = [WCObjCRuntimeTool createSubclassWithClassName:className baseClassName:@"NSString" protocolNames:nil selBlockPairs:nil];
    XCTAssertTrue(output != NULL);
    XCTAssertEqualObjects([NSString stringWithUTF8String:class_getName(output)], className);
    XCTAssertTrue(NSClassFromString(className));
    object = [[output alloc] init];
    XCTAssertTrue([object isKindOfClass:NSClassFromString(className)]);
    
    // Note: use __strong to hold newClass object, because struct has no ARC
    output = [WCObjCRuntimeTool createSubclassWithClassName:@"MyCustomString" baseClassName:@"NSString" protocolNames:nil selBlockPairs:selBlockPair_list {
        @selector(description),
        selBlockPair_block ^id (id sender) {
            return @"This is a MyCustomString string";
        },
        NSSelectorFromString(@"hello:"),
        selBlockPair_block ^id (id sender, NSString *name) {
            NSLog(@"%p: hello %@!", sender, name);
            return nil;
        },
        selBlockPair_nil
    }];
    
    NSString *instance1OfMyCustomString = [output new];
    NSString *instance2OfMyCustomString = [output new];
    
    XCTAssertEqualObjects([instance1OfMyCustomString description], @"This is a MyCustomString string");
    XCTAssertEqualObjects([instance2OfMyCustomString description], @"This is a MyCustomString string");
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    [instance1OfMyCustomString performSelector:NSSelectorFromString(@"hello:") withObject:@"Andy"];
    [instance2OfMyCustomString performSelector:NSSelectorFromString(@"hello:") withObject:@"Judy"];
#pragma GCC diagnostic pop
}


@end
