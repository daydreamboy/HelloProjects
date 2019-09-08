//
//  Test_selector.m
//  Test_OC
//
//  Created by wesley_chen on 2019/6/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/objc.h>

@interface Test_selector : XCTestCase

@end

@implementation Test_selector

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_check_selector_is_string {
    SEL selector;
    const char *string;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wcast-of-sel-type"
    // Case 1
    selector = @selector(compare:); // Note: selector is a string
    printf("%s\n", (char *)selector); // Note: get a warning
    
    string = (char *)selector;
    XCTAssertTrue(strcmp("compare:", string) == 0);
#pragma GCC diagnostic pop
    
    // Case 2
    string = sel_getName(selector);
    XCTAssertTrue(strcmp("compare:", string) == 0);
    
    // Case 3
    string = (const char *)(const void*)selector; // Note: no warning here
    XCTAssertTrue(strcmp("compare:", string) == 0);
}

- (void)test_sel_isMapped {
    BOOL output;
    
    // Note: sel_isMapped not work, the methodNotExist method has no implementation,
    // but sel_isMapped returns YES
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    output = sel_isMapped(@selector(methodNotExist));
    XCTAssertTrue(output);
#pragma GCC diagnostic pop
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
    output = sel_isMapped(nil);
    XCTAssertFalse(output);
#pragma GCC diagnostic pop
    
    output = sel_isMapped(@selector(test_sel_isMapped));
    XCTAssertTrue(output);
    
    output = sel_isMapped(@selector(compare:));
    XCTAssertTrue(output);
}

@end
