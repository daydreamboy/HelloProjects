//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/1/2.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCImageTool.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    [super tearDown];
    NSLog(@"\n");
}

- (void)test_memoryBytesWithImage {
    UIImage *image;
    NSUInteger output;
    NSData *data;
    
    // image from https://filesamples.com/formats/bmp
    image = [UIImage imageNamed:@"sample_1920×1280.bmp"];
    output = [WCImageTool memoryBytesWithImage:image];
    data = UIImageJPEGRepresentation(image, 1);
    NSLog(@"%lu", (unsigned long)output);
    NSLog(@"%lu", (unsigned long)[data length]);
    
    // image from http://eeweb.poly.edu/~yao/EL5123/SampleData.html
    image = [UIImage imageNamed:@"lena_gray.bmp"];
    output = [WCImageTool memoryBytesWithImage:image];
    data = UIImageJPEGRepresentation(image, 1);
    NSLog(@"%lu", (unsigned long)output);
    NSLog(@"%lu", (unsigned long)[data length]);
}

- (void)test_thumbnailImageDataWithPath_boundingSize {
    NSData *output;
    NSData *data;
    NSString *imagePath;
    UIImage *thumbnailImage;
    
    // Case 1
    imagePath = [[NSBundle mainBundle] pathForResource:@"sample_1920×1280" ofType:@"bmp"];
    data = [NSData dataWithContentsOfFile:imagePath];
    output = [WCImageTool thumbnailImageDataWithData:data boundingSize:CGSizeMake(1024, 1024)];
    
    thumbnailImage = [UIImage imageWithData:output];
    XCTAssertNotNil(thumbnailImage);
    NSLog(@"%@", thumbnailImage);
}

@end
