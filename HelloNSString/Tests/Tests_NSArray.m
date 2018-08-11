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
@end
