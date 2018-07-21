//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/21.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCFileManagerTool.h"

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
    filePath = @"/Users/wesley chen/test.txt";
    isCreated = [WCFileManagerTool createNewFileAtPath:filePath content:@"123"];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    // Case 2: Create new file with the existing one
    NSString *text = @"1234";
    isCreated = [WCFileManagerTool createNewFileAtPath:filePath content:text];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    XCTAssertEqualObjects(content, text);
    
    // Case 3: Create new file at absolute path with new parent folder
    filePath = @"/Users/wesley chen/Test/test.txt";
    isCreated = [WCFileManagerTool createNewFileAtPath:filePath content:text];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    
    // Case 4: Create new file at relative path with new parent folder
    NSLog(@"%@", [[NSFileManager defaultManager] currentDirectoryPath]);
    
    filePath = @"test/test.txt";
    isCreated = [WCFileManagerTool createNewFileAtPath:filePath content:text];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
}

- (void)test_createNewFileAtPath {
    BOOL isSuccess;
    NSString *filePath = @"/Users/wesley chen/test.txt";
    
    isSuccess = [WCFileManagerTool createNewFileAtPath:filePath];
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
    
    isDeleted = [WCFileManagerTool deleteFileAtPath:filePath];
    XCTAssertTrue(isDeleted);
    
    // Case 2: Delete a non-existed file
    filePath = @"/Users/wesley chen/file_not_exists.txt";
    isDeleted = [WCFileManagerTool deleteFileAtPath:filePath];
    XCTAssertFalse(isDeleted);
    
    filePath = @"/Users/wesley chen/Test";
    isDeleted = [WCFileManagerTool deleteFileAtPath:filePath];
}

#pragma mark - File Check

- (void)test_fileExistsAtPath {
    BOOL isExisted;
    NSString *filePath;
    
    // Case 1: Check directory existed
    filePath = @"/Users/wesley chen/";
    isExisted = [WCFileManagerTool fileExistsAtPath:filePath];
    
    XCTAssertTrue(isExisted);
    
    // Case 2: Check file existed
    filePath = @"/Applications/iTunes.app/Contents/Info.plist";
    isExisted = [WCFileManagerTool fileExistsAtPath:filePath];
    
    XCTAssertTrue(isExisted);
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
    isCreated = [WCFileManagerTool createNewDirectoryIfNeededAtPath:path];
    XCTAssertTrue(isCreated);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);
    
    path = [path stringByDeletingLastPathComponent];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:path]);
}

#pragma mark - Directory Deletion

@end
