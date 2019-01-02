//
//  Tests_UIImage.m
//  Tests
//
//  Created by wesley_chen on 2019/1/2.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_UIImage : XCTestCase

@end

@implementation Tests_UIImage

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_imageWithData {
    NSData *data;
    UIImage *image;
    
    image = [UIImage imageWithData:data];
    XCTAssertNil(image);
}

@end
