//
//  Tests_KVC.m
//  Tests
//
//  Created by wesley_chen on 2019/7/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Account.h"
#import "KVCProhibitedPerson.h"
#import "Transaction.h"
#import "ObjectWithPrimitiveProperties.h"

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

#pragma mark -

- (void)test_set_private_ivar_by_KVC {
    NSUInteger output;
    
    Person *p = [[Person alloc] initWithAge:12];
    p.name = @"John";
    
    [p setValue:@"1" forKey:@"age"];
    output = p.age;
    XCTAssertTrue(output == 1);
    
    // Note: use _age same with age, but age is better
    [p setValue:@"2" forKey:@"_age"];
    output = p.age;
    XCTAssertTrue(output == 2);
}

- (void)test_key_vs__key_by_KVC {
    NSString *output;
    
    Person *p = [[Person alloc] init];
    p.name = @"John";
    
    output = [p valueForKey:@"name"]; // Note: call name getter method
    XCTAssertEqualObjects(output, @"John");
    
    output = [p valueForKey:@"_name"]; // Note: similar as p -> _name
    XCTAssertEqualObjects(output, @"John");
}

- (void)test_prohibited_private_ivar_by_KVC {
    NSString *output;
    
    KVCProhibitedPerson *p = [[KVCProhibitedPerson alloc] initWithAge:@"12"];
    p.name = @"John";
    
    XCTAssertThrows([p setValue:@"1" forKey:@"age"]);
    output = p.age;
    XCTAssertEqualObjects(output, @"12");
    
    // Note: use _age same with age, but age is better
    XCTAssertThrows([p setValue:@"2" forKey:@"_age"]);
    output = p.age;
    XCTAssertEqualObjects(output, @"12");
    
    XCTAssertThrows([p valueForKey:@"_age"]); //  [<KVCProhibitedPerson 0x600000338780> valueForUndefinedKey:]: this class is not key value coding-compliant for the key _age. (NSUnknownKeyException)
    output = [p valueForKey:@"age"]; // Ok
    XCTAssertEqualObjects(output, @"12");
}

#pragma mark - NSKeyValueCoding Relation

- (void)test_attribute_properties {
    id output;
    
    // @see https://stackoverflow.com/a/18036038
    ObjectWithPrimitiveProperties *object;
    
    int integerNumber = 5;
    CGSize size = CGSizeMake(100, 100);
    
    // Case 1: set primitive value by setValue:forKey:
    object = [ObjectWithPrimitiveProperties new];
    [object setValue:[NSNumber numberWithInt:integerNumber] forKey:@"integerNumber"];
    XCTAssertTrue(object.integerNumber == integerNumber);
    
    // Case 2: set primitive value by setValue:forKey:
    object = [ObjectWithPrimitiveProperties new];
    [object setValue:[NSValue valueWithCGSize:size] forKey:@"size"];
    XCTAssertTrue(CGSizeEqualToSize(object.size, size));
    
    // Case 3:
    object = [ObjectWithPrimitiveProperties new];
    object.integerNumber = 10;
    
    output = [object valueForKey:@"integerNumber"];
    XCTAssertEqualObjects(output, @(10));
}

- (void)test_to_one_properties {
    id output;
    
    // Case 1: valueForKey: not copy object
    Person *p = [[Person alloc] init];
    Account *basicAccount = [Account new];
    p.basicAccount = basicAccount;
    output = [p valueForKey:@"basicAccount"];
    XCTAssertTrue(output == basicAccount);
    
    // Case 2: setValue:forKey: not copy object
    Account *basicAccount2 = [Account new];
    [p setValue:basicAccount2 forKey:@"basicAccount"];
    XCTAssertTrue(p.basicAccount == basicAccount2);
}

- (void)test_to_many_properties {
    NSArray *output;
    
    Person *p = [[Person alloc] init];
    
    // Case 1: get nil value of to-many property
    output = [p valueForKey:@"accounts"];
    XCTAssertNil(output);
    
    // Case 2: get value of to-many property
    p.accounts = [@[] mutableCopy];
    output = [p valueForKey:@"accounts"];
    XCTAssertNotNil(output);
    XCTAssertTrue(output.count == 0);
    
    // Case 3: set value of to-many property
    [p setValue:@[[Account new]] forKey:@"accounts"];
    output = [p valueForKey:@"accounts"];
    XCTAssertNotNil(output);
    XCTAssertTrue(output.count == 1);
}

