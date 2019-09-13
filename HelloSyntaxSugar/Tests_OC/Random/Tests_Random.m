//
//  Tests_Random.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/9/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_Random : XCTestCase

@end

@implementation Tests_Random

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_arc4random {
    NSUInteger count = 10000;
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        uint32_t random = arc4random();
        NSLog(@"%u", random);
        [countedSet addObject:@(random)];
    }
    
    XCTAssertTrue(countedSet.count == count);
}

- (void)test_arc4random_uniform {
    NSUInteger count = 10000;
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        uint32_t random = arc4random_uniform(100);
        XCTAssertTrue(0 <= random && random < 100);
        
        [countedSet addObject:@(random)];
    }
    
    XCTAssertTrue(countedSet.count <= 100);
}

- (void)test_drand48 {
    srand48(time(0));
    
    NSUInteger count = 10000;
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        double random = drand48();
        NSLog(@"%f", random);
        [countedSet addObject:@(random)];
    }
    
    XCTAssertTrue(countedSet.count == count);
}

@end
