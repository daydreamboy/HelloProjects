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

- (void)test_imageSizeWithPath_scale {
    NSData *output;
    NSData *data;
    NSString *imagePath;
    UIImage *thumbnailImage;
    id object;
    
    // Case 1
    imagePath = [[NSBundle mainBundle] pathForResource:@"heic" ofType:@"heic"];
    object = [WCImageTool imagePropertiesWithPath:imagePath];
    NSLog(@"%@", object);
    
    // Case 2
    imagePath = [[NSBundle mainBundle] pathForResource:@"bmp" ofType:@"bmp"];
    object = [WCImageTool imagePropertiesWithPath:imagePath];
    NSLog(@"%@", object);
    
    // Case 3
    imagePath = [[NSBundle mainBundle] pathForResource:@"jpg" ofType:@"jpeg"];
    object = [WCImageTool imagePropertiesWithPath:imagePath];
    NSLog(@"%@", object);
    
    // Case 4
    imagePath = [[NSBundle mainBundle] pathForResource:@"png" ofType:@"png"];
    object = [WCImageTool imagePropertiesWithPath:imagePath];
    NSLog(@"%@", object);
    
    // Case 5
    imagePath = [[NSBundle mainBundle] pathForResource:@"gif" ofType:@"gif"];
    object = [WCImageTool imagePropertiesWithPath:imagePath];
    NSLog(@"%@", object);
}

- (void)test_ {
    NSData *output;
    NSData *data;
    NSString *imagePath;
    UIImage *thumbnailImage;
    id object;
    
    // Case 1
    imagePath = [[NSBundle mainBundle] pathForResource:@"big_1" ofType:@"gif"];
    data = [NSData dataWithContentsOfFile:imagePath];
    output = [WCImageTool thumbnailAnimatedImageDataWithData:data path:nil boundingSize:CGSizeMake(300, 300) scale:1];
    
    [self.class dumpData:output outputToFileName:nil extension:@"gif"];
    
    NSLog(@"%@", object);
}

+ (BOOL)dumpData:(NSData *)data outputToFileName:(nullable NSString *)fileName extension:(nullable NSString *)extension {
    if (![data isKindOfClass:[NSData class]]) {
        return NO;
    }
    
    if (fileName && ![fileName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (extension && ![extension isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString *filePath;
    NSString *userHomeFileName = fileName.length
    ? [fileName stringByAppendingPathExtension:(extension.length > 0 ? extension : @"")]
    : [NSString stringWithFormat:@"lldb_output_%f.%@", [[NSDate date] timeIntervalSince1970], (extension.length > 0 ? extension : @"")];
    
#if TARGET_OS_SIMULATOR
    NSString *appHomeDirectoryPath = [@"~" stringByExpandingTildeInPath];
    NSArray *pathParts = [appHomeDirectoryPath componentsSeparatedByString:@"/"];
    if (pathParts.count < 2) {
        return NO;
    }
    
    NSMutableArray *components = [NSMutableArray arrayWithObject:@"/"];
    // Note: pathParts is @"", @"Users", @"<your name>", ...
    [components addObjectsFromArray:[pathParts subarrayWithRange:NSMakeRange(1, 2)]];
    [components addObject:userHomeFileName];
    
    filePath = [NSString pathWithComponents:components];
#else
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:userHomeFileName];
#endif
    
    BOOL success = [data writeToFile:filePath atomically:YES];
    
    return success;
}

@end
