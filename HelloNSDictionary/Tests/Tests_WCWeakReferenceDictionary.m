//
//  Tests_WCWeakReferenceDictionary.m
//  Tests
//
//  Created by wesley_chen on 2019/9/1.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCWeakReferenceDictionary.h"

@interface Tests_WCWeakReferenceDictionary : XCTestCase

@end

@implementation Tests_WCWeakReferenceDictionary

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_fast_enumeration {
    NSUInteger iteration = 100;
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i = 0; i < iteration; i++) {
        [arrM addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    WCWeakReferenceDictionary *dict = [WCWeakReferenceDictionary strongToStrongObjectsDictionaryWithCapacity:0];
    for (NSInteger i = 0; i < iteration; i++) {
        id object = arrM[i];
        dict[[NSString stringWithFormat:@"%d", (int)i]] = object;
    }
    
    XCTAssertTrue(dict.count == iteration);
    
    for (NSString *key in dict) {
        id value = dict[key];
        BOOL found = [arrM containsObject:value];
        XCTAssertTrue(found);
    }
}

- (void)test_strongToWeakObjects {
    NSUInteger iteration = 10000;
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i = 0; i < iteration; i++) {
        [arrM addObject:[NSObject new]];
    }
    
    WCWeakReferenceDictionary *dict = [WCWeakReferenceDictionary strongToWeakObjectsDictionaryWithCapacity:0];
    for (NSInteger i = 0; i < iteration; i++) {
        id object = arrM[i];
        dict[[NSString stringWithFormat:@"%d", (int)i]] = object;
    }
    
    // Note: release the array of objects
    [arrM removeAllObjects];
    
    XCTAssertTrue(dict.count == iteration);
    
    // Note: after release the strongToWeak dict should have nil value for the keys
    for (NSString *key in dict) {
        id value = dict[key];
        XCTAssertNil(value);
    }
}

- (void)test_strongToMixedObjects {
    NSUInteger iteration = 10000;
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i = 0; i < iteration; i++) {
        [arrM addObject:[NSObject new]];
    }
    
    WCWeakReferenceDictionary *dict = [WCWeakReferenceDictionary strongToMixedObjectsDictionaryWithCapacity:0];
    for (NSInteger i = 0; i < iteration; i++) {
        id object = arrM[i];
        NSString *key = [NSString stringWithFormat:@"%d", (int)i];
        if (i % 2 == 0) {
            dict[key] = object;
        }
        else {
            [dict setObject:object forKey:key weaklyHoldInMixedMode:YES];
        }
    }
    
    // Note: release the array of objects
    [arrM removeAllObjects];
    
    XCTAssertTrue(dict.count == iteration);
    
    // Note: after release the strongToMixe dict should have both nil values and non-nil values.
    for (NSInteger i = 0; i < iteration; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", (int)i];
        id object = dict[key];
        
        if (i % 2 == 0) {
            XCTAssertNotNil(object);
        }
        else {
            XCTAssertNil(object);
        }
    }
}

@end
