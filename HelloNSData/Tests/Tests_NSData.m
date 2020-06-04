//
//  Tests_NSData.m
//  Tests
//
//  Created by wesley_chen on 2020/6/4.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

#define STR_OF_RANGE(range) (NSStringFromRange(range))

@interface Tests_NSData : XCTestCase

@end

@implementation Tests_NSData

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_enumerateByteRangesUsingBlock {
    NSData *data = [@"ABC" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *stringM = [NSMutableString string];
    [data enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
        NSString *string = [[NSString alloc] initWithBytes:bytes length:byteRange.length encoding:NSUTF8StringEncoding];
        NSLog(@"%@", STR_OF_RANGE(byteRange));
        NSLog(@"%@", string);
        [stringM appendString:string];
    }];
}

@end
