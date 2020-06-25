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

#pragma mark - Issues

- (void)test_imageWithContentsOfFile_issue_lazy_load_image {
    NSData *data;
    
    NSString *newFilePath = [[self.class appDocumentsDirectory] stringByAppendingPathComponent:@"test.png"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"fake" ofType:@"png"];
    [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:newFilePath error:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:newFilePath]) {
        UIImage *image = [UIImage imageWithContentsOfFile:newFilePath]; // ISSUE: the image file maybe delete afterward
        data = UIImagePNGRepresentation(image);
        XCTAssertNotNil(data);
        
        [[NSFileManager defaultManager] removeItemAtPath:newFilePath error:nil];
        
        XCTAssertNotNil(image);
        data = UIImagePNGRepresentation(image);
        XCTAssertNil(data);
    }
}

- (void)test_imageWithContentsOfFile_issue_lazy_load_image_solution {
    NSData *data;
    
    NSString *newFilePath = [[self.class appDocumentsDirectory] stringByAppendingPathComponent:@"test.png"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"fake" ofType:@"png"];
    [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:newFilePath error:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:newFilePath]) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:newFilePath]]; // instead of [UIImage imageWithContentsOfFile:newFilePath];
        data = UIImagePNGRepresentation(image);
        XCTAssertNotNil(data);
        
        [[NSFileManager defaultManager] removeItemAtPath:newFilePath error:nil];
        
        XCTAssertNotNil(image);
        data = UIImagePNGRepresentation(image);
        XCTAssertNotNil(data);
    }
}

- (void)test_imageWithContentsOfFile_issue_load_wrong_image {
    NSString *filePath;
    UIImage *image;
    
    // Note: Make sure fake.png and fake@x.png both exists in app
    
    // Case 1
    NSString *filename = @"fake.png";
    filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
    image = [UIImage imageWithContentsOfFile:filePath];
    
    NSLog(@"filePath1: %@", filePath);
    NSLog(@"image1: %@", image);
    
    // Case 2
    filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"fake.png"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:filePath];
    
    NSLog(@"filePath2: %@", filePath);
    NSLog(@"image2: %@", image2);
}

#pragma mark - Utility

+ (NSString *)appDocumentsDirectory {
    return [self appSearchPathDirectory:NSDocumentDirectory];
}

+ (NSString *)appSearchPathDirectory:(NSSearchPathDirectory)searchPathDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPathDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = ([paths count] > 0) ? paths[0] : nil;
    return directoryPath;
}

@end
