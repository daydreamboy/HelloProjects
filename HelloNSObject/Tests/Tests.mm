//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/3/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "WCObjectTool.h"
#import "Thing.h"
#import "Person.h"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#define STR_OF_JSON(...) @#__VA_ARGS__

@interface Tests : XCTestCase
@end

@implementation Tests

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

#pragma mark - Test Methods

- (void)test_dumpedStringWithObject {
    NSDictionary *dict;
    NSArray *arr;
    NSString *output;
    NSString *expected;
    
    // Case 1
    dict = @{
             @"int": @(1),
             @"float": @(3.14f),
             @"double": @(3.1425926314),
             @"bool": @(YES),
             @"dict": @{
                     @"string1": @"value1",
                     @"string2": @"value2",
                     @"null": [NSNull null],
                     },
             @"dict2": @{
                     @"string1": @"value1",
                     @"string2": @"value2"
                     },
             @{
                 @"key": @"value"
             }: @"string",
             @(YES): @(1),
             @(0): @(NO),
             [NSNull null]: @"null",
             @"empty dict": @{},
             @"中文key": @"中文value"
             };
    
    output = [WCObjectTool dumpedStringWithObject:dict];
    NSLog(@"%@", output);
    // @see https://stackoverflow.com/a/24880905
    expected = @""
R"({
    0 : false,
    true : 1,
    null : "null",
    "bool" : true,
    "dict" : {
        "null" : null,
        "string1" : "value1",
        "string2" : "value2"
    },
    "dict2" : {
        "string1" : "value1",
        "string2" : "value2"
    },
    "double" : 3.1425926314,
    "empty dict" : {

    },
    "float" : 3.14,
    "int" : 1,
    {
        "key" : "value"
    } : "string",
    "中文key" : "中文value"
})";

    // Note: dict keys order is uncertained, this assert maybe failed randomly
    XCTAssertEqualObjects(output, expected);
    
    // Case 2
    dict = @{};
    
    output = [WCObjectTool dumpedStringWithObject:dict];
    NSLog(@"%@", output);
    expected = @""
R"JSON({

})JSON";

    XCTAssertEqualObjects(output, expected);

    // Case 3
    dict = @{
             @"special chars": @"It's \"Tom\".\n"
             };
    
    output = [WCObjectTool dumpedStringWithObject:dict];
    NSLog(@"%@", output);
    expected = @""
R"JSON({
    "special chars" : "It's \"Tom\".\n"
})JSON";

    XCTAssertEqualObjects(output, expected);

    // Case 4
    arr = @[
            @(1),
            @"string",
            @(3.14),
            @(NO),
            [NSNull null],
            @[
                @(1),
                @"string",
                @(3.14),
                @(NO),
                [NSNull null],
                ],
            @{
                @"int": @(1),
                @"float": @(3.14f),
                @"double": @(3.1425926314),
                @"bool": @(YES),
                @"dict": @{
                        @"string1": @"value1",
                        @"string2": @"value2",
                        @"null": [NSNull null],
                        },
                @"dict2": @{
                        @"string1": @"value1",
                        @"string2": @"value2"
                        },
                @{
                    @"key": @"value"
                }: @"string",
                @(YES): @(1),
                @(0): @(NO),
                [NSNull null]: @"null",
                @"empty dict": @{},
                @"中文key": @"中文value"
                },
            @""
            ];
    output = [WCObjectTool dumpedStringWithObject:arr];
    NSLog(@"%@", output);
    expected = @""
R"JSON([
    1,
    "string",
    3.14,
    false,
    null,
    [
        1,
        "string",
        3.14,
        false,
        null
    ],
    {
        0 : false,
        true : 1,
        null : "null",
        "bool" : true,
        "dict" : {
            "null" : null,
            "string1" : "value1",
            "string2" : "value2"
        },
        "dict2" : {
            "string1" : "value1",
            "string2" : "value2"
        },
        "double" : 3.1425926314,
        "empty dict" : {

        },
        "float" : 3.14,
        "int" : 1,
        {
            "key" : "value"
        } : "string",
        "中文key" : "中文value"
    },
    ""
])JSON";
    XCTAssertEqualObjects(output, expected);

    // Case 5
    arr = @[];
    output = [WCObjectTool dumpedStringWithObject:arr];
    NSLog(@"%@", arr);
    expected = @""
