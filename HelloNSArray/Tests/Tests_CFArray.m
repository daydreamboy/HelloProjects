//
//  Tests_CFArray.m
//  Tests
//
//  Created by wesley_chen on 2019/8/31.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Person.h"

@interface Tests_CFArray : XCTestCase

@end

@implementation Tests_CFArray

- (void)setUp {
}

- (void)tearDown {
}

- (void)test_CFArraySortValues {
    CFMutableArrayRef arrMRef;
    
    // Case 1: Sort by object's compare: method
    arrMRef = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(6)));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(5)));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(1)));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(7)));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(2)));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(4)));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(8)));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(9)));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@(0)));
    
    CFArraySortValues(arrMRef, CFRangeMake(0, CFArrayGetCount(arrMRef)), MyCFComparatorFunction, NULL);
    
    CFArrayApplyFunction(arrMRef, CFRangeMake(0, CFArrayGetCount(arrMRef)), MyCFArrayApplierFunction, NULL);
    
    CFRelease(arrMRef);
    
    // Case 2: Sort by pointer addresss
    arrMRef = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    CFArrayAppendValue(arrMRef, (__bridge const void *)([Person new]));
    CFArrayAppendValue(arrMRef, (__bridge const void *)([Person new]));
    CFArrayAppendValue(arrMRef, (__bridge const void *)([Person new]));
    CFArrayAppendValue(arrMRef, (__bridge const void *)([Person new]));
    CFArrayAppendValue(arrMRef, (__bridge const void *)([Person new]));
    
    CFArraySortValues(arrMRef, CFRangeMake(0, CFArrayGetCount(arrMRef)), MyCFComparatorFunction, NULL);
    
    CFArrayApplyFunction(arrMRef, CFRangeMake(0, CFArrayGetCount(arrMRef)), MyCFArrayApplierFunction, NULL);
    
    CFRelease(arrMRef);
    
    // Case 3: Sort by object's compare: method
    arrMRef = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@"C"));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@"B"));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@"D"));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@"A"));
    CFArrayAppendValue(arrMRef, (__bridge const void *)(@"E"));
    
    CFArraySortValues(arrMRef, CFRangeMake(0, CFArrayGetCount(arrMRef)), MyCFComparatorFunction, NULL);
    
    CFArrayApplyFunction(arrMRef, CFRangeMake(0, CFArrayGetCount(arrMRef)), MyCFArrayApplierFunction, NULL);
    
    CFRelease(arrMRef);
}

void MyCFArrayApplierFunction(const void *value, void *context) {
    NSLog(@"%@", (__bridge id)value);
}

CFComparisonResult MyCFComparatorFunction(const void *val1, const void *val2, void *context) {
    NSObject *object1 = (__bridge id)val1;
    NSObject *object2 = (__bridge id)val2;
    
    if ([object1 respondsToSelector:@selector(compare:)] && [object2 respondsToSelector:@selector(compare:)]) {
        return (CFComparisonResult)[(NSString *)object1 compare:(NSString *)object2];
    }
    else {
        if (val1 > val2) {
            return kCFCompareGreaterThan;
        }
        else if (val1 < val2) {
            return kCFCompareLessThan;
        }
        else {
            return kCFCompareEqualTo;
        }
    }
}

@end
