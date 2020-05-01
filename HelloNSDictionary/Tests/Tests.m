//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/8/31.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDictionaryTool.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_objectWithDictionary_forKeyPath_objectClass {
    NSDictionary *dict;
    NSString *key;
    Class class;
    id value;
    
    // Case 1
    dict = @{};
    value = [WCDictionaryTool objectWithDictionary:dict forKeyPath:@"b.a.b" objectClass:[NSString class]];
    XCTAssertNil(value);
}

- (void)test_flattenDictionaryWithDictionary_option {
    id dict;
    NSDictionary *output;
    
    // Case 1
    dict = @{
             @"1": @{
                     @"2-1": @{
                         @"3-1": @"3-1-value",
                         @"3-2": @"3-1-value",
                         @"3-3": @[ @"3-1-value1", @"3-1-value2", @"3-1-value3",]
                         },
                     @"2-2": @[
                                @{ @"4": @"4-value"}
                             ]
                     },
             };
    output = [WCDictionaryTool flattenDictionaryWithDictionary:dict option:kNilOptions];
    NSLog(@"%@", output);
    
    // Case 2
    // Case 1
    dict = @{
             @"1": @{
                     @"2-1": @{
                             @"3-1": @"3-1-value",
                             @"3-2": @"3-1-value",
                             @"3-3": @[ @"3-1-value1", @"3-1-value2", @"3-1-value3",]
                             },
                     @"2-2": @[
                                @{ @"4": @"4-value"}
                             ]
                     },
             };
    output = [WCDictionaryTool flattenDictionaryWithDictionary:dict option:WCFlattenDictionaryOptionOnlyDictionaryAndArray];
    NSLog(@"%@", output);
}

- (void)test_description {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < 100; i++) {
        dict[[NSString stringWithFormat:@"%d", (int)i]] = @(i);
    }
    
    NSLog(@"%@", dict);
}

- (void)test_KVO {
    // @see https://stackoverflow.com/a/4505507
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [d addObserver:self forKeyPath:@"foo" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    [d setObject:@"bar" forKey:@"foo"];
    [d removeObjectForKey:@"foo"];
    [d removeObserver:self forKeyPath:@"foo"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"observing: -[%@ %@]", object, keyPath);
    NSLog(@"change: %@", change);
}

@end