R"JSON([

])JSON";
    XCTAssertEqualObjects(output, expected);

    // Case 6
    arr = nil;
    output = [WCObjectTool dumpedStringWithObject:arr];
    XCTAssertNil(output);

    // Case 7
    output = [WCObjectTool dumpedStringWithObject:@"1234"];
    NSLog(@"%@", output);

    // Case 8
    output = [WCObjectTool dumpedStringWithObject:@(1234)];
    NSLog(@"%@", output);

    // Case 9
    output = [WCObjectTool dumpedStringWithObject:@(3.14)];
    NSLog(@"%@", output);

    // Case 10
    output = [WCObjectTool dumpedStringWithObject:@(3.14f)];
    NSLog(@"%@", output);

    output = [WCObjectTool dumpedStringWithObject:@(YES)];
    NSLog(@"%@", output);

    // Case 3: NSNull
    output = [WCObjectTool dumpedStringWithObject:[NSNull null]];
    NSLog(@"%@", output);

    // Case 4: Customzied Object as root node
    output = [WCObjectTool dumpedStringWithObject:[[Thing alloc] init]];
    NSLog(@"%@", output);

    output = [WCObjectTool dumpedStringWithObject:[[Person alloc] init]];
    NSLog(@"%@", output);

    // Case 5: Customzied Object nested in NSDictionary
    dict = @{
        @"thing": [[Thing alloc] init],
        @"person": [[Person alloc] init],
        @"key": @"value",
    };
    output = [WCObjectTool dumpedStringWithObject:dict];
    NSLog(@"%@", output);

    // Case 5: Customzied Object nested in NSArray
    arr = @[
        [[Thing alloc] init],
        [[Person alloc] init],
        @(1234)
    ];
    output = [WCObjectTool dumpedStringWithObject:arr];
    NSLog(@"%@", output);
}

#pragma mark - Runtime

#pragma mark > Classes

- (void)test_allClasses {
    NSArray<NSString *> *allClasses = [WCObjectTool allClasses];
    NSLog(@"%@", allClasses);
}

#pragma mark > Property

- (void)test_propertiesWithClass {
    NSArray<NSString *> *output;
    
    // Case 1
    output = [WCObjectTool propertiesWithClass:[NSString class]];
    NSLog(@"%@", output);
}

#pragma mark > Ivar

- (void)test_ivarsWithClass {
    NSArray<NSString *> *output;
    
    // Case 1
    output = [WCObjectTool ivarsWithClass:[NSString class]];
    NSLog(@"%@", output);
    XCTAssertNil(output);
    
    // Case 2
    output = [WCObjectTool ivarsWithClass:[Person class]];
    NSLog(@"%@", output);
    XCTAssertTrue(output.count == 1);
    XCTAssertEqualObjects(output[0], @"NSString* _name");
}

#pragma mark > Class Method

- (void)test_classMethodsWithClass {
    NSArray<NSString *> *output;
    
    // Case 1
    output = [WCObjectTool classMethodsWithClass:[NSString class]];
    NSLog(@"%@", output);
}

#pragma mark > Instance Method

- (void)test_instanceMethodsWithClass {
    NSArray<NSString *> *output;
    
    // Case 1
    output = [WCObjectTool instanceMethodsWithClass:[NSString class]];
    NSLog(@"%@", output);
}

#pragma mark > Protocol

- (void)test_protocolsWithClass {
    NSArray<NSString *> *output;
    
    // Case 1
    output = [WCObjectTool protocolsWithClass:[NSString class]];
    NSLog(@"%@", output);
}

- (void)test_descriptionForProtocol {
    NSDictionary<NSString *, NSArray *> *output;
    
    // Case 1
    output = [WCObjectTool descriptionForProtocolName:@"NSCopying"];
    NSLog(@"%@", output);
}

#pragma mark > Class Hierarchy

- (void)test_classHierarchyWithClass {
    NSArray<NSString *> *output;
    
    // Case 1
    output = [WCObjectTool classHierarchyWithClass:[UIView class]];
    XCTAssertTrue(output.count == 3);
    XCTAssertEqualObjects(output[0], @"UIView");
    XCTAssertEqualObjects(output[1], @"UIResponder");
    XCTAssertEqualObjects(output[2], @"NSObject");
}

- (void)test_printClassHierarchyWithClass {
    NSString *output;
    
    // Case 1
    output = [WCObjectTool printClassHierarchyWithClass:[UIView class]];
    NSLog(@"%@", output);
}

- (void)test_checkIfSubclass_overridesSelector {
    BOOL output;
    
    // Case 1
    output = [WCObjectTool checkIfSubclass:[Person class] overridesSelector:@selector(init)];
    XCTAssertTrue(output);
    
    // Case 2
    output = [WCObjectTool checkIfSubclass:[Person class] overridesSelector:@selector(description)];
    XCTAssertTrue(output);
    
    // Case 3
    output = [WCObjectTool checkIfSubclass:[Person class] overridesSelector:@selector(debugDescription)];
    XCTAssertTrue(output);
    
    // Case 4
    output = [WCObjectTool checkIfSubclass:[Person class] overridesSelector:@selector(class)];
    XCTAssertFalse(output);
}

- (void)test_checkIfObject_overridesSelector {
    BOOL output;
    Person *person = [Person new];
    
    // Case 1
    output = [WCObjectTool checkIfObject:person overridesSelector:@selector(init)];
    XCTAssertTrue(output);
    
    // Case 2
    output = [WCObjectTool checkIfObject:person overridesSelector:@selector(description)];
    XCTAssertTrue(output);
    
    // Case 3
    output = [WCObjectTool checkIfObject:person overridesSelector:@selector(debugDescription)];
    XCTAssertTrue(output);
    
    // Case 4
    output = [WCObjectTool checkIfObject:person overridesSelector:@selector(class)];
    XCTAssertFalse(output);
}

- (void)dummyMethod {
    
}

@end

