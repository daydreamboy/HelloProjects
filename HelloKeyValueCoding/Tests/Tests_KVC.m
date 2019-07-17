//
//  Tests_KVC.m
//  Tests
//
//  Created by wesley_chen on 2019/7/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Transaction.h"

@interface Tests_KVC : XCTestCase
@property (nonatomic, strong) NSArray<Transaction *> *transactions;
@property (nonatomic, strong) NSArray<Transaction *> *transactionsMalformed;
@end

@implementation Tests_KVC

- (void)setUp {
    [super setUp];
    
    self.transactions = @[
                          [Transaction transactionWithPayee:@"Lily" amount:@(10) date:[NSDate dateWithTimeIntervalSince1970:100]],
                          [Transaction transactionWithPayee:@"Lucy" amount:@(20) date:[NSDate dateWithTimeIntervalSince1970:40]],
                          [Transaction transactionWithPayee:@"John" amount:@(4) date:[NSDate dateWithTimeIntervalSince1970:20]],
                          [Transaction transactionWithPayee:@"Lily" amount:@(30) date:[NSDate dateWithTimeIntervalSince1970:60]],
                          ];
    
    self.transactionsMalformed = @[
                                   [Transaction transactionWithPayee:@"Lily" amount:@(10) date:[NSDate dateWithTimeIntervalSince1970:100]],
                                   [Transaction transactionWithPayee:@"Lucy" amount:@(20) date:[NSDate dateWithTimeIntervalSince1970:40]],
                                   [Transaction transactionWithPayee:@"John" amount:@(4) date:[NSDate dateWithTimeIntervalSince1970:20]],
                                   [Transaction transactionWithPayee:@"Lily" amount:@(30) date:[NSDate dateWithTimeIntervalSince1970:60]],
                                   [Person new],
                                   ];
    
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

#pragma mark - Keywords

#pragma mark > self

- (void)test_valueForKeyPath_self {
    NSString *name;
    
    Person *p = [Person new];
    p.name = @"John";
    
    name = [p valueForKeyPath:@"self.name"];
    XCTAssertEqualObjects(name, @"John");
    
    name = [p valueForKey:@"name"];
    XCTAssertEqualObjects(name, @"John");
}

- (void)test_setValue_forKey_or_setValue_forKeyPath {
    Person *p = [Person new];
    
    [p setValue:@"John" forKey:@"name"];
    XCTAssertEqualObjects(p.name, @"John");
    
    [p setValue:@"Jay" forKeyPath:@"self.name"];
    XCTAssertEqualObjects(p.name, @"Jay");
}

#pragma mark - Collection Operators

#pragma mark > @avg

- (void)test_avg {
    NSNumber *output;
    
    // Case 1
    output = [self.transactions valueForKeyPath:@"@avg.amount"];
    XCTAssertTrue([output isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(output, @(16));
    
    // Case 2: keyPath supports primitive type
    output = [self.transactions valueForKeyPath:@"@avg.balance"];
    XCTAssertTrue([output isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(output, @(16));
    
    // Abnormal Case 1: property not found
    // @see https://stackoverflow.com/a/30135115
    XCTAssertThrowsSpecificNamed([self.transactionsMalformed valueForKeyPath:@"@avg.amount"], NSException, @"NSUnknownKeyException");
    
    // Abnormal Case 2: property value not support the operator
    XCTAssertThrowsSpecificNamed([self.transactions valueForKeyPath:@"@avg.payee"], NSException, @"NSDecimalNumberOverflowException");
}

#pragma mark > @count

- (void)test_count {
    NSNumber *output;
    
    // Case 1
    output = [self.transactions valueForKeyPath:@"@count"];
    XCTAssertTrue([output isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(output, @([self.transactions count]));
}

#pragma mark > @max

- (void)test_max {
    id output;
    
    // Case 1
    output = [self.transactions valueForKeyPath:@"@max.date"];
    XCTAssertTrue([output isKindOfClass:[NSDate class]]);
    XCTAssertEqualObjects(output, [NSDate dateWithTimeIntervalSince1970:100]);
}

#pragma mark > @min

- (void)test_min {
    id output;
    
    // Case 1
    output = [self.transactions valueForKeyPath:@"@min.date"];
    XCTAssertTrue([output isKindOfClass:[NSDate class]]);
    XCTAssertEqualObjects(output, [NSDate dateWithTimeIntervalSince1970:20]);
}

#pragma mark > @sum

- (void)test_sum {
    NSNumber *output;
    
    // Case 1
    output = [self.transactions valueForKeyPath:@"@sum.amount"];
    XCTAssertTrue([output isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(output, @(64));
}

#pragma mark > @distinctUnionOfObjects

- (void)test_distinctUnionOfObjects {
    NSArray *output;
    id expected;
    
    // Case 1
    output = [self.transactions valueForKeyPath:@"@distinctUnionOfObjects.payee"];
    XCTAssertTrue([output isKindOfClass:[NSArray class]]);
    
    expected = [NSSet setWithArray:@[@"John", @"Lily", @"Lucy"]];
    XCTAssertEqualObjects([NSSet setWithArray:output], expected);
}

#pragma mark > @unionOfObjects

- (void)test_unionOfObjects {
    NSArray *output;
    id expected;
    
    // Case 1
    output = [self.transactions valueForKeyPath:@"@unionOfObjects.payee"];
    XCTAssertTrue([output isKindOfClass:[NSArray class]]);
    
    // @see https://stackoverflow.com/a/15732286
    expected = [[NSCountedSet alloc] initWithArray:@[@"John", @"Lily", @"Lucy", @"Lily"]];
    XCTAssertEqualObjects([[NSCountedSet alloc] initWithArray:output], expected);
}

#pragma mark > @distinctUnionOfArrays

- (void)test_distinctUnionOfArrays {
    NSArray *output;
    id expected;
    
    // Case 1
    output = [@[self.transactions,
                @[
                    [Transaction transactionWithPayee:@"John" amount:@(4) date:[NSDate dateWithTimeIntervalSince1970:20]],
                    [Transaction transactionWithPayee:@"Lily" amount:@(30) date:[NSDate dateWithTimeIntervalSince1970:60]],
                    [Transaction transactionWithPayee:@"Tom" amount:@(36) date:[NSDate dateWithTimeIntervalSince1970:20]],
                    [Transaction transactionWithPayee:@"Sam" amount:@(9) date:[NSDate dateWithTimeIntervalSince1970:60]],
                    ]
                ]
              valueForKeyPath:@"@distinctUnionOfArrays.payee"];
    XCTAssertTrue([output isKindOfClass:[NSArray class]]);
    
    expected = [[NSCountedSet alloc] initWithArray:@[@"John", @"Lily", @"Lucy", @"Tom", @"Sam"]];
    XCTAssertEqualObjects([[NSCountedSet alloc] initWithArray:output], expected);
}

#pragma mark > @unionOfArrays

- (void)test_unionOfArrays {
    NSArray *output;
    id expected;
    
    // Case 1
    output = [@[self.transactions,self.transactions] valueForKeyPath:@"@unionOfArrays.payee"];
    XCTAssertTrue([output isKindOfClass:[NSArray class]]);
    
    // @see https://stackoverflow.com/a/15732286
    expected = [[NSCountedSet alloc] initWithArray:@[@"John", @"Lily", @"Lucy", @"Lily", @"John", @"Lily", @"Lucy", @"Lily"]];
    XCTAssertEqualObjects([[NSCountedSet alloc] initWithArray:output], expected);
}

#pragma mark > @distinctUnionOfSets

- (void)test_distinctUnionOfSets {
    
}

#pragma mark - Exception

- (void)test_valueForKey_or_valueForKeyPath_exception {
    Person *p = [Person new];
    p.name = @"John";
    
    XCTAssertThrows([p valueForKey:@"name2"]);
    XCTAssertThrows([p valueForKeyPath:@"self.name2"]);
}

- (void)test_setValue_forKey_or_setValue_forKeyPath_exception {
    Person *p = [Person new];
    
    XCTAssertThrows([p setValue:@"John" forKey:@"name2"]);
    XCTAssertThrows([p setValue:@"Jay" forKeyPath:@"self.name2"]);
}

@end
