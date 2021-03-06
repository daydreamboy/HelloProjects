//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/21.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCFileTool.h"

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    [super tearDown];
    NSLog(@"\n");
}

#pragma mark - File Creation

- (void)test_createNewFileAtPath_content {
    BOOL isCreated;
    NSString *filePath;
    
    // Case 1: Create new file
    filePath = @"/Users/wesley_chen/test.txt";
    isCreated = [WCFileTool createNewFileAtPath:filePath content:@"" overwrite:NO error:nil];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    // Case 2: Create new file with the existing one
    NSString *text = @"1234";
    isCreated = [WCFileTool createNewFileAtPath:filePath content:text overwrite:NO error:nil];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    XCTAssertEqualObjects(content, text);
    
    // Case 3: Create new file at absolute path with new parent folder
    filePath = @"/Users/wesley chen/Test/test.txt";
    isCreated = [WCFileTool createNewFileAtPath:filePath content:text overwrite:NO error:nil];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    // Case 4: Create new file at relative path with new parent folder
    NSLog(@"%@", [[NSFileManager defaultManager] currentDirectoryPath]);
    
    filePath = @"test/test.txt";
    isCreated = [WCFileTool createNewFileAtPath:filePath content:text overwrite:NO error:nil];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
}

- (void)test_createNewFileAtPath {
    BOOL isSuccess;
    NSString *filePath = @"/Users/wesley chen/test.txt";
    
    isSuccess = [WCFileTool createNewFileAtPath:filePath overwrite:NO error:nil];
    XCTAssertTrue(isSuccess);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
}

#pragma mark - File Deletion

- (void)test_deleteFileAtPath {
    NSString *filePath;
    BOOL isCreated;
    BOOL isDeleted;
    
    // Case 1: Delete a normal file
    filePath = @"/Users/wesley chen/file_for_test.txt";
    isCreated =  [[NSFileManager defaultManager] createFileAtPath:filePath contents:[@"123" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    isDeleted = [WCFileTool deleteFileAtPath:filePath];
    XCTAssertTrue(isDeleted);
    
    // Case 2: Delete a non-existed file
    filePath = @"/Users/wesley chen/file_not_exists.txt";
    isDeleted = [WCFileTool deleteFileAtPath:filePath];
    XCTAssertFalse(isDeleted);
    
    filePath = @"/Users/wesley chen/Test";
    isDeleted = [WCFileTool deleteFileAtPath:filePath];
}

#pragma mark - File Check

- (void)test_fileExistsAtPath {
    BOOL isExisted;
    NSString *filePath;
    
    // Case 1: Check directory existed
    filePath = @"/Users/wesley chen/";
    isExisted = [WCFileTool fileExistsAtPath:filePath];
    
    XCTAssertTrue(isExisted);
    
    // Case 2: Check file existed
    filePath = @"/Applications/iTunes.app/Contents/Info.plist";
    isExisted = [WCFileTool fileExistsAtPath:filePath];
    
    XCTAssertTrue(isExisted);
}

#pragma mark > File Attributes

- (void)test_sizeOfFileAtPath {
    NSString *filePath;
    unsigned long long size;
    
    // Case 1
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"3" ofType:@"txt"];
    size = [WCFileTool sizeOfFileAtPath:filePath];
    XCTAssertTrue(size == 0);
}

#pragma mark - File Name Sort

- (void)test_sortedFileNamesByCreateDateInDirectoryPath_ascend {
    
}

- (void)test_sorted {
    
}

#pragma mark - File Path Sort


#pragma mark - Directory Creation

- (void)test_createNewDirectoryAtPath {
    
    BOOL isCreated;
    NSString *path;
    
    // Case 1:
    path = @"/Users/wesley chen/Test1/Test2";
    isCreated = [WCFileTool createNewDirectoryIfNeededAtPath:path error:nil];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);
    
    path = [path stringByDeletingLastPathComponent];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);
}

#pragma mark - Directory Deletion

@end
