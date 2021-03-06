//
//  WCFileManagerTool.h
//  HelloNSFileManager
//
//  Created by wesley_chen on 2018/7/21.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSFileAttributeKey const WCFileName;

@interface WCFileManagerTool : NSObject

@end

@interface WCFileManagerTool ()

#pragma mark - File

#pragma mark > File Creation

/**
 Create a new file with content. And if the parent folders is not existing, create them if needed.

 @param path    the absolute file path started by root path '/'
 @param content the text of the content
 @return YES if created successfully, or NO if it failed
 
 @warning <br/>1. the path NOT support the '~' tilde symbol, use stringByExpandingTildeInPath method to expand it.
          <br/>2. the new file will overwrite the existing file.
 @note stringByExpandingTildeInPath expand  '~' decided by current environment, so '~' is NOT the same path always.
 */
+ (BOOL)createNewFileAtPath:(NSString *)path content:(NSString *)content overwrite:(BOOL)overwrite;

/**
 Create an empty file. And if the parent folders is not existing, create them if needed.

 @param path the path of a file
 @return YES if created successfully, or NO if it failed
 */
+ (BOOL)createNewFileAtPath:(NSString *)path overwrite:(BOOL)overwrite;

+ (BOOL)copyFileAtPath:(NSString *)filePath toDirectoryPath:(NSString *)directoryPath overwrite:(BOOL)overwrite;

/**
 Copy a file from source path to destination path

 @param filePath the source file path
 @param destPath the destination file path
 @param overwrite YES, will overwrite the existing one. NO, will not overwrite if have an existing one.
 @return YES if copy successufully, NO if failed.
 */
+ (BOOL)copyFileAtPath:(NSString *)filePath toPath:(NSString *)destPath overwrite:(BOOL)overwrite;

#pragma mark > File Deletion

/**
 Delete a file only

 @param path the path of a file
 @return YES if deleted successfully or NO if 1. deletion failed, or 2. the path is a directory, or 3. the path is not existed
 */
+ (BOOL)deleteFileAtPath:(NSString *)path;

#pragma mark > File Filter
// http://stackoverflow.com/questions/499673/getting-a-list-of-files-in-a-directory-with-a-glob

#pragma mark > File Check

/**
 Check a file if exists

 @param path the path of file
 @return YES if the file exists, or NO if the file not exists or it's a directory
 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

#pragma mark > File Attributes

/**
 Get creation date of file

 @param path the path of file
 @return If nil, path is not a file or the file not exists
 */
+ (NSDate *)creationDateOfFileAtPath:(NSString *)path;

/**
 Get modified date of file

 @param path the path of file
 @return If nil, path is not a file or the file not exists
 */
+ (NSDate *)modificationDateOfFileAtPath:(NSString *)path;

/**
 Get file size in bytes

 @param path the path of file
 @return the size of file in bytes. Return -1 if path is not a file or the file not exists.
 */
+ (long long)sizeOfFileAtPath:(NSString *)path;

/**
 Touch a file with a date

 @param path the path of file
 @param date the modification date
 @return YES if touched successfully. NO if the path is not a file or touched failed or date is nil
 @see http://stackoverflow.com/questions/3511981/touch-a-file-update-its-modified-time-stamp
 @warning the date's sub-seconds will be lost, e.g. the passed date is 1446607039.469321 (timeIntervalSince1970), after modified, the modification date is 1446607039.000000
 */
+ (BOOL)touchFileAtPath:(NSString *)path modificationDate:(NSDate *)date;

#pragma mark > File Display Name

/**
 Get display name of a file

 @param path the path of file
 @return nil if the path is not a file or the path not exists
 */
+ (NSString *)fileNameAtPath:(NSString *)path;

#pragma mark > File Name Sort

/**
 Get a sorted file names in the directory not recursively

 @param directoryPath the path of directory
 @param ascend YES if ascend, NO if descend
 @return the sorted file names
 */
+ (NSArray *)sortedFileNamesInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFileNamesByCreationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFileNamesByModificationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFileNamesBySizeInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFileNamesByExtensionInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;

/**
 Get a sorted file names by attribute in the directory not recursively

 @param attributeName the attribute, e.g. WCFileName, NSFileCreationDate,
 @param directoryPath the path of directory
 @param ascend YES if ascend, NO if descend
 @return the sorted file names including the file extension
 */
+ (NSArray *)sortedFileNamesWithAttributeName:(NSString *)attributeName inDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;

#pragma mark > File Name Filter

/**
 Get a filtered file names in the directory not recursively

 @param directoryPath the path of directory
 @param ascend YES if ascend, NO if descend
 @param extensions the array of extension (without `.`) whose are included
 @return the filtered and sorted file names
 */
+ (NSArray *)filteredFileNamesInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend extensions:(NSArray<NSString *> *)extensions;

#pragma mark > File Path Sort

+ (NSArray *)sortedFilePathsByCreationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFilePathsByModificationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFilePathsBySizeInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;
+ (NSArray *)sortedFilePathsByExtensionInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend;

#pragma mark > File Path Filter


#pragma mark - Directory

#pragma mark > Directory Creation

/**
 Create a new directory

 @param path the path of a directory
 @return YES if the directory created successfully or the directory is existed, or NO if created failed
 */
+ (BOOL)createNewDirectoryIfNeededAtPath:(NSString *)path;

#pragma mark > Directory Deletion

/**
 Delete a directory only

 @param path the path of a directory
 @return YES if deleted successfully or NO if 1. deletion failed, or 2. the path is not a directory, or 3. the path is not existed
 */
+ (BOOL)deleteDirectoryAtPath:(NSString *)path;

#pragma mark > Directory Check

/**
 Check a directory if exists

 @param path the path of directory
 @return YES if the directory exists, or NO if the directory not exists or it's a file
 */
+ (BOOL)directoryExistsAtPath:(NSString *)path;

#pragma mark > Directory Attributes

/**
 Get the total size of the directory

 @param path the path of directory
 @return the total size of the directory. Return -1 if path is not a directory or the directory not exists.
 @see http://stackoverflow.com/questions/2188469/calculate-the-size-of-a-folder
 @warning If the path is a file, return -1.
 */
+ (long long)sizeOfDirectoryAtPath:(NSString *)path;

#pragma mark > Directory Display Name

+ (NSString *)directoryNameAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
