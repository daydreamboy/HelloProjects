//
//  Tests_NSArray.m
//  Tests
//
//  Created by wesley_chen on 2018/8/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Model : NSObject
@property (nonatomic, assign) NSRange range;
@end

@implementation Model
+ (instancetype)modelWithRange:(NSRange)range {
    Model *model = [Model new];
    model.range = range;
    return model;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"%@", NSStringFromRange(self.range)];
}
@end

@interface Tests_NSArray : XCTestCase

@end

@implementation Tests_NSArray

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}


- (void)test_NSArray {
    Model *m1 = [Model modelWithRange:(NSRange){3, 10}];
    Model *m2 = [Model modelWithRange:(NSRange){1, 5}];
    Model *m3 = [Model modelWithRange:(NSRange){4, 1}];
    Model *m4 = [Model modelWithRange:(NSRange){2, 15}];
    
    NSMutableArray *arrM = [NSMutableArray array];
    [arrM addObject:m1];
    [arrM addObject:m2];
    [arrM addObject:m3];
    [arrM addObject:m4];
    
    [arrM sortUsingComparator:^NSComparisonResult(Model* _Nonnull value1, Model* _Nonnull value2) {
        NSComparisonResult result = NSOrderedSame;
        if (value1.range.location > value2.range.location) {
            result = NSOrderedDescending;
        } else if (value1.range.location < value2.range.location) {
            result = NSOrderedAscending;
        }
        return result;
    }];
    
    NSLog(@"%@", arrM);
}

- (void)test {
#define not_intersect 0
    
    NSRange a;
    NSRange b;
    NSRange intersect;
    
    // Case 1
    a = NSMakeRange(0, 0);
    b = NSMakeRange(0, 1);
    
    intersect = NSIntersectionRange(a, b);
    XCTAssertTrue(intersect.length == not_intersect);
    
    // Case 2
    a = NSMakeRange(0, 0);
    b = NSMakeRange(0, 0);
    
    intersect = NSIntersectionRange(a, b);
    XCTAssertTrue(intersect.length == not_intersect);
    
    // Case 3
    a = NSMakeRange(0, 1);
    b = NSMakeRange(1, 1);
    
    intersect = NSIntersectionRange(a, b);
    XCTAssertTrue(intersect.length == not_intersect);
    
    // Case 4
    a = NSMakeRange(0, 1);
    b = NSMakeRange(0, 1);
    
    intersect = NSIntersectionRange(a, b);
    XCTAssertFalse(intersect.length == not_intersect);
    
    // Case 5
    a = NSMakeRange(0, 2);
    b = NSMakeRange(1, 1);
    
    intersect = NSIntersectionRange(a, b);
    XCTAssertFalse(intersect.length == not_intersect);
}

- (void)test2 {
    
    // Case 1
    NSString *string = @"";
    
    NSString *substring = [string substringWithRange:NSMakeRange(0, 0)];
    NSLog(@"%@", substring);
    
}
@end
