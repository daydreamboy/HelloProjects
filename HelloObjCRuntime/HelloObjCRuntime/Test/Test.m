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
    XCTAssertEqualObjects(NSStringFromClass([output superclass]), @"NSObject");
    
    // Case 2
    NSArray *protocolNames = @[ NSStringFromProtocol(@protocol(ProtocolA)), NSStringFromProtocol(@protocol(ProtocolB)) ];
    output = [WCObjCRuntimeTool createSubclassWithClassName:nil baseClassName:nil protocolNames:protocolNames selBlockPairs:nil];
    XCTAssertTrue(output != NULL);
    XCTAssertTrue([[NSString stringWithUTF8String:class_getName(output)] hasPrefix:@"NSObject_"]);
    XCTAssertEqualObjects(NSStringFromClass([output superclass]), @"NSObject");
    XCTAssertTrue([output conformsToProtocol:@protocol(ProtocolA)]);
    XCTAssertTrue([output conformsToProtocol:@protocol(ProtocolB)]);
    XCTAssertFalse([output conformsToProtocol:@protocol(ProtocolC)]);
    
    // Case 3
    className = @"MyString";
    output = [WCObjCRuntimeTool createSubclassWithClassName:className baseClassName:@"NSString" protocolNames:nil selBlockPairs:nil];
    XCTAssertTrue(output != NULL);
    XCTAssertEqualObjects([NSString stringWithUTF8String:class_getName(output)], className);
    XCTAssertEqualObjects(NSStringFromClass([output superclass]), @"NSString");
    XCTAssertTrue(NSClassFromString(className));
    object = [[output alloc] init];
    XCTAssertTrue([object isKindOfClass:NSClassFromString(className)]);
    
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
    
    // Case 4
    className = @"MyString2";
    output = [WCObjCRuntimeTool createSubclassWithClassName:className baseClassName:@"NSString" protocolNames:nil selBlockPairs:nil];
    XCTAssertTrue(output != NULL);
    XCTAssertEqualObjects([NSString stringWithUTF8String:class_getName(output)], className);
    XCTAssertEqualObjects(NSStringFromClass([output superclass]), @"NSString");
    XCTAssertTrue(NSClassFromString(className));
    XCTAssertTrue([output isSubclassOfClass:[NSString class]]);
    class_addMethod(object_getClass(output), NSSelectorFromString(@"classDescription"), imp_implementationWithBlock(^id(id sender) {
        return @"MyString class method";
    }), "@@:");
    class_addMethod(output, NSSelectorFromString(@"instanceDescription:"), imp_implementationWithBlock(^id(id sender, NSString *p1) {
        return @"MyString instance method";
    }), "@@:@");
    
    NSString *instance3OfMyCustomString = [output new];
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    XCTAssertEqualObjects([instance3OfMyCustomString performSelector:NSSelectorFromString(@"instanceDescription:") withObject:@"1"], @"MyString instance method");
    XCTAssertEqualObjects([output performSelector:NSSelectorFromString(@"classDescription")], @"MyString class method");
#pragma GCC diagnostic pop
}


@end
