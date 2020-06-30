//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2019/8/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCApplicationTool.h"

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
}

- (void)tearDown {
}

- (void)test_JSONObjectWithUserHomeFileName {
    id object;
    
    // Note: place 1.txt at the ~ folder
    object = [WCApplicationTool JSONObjectWithUserHomeFileName:@"1.txt"];
    NSLog(@"%@", object);
    XCTAssertNotNil(object);
    
    // Note: place 1.txt at the ~ folder
    object = [WCApplicationTool JSONObjectWithUserHomeFileName:nil];
    NSLog(@"%@", object);
    XCTAssertNotNil(object);
    
    object = RTCall_JSONObjectWithUserHomeFileName(nil);
    NSLog(@"%@", object);
    XCTAssertNotNil(object);
}

- (void)test_hashCodeWithString {
    NSUInteger countForPositive = 0;
    NSUInteger countForNegative = 0;
    NSUInteger countForZero = 0;
    
    for (NSUInteger i = 0; i < 100000; ++i) {
        long long hashCode = [WCApplicationTool hashCodeWithString:[NSUUID UUID].UUIDString];
        if (hashCode > 0) {
            ++countForPositive;
        }
        else if (hashCode < 0) {
            ++countForNegative;
        }
        else {
            ++countForZero;
        }
    }
    NSLog(@"positive: %ld, negative: %ld, zero: %ld", countForPositive, countForNegative, countForZero);
}

- (void)test_checkIfSampledWithUniqueID_lowerBound_upperBound_mod {
    
    NSUInteger countForSampled;
    NSUInteger countForUnsampled;
    long long mod = 5000;
    long long count = 100000;
    
    // Case 1
    countForSampled = 0;
    countForUnsampled = 0;
    for (NSUInteger i = 0; i < 100000; ++i) {
        BOOL sampled = [WCApplicationTool checkIfSampledWithUniqueID:[NSUUID UUID].UUIDString lowerBound:-5000 upperBound:5000 mod:mod];
        if (sampled) {
            ++countForSampled;
        }
        else {
            ++countForUnsampled;
        }
    }
    NSLog(@"sampled: %ld, percent: %f %%", countForSampled, countForSampled / (double)count * 100);
    NSLog(@"unsampled: %ld, percent: %f %%", countForUnsampled, countForUnsampled / (double)count * 100);
    
    // Case 2
    countForSampled = 0;
    countForUnsampled = 0;
    for (NSUInteger i = 0; i < 100000; ++i) {
        BOOL sampled = [WCApplicationTool checkIfSampledWithUniqueID:[NSUUID UUID].UUIDString lowerBound:-4000 upperBound:4000 mod:mod];
        if (sampled) {
            ++countForSampled;
        }
        else {
            ++countForUnsampled;
        }
    }
    NSLog(@"sampled: %ld, percent: %f%%", countForSampled, countForSampled / (double)count * 100);
    NSLog(@"unsampled: %ld, percent: %f %%", countForUnsampled, countForUnsampled / (double)count * 100);
    
    // Case 3
    countForSampled = 0;
    countForUnsampled = 0;
    for (NSUInteger i = 0; i < 100000; ++i) {
        BOOL sampled = [WCApplicationTool checkIfSampledWithUniqueID:[NSUUID UUID].UUIDString lowerBound:0 upperBound:4000 mod:mod];
        if (sampled) {
            ++countForSampled;
        }
        else {
            ++countForUnsampled;
        }
    }
    NSLog(@"sampled: %ld, percent: %f %%", countForSampled, countForSampled / (double)count * 100);
    NSLog(@"unsampled: %ld, percent: %f %%", countForUnsampled, countForUnsampled / (double)count * 100);
    
    BOOL sampled = [WCApplicationTool checkIfSampledWithUniqueID:@"XqFgW9UpxPQDAEwf3Gdr4FXG" lowerBound:-5000 upperBound:5000 mod:5000];
    XCTAssertTrue(sampled);
}

- (void)test_checkIfSampledOnceWithWithUniqueID_boundValue {
    NSUInteger countForSampled;
    NSUInteger countForUnsampled;
    long long count = 100000;
    
    // Case 1
    countForSampled = 0;
    countForUnsampled = 0;
    for (NSUInteger i = 0; i < 100000; ++i) {
        BOOL sampled = [WCApplicationTool checkIfSampledOnceWithWithUniqueID:[NSUUID UUID].UUIDString boundValue:2000];
        if (sampled) {
            ++countForSampled;
        }
        else {
            ++countForUnsampled;
        }
    }
    NSLog(@"sampled: %ld, percent: %f %%", countForSampled, countForSampled / (double)count * 100);
    NSLog(@"unsampled: %ld, percent: %f %%", countForUnsampled, countForUnsampled / (double)count * 100);
    
    // Case 2
    countForSampled = 0;
    countForUnsampled = 0;
    for (NSUInteger i = 0; i < 100000; ++i) {
        BOOL sampled = [WCApplicationTool checkIfSampledOnceWithWithUniqueID:[NSUUID UUID].UUIDString boundValue:4000];
        if (sampled) {
            ++countForSampled;
        }
        else {
            ++countForUnsampled;
        }
    }
    NSLog(@"sampled: %ld, percent: %f%%", countForSampled, countForSampled / (double)count * 100);
    NSLog(@"unsampled: %ld, percent: %f %%", countForUnsampled, countForUnsampled / (double)count * 100);
    
    // Case 3
    countForSampled = 0;
    countForUnsampled = 0;
    for (NSUInteger i = 0; i < 100000; ++i) {
        BOOL sampled = [WCApplicationTool checkIfSampledOnceWithWithUniqueID:[NSUUID UUID].UUIDString boundValue:-4000];
        if (sampled) {
            ++countForSampled;
        }
        else {
            ++countForUnsampled;
        }
    }
    NSLog(@"sampled: %ld, percent: %f %%", countForSampled, countForSampled / (double)count * 100);
    NSLog(@"unsampled: %ld, percent: %f %%", countForUnsampled, countForUnsampled / (double)count * 100);
    
    // Case 3
    countForSampled = 0;
    countForUnsampled = 0;
    for (NSUInteger i = 0; i < 100000; ++i) {
        BOOL sampled = [WCApplicationTool checkIfSampledOnceWithWithUniqueID:[NSUUID UUID].UUIDString boundValue:8000];
        if (sampled) {
            ++countForSampled;
        }
        else {
            ++countForUnsampled;
        }
    }
    NSLog(@"sampled: %ld, percent: %f %%", countForSampled, countForSampled / (double)count * 100);
    NSLog(@"unsampled: %ld, percent: %f %%", countForUnsampled, countForUnsampled / (double)count * 100);
}

@end
