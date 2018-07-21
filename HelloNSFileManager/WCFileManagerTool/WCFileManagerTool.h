//
//  WCFileManagerTool.h
//  HelloNSFileManager
//
//  Created by wesley_chen on 2018/7/21.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WCFileManagerTool : NSObject

#pragma mark - File Creation

+ (BOOL)createNewFileAtPath:(NSString *)path content:(NSString *)content;
+ (BOOL)createNewFileAtPath:(NSString *)path;
+ (BOOL)copyFileAtPath:(NSString *)filePath toDirectoryPath:(NSString *)directoryPath;
+ (BOOL)copyFileAtPath:(NSString *)filePath toPath:(NSString *)destPath;

#pragma mark - File Deletion

+ (BOOL)deleteFileAtPath:(NSString *)path;

#pragma mark - File Filter
// http://stackoverflow.com/questions/499673/getting-a-list-of-files-in-a-directory-with-a-glob

#pragma mark - File Check

+ (BOOL)fileExistsAtPath:(NSString *)path;

#pragma mark - File Attributes

+ (NSDate *)creationDateOfFileAtPath:(NSString *)path;
+ (NSDate *)modificationDateOfFileAtPath:(NSString *)path;
+ (unsigned long long)sizeOfFileAtPath:(NSString *)path;
+ (BOOL)touchFileAtPath:(NSString *)path modificationDate:(NSDate *)date;

#pragma mark - File Display Name

+ (NSString *)fileNameAtPath:(NSString *)path;

#pragma mark - File Name Sort

+ (NSArray *)sortedFileNamesByCreationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFileNamesByModificationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFileNamesBySizeInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFileNamesByExtensionInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;

#pragma mark - File Path Sort

+ (NSArray *)sortedFilePathsByCreationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFilePathsByModificationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFilePathsBySizeInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFilePathsByExtensionInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;

#pragma mark - Directory Creation

+ (BOOL)createNewDirectoryIfNeededAtPath:(NSString *)path;

#pragma mark - Directory Deletion

+ (BOOL)deleteDirectoryAtPath:(NSString *)path;

#pragma mark - Directory Check

+ (BOOL)directoryExistsAtPath:(NSString *)path;

#pragma mark - Directory Attributes

+ (unsigned long long)sizeOfDirectoryAtPath:(NSString *)path;

#pragma mark - Directory Display Name

+ (NSString *)directoryNameAtPath:(NSString *)path;

@end