- (void)test_to_many_properties_use_proxy_mutable_collection {
    Person *p = [[Person alloc] init];
    NSMutableArray *proxyMutableArray;
    
    // Case 1: Get proxy mutable collection
    proxyMutableArray = [p mutableArrayValueForKey:@"accounts"];
    XCTAssertTrue([proxyMutableArray isKindOfClass:[NSMutableArray class]]);
    
    // Error: if accounts is nil, output.count will throw exception internally
    XCTAssertThrowsSpecificNamed(proxyMutableArray.count, NSException, NSInternalInconsistencyException);

    // Case 2: ok, accounts has initialized with empty
    p.accounts = [@[] mutableCopy];
    proxyMutableArray = [p mutableArrayValueForKey:@"accounts"];
    XCTAssertTrue([proxyMutableArray isKindOfClass:[NSMutableArray class]]);
    XCTAssertTrue(proxyMutableArray.count == 0);
    
    // Case 3: add account by public API addAccount:
    [p addAccount:[Account new]];
    proxyMutableArray = [p mutableArrayValueForKey:@"accounts"];
    XCTAssertTrue([proxyMutableArray isKindOfClass:[NSMutableArray class]]);
    XCTAssertTrue(proxyMutableArray.count == 1);
    
    // Case 4: add account by proxy mutable collection
    proxyMutableArray = [p mutableArrayValueForKey:@"accounts"];
    [proxyMutableArray addObject:[Account new]];
    XCTAssertTrue([proxyMutableArray isKindOfClass:[NSMutableArray class]]);
    XCTAssertTrue(proxyMutableArray.count == 2);
    
    // Case 5: add more item for immutable array
    [p setValue:@[[Account new]] forKey:@"frozenAccounts"];
    proxyMutableArray = [p mutableArrayValueForKey:@"frozenAccounts"];
    [proxyMutableArray addObject:[Account new]];
    XCTAssertTrue(proxyMutableArray.count == 2);
    XCTAssertTrue(p.frozenAccounts.count == 2);
}

#pragma mark - NSKeyValueCoding Get/Set

#pragma mark > Get Access

- (void)test_valueForKey_on_collection_object {
    NSMutableArray *output;
    NSArray *array;
    
    // Case 2: valueForKey on collection object
    Person *p1 = [[Person alloc] init];
    p1.name = @"John";
    
    Person *p2 = [[Person alloc] init];
    p2.name = @"Lucy";
    
    array = @[p1, p2];
    output = [array valueForKey:@"name"];
    XCTAssertTrue([output isKindOfClass:[NSArray class]]);
    XCTAssertTrue(output.count == 2);
    XCTAssertEqualObjects(output[0], @"John");
    XCTAssertEqualObjects(output[1], @"Lucy");
    
    // Abnormal Case 1: unitialized properties
    Person *p3 = [[Person alloc] init];
    Person *p4 = [[Person alloc] init];
    
    array = @[p3, p4];
    output = [array valueForKey:@"name"];
    XCTAssertTrue([output isKindOfClass:[NSArray class]]);
    XCTAssertTrue(output.count == 2);
    XCTAssertEqualObjects(output[0], [NSNull null]);
    XCTAssertEqualObjects(output[1], [NSNull null]);
}

#pragma mark > Set Access

- (void)test_setValue_forKey_on_collection_object {
    NSMutableArray *output;
    NSArray *array;
    
    // Case 1: setValue:forKey: on collection object
    Person *p1 = [[Person alloc] init];
    Person *p2 = [[Person alloc] init];
    
    array = @[p1, p2];
    [array setValue:@"Anonymous" forKey:@"name"];
    
    output = [array valueForKey:@"name"];
    XCTAssertTrue(output.count == 2);
    XCTAssertEqualObjects(p1.name, @"Anonymous");
    XCTAssertEqualObjects(p2.name, @"Anonymous");
}

#pragma mark - NSKeyValueCoding Validation

- (void)test_validateValue_forKey_error {
    BOOL output;
    NSError *error;
    NSString *name;
    
    Person *person = [[Person alloc] init];
    name = nil;
    
    // Case 1: ok, both nil
    output = [person validateValue:&name forKey:@"name" error:&error];
    XCTAssertTrue(output);
    
    // Case 2
    name = @"John";
    output = [person validateValue:&name forKey:@"name" error:&error];
    XCTAssertFalse(output);

    // Case 3: ok, both value is same the string
    person.name = @"John";
    output = [person validateValue:&name forKey:@"name" error:&error];
    XCTAssertTrue(output);
    
    // Case 4: false
    NSString *object = (NSString *)[NSObject new];
    person.name = object;    
    // false, object is expected as NSString
    output = [person validateValue:&object forKey:@"name" error:&error];
    XCTAssertFalse(output);
    
    // Case 5: ok, default return YES if not implement -[Person validateAge:error:]
    output = [person validateValue:&name forKey:@"age" error:&error];
    XCTAssertTrue(output);
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
    
    NSArray *pattern = @[@5, @4, @3, @2];
    output = [pattern valueForKeyPath:@"@sum.self"];
    XCTAssertTrue([output isKindOfClass:[NSNumber class]]);
    XCTAssertEqualObjects(output, @(14));
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
