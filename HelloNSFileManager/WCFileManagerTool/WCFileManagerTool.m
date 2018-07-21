//
//  WCFileManagerTool.m
//  HelloNSFileManager
//
//  Created by wesley_chen on 2018/7/21.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCFileManagerTool.h"


// DEBUG_LOG
#ifndef DEBUG_LOG
#define DEBUG_LOG 1
#endif

// WCLog
#if DEBUG_LOG
#   define WCLog(fmt, ...) NSLog(fmt, ## __VA_ARGS__)
#else
#   define WCLog(fmt, ...)
#endif

@implementation WCFileManagerTool

#pragma mark - File Creation

/**
 *  Create a new file with content. And if the parent folders is not existing, create them if needed.
 *
 *  @param path    the absolute file path started by root path '/'
 *  @param content the text of the content
 *
 *  @warning <br/>1. the path NOT support the '~' tilde symbol, use stringByExpandingTildeInPath method to expand it.
 *           <br/>2. the new file will overwrite the existing file.
 *  @note stringByExpandingTildeInPath expand  '~' decided by current environment, so '~' is NOT the same path always.
 *
 *  @return YES if created successfully, or NO if it failed
 */
+ (BOOL)createNewFileAtPath:(NSString *)path content:(NSString *)content {
    NSString *parentFolderPath = [path stringByDeletingLastPathComponent];
    NSString *directoryPath = [parentFolderPath hasPrefix:@"/"]
    ? parentFolderPath
    : [NSString stringWithFormat:@"%@/%@", [[NSFileManager defaultManager] currentDirectoryPath], parentFolderPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:NULL]) {
        // The directoryPath doesn't exist, just create the directory
        if (![[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            // The parent folder is created failed, if not just ignore creating the file
            return NO;
        }
    }
    
    BOOL isFileCreated = [[NSFileManager defaultManager] createFileAtPath:path contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    if (!isFileCreated) {
        // @sa http://stackoverflow.com/questions/1860070/more-detailed-error-from-createfileatpath
        WCLog(@"Error code: %d - message: %s", errno, strerror(errno));
    }
    
    return isFileCreated;
}

/**
 *  Create an empty file. And if the parent folders is not existing, create them if needed.
 *
 *  @param path the path of a file
 *
 *  @return YES if created successfully, or NO if it failed
 */
+ (BOOL)createNewFileAtPath:(NSString *)path {
    return [self createNewFileAtPath:path content:nil];
}

+ (BOOL)copyFileAtPath:(NSString *)filePath toDirectoryPath:(NSString *)directoryPath {
    NSString *fileName = [filePath lastPathComponent];
    NSString *destPath = [directoryPath stringByAppendingPathComponent:fileName];
    return [self copyFileAtPath:filePath toPath:destPath];
}

+ (BOOL)copyFileAtPath:(NSString *)filePath toPath:(NSString *)destPath {
#define CheckErrorAndBreak(error) { if (error) { break; } }
    NSError *error;
    BOOL success;
    
    do {
        NSString *directoryPath = [destPath stringByDeletingLastPathComponent];
        success = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        CheckErrorAndBreak(error);
        
        success = [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destPath error:&error];
        CheckErrorAndBreak(error);
    } while (NO);
    
    return success;
#undef CheckErrorAndBreak
}

+ (BOOL)moveFileAtPath:(NSString *)filePath toDirectoryPath:(NSString *)directoryPath {
    NSString *fileName = [filePath lastPathComponent];
    NSString *destPath = [directoryPath stringByAppendingPathComponent:fileName];
    return [self moveFileAtPath:filePath toPath:destPath];
}

+ (BOOL)moveFileAtPath:(NSString *)filePath toPath:(NSString *)destPath {
#define CheckErrorAndBreak(error) { if (error) { break; } }
    NSError *error;
    BOOL success;
    
    do {
        NSString *directoryPath = [destPath stringByDeletingLastPathComponent];
        success = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        CheckErrorAndBreak(error);
        
        success = [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:destPath error:&error];
        CheckErrorAndBreak(error);
    } while (NO);
    
    return success;
#undef CheckErrorAndBreak
}

#pragma mark - File Deletion

/**
 *  Delete a file only
 *
 *  @param path the path of a file
 *
 *  @return YES if deleted successfully or NO if 1. deletion failed, or 2. the path is a directory, or 3. the path is not existed
 */
+ (BOOL)deleteFileAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
        // If the path is a directory, don't delete the directory
        return NO;
    }
    
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    return NO;
}

#pragma mark - File Check

/**
 *  Check a file if exists
 *
 *  @param path the path of file
 *
 *  @return YES if the file exists, or NO if the file not exists or it's a directory
 */
+ (BOOL)fileExistsAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory) {
        // If the path is a directory, no file at the path exists
        return NO;
    }
    
    return isExisted;
}

#pragma mark - File Name Sort

+ (NSArray *)sortedFileNamesByCreationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    NSArray *sortedFileNames = [self sortedFileNamesWithAttributeName:NSFileCreationDate inDirectoryPath:directoryPath ascend:ascend];
    
    return sortedFileNames;
}

+ (NSArray *)sortedFileNamesByModificationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    NSArray *sortedFileNames = [self sortedFileNamesWithAttributeName:NSFileModificationDate inDirectoryPath:directoryPath ascend:ascend];
    
    return sortedFileNames;
}

+ (NSArray *)sortedFileNamesBySizeInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    NSArray *sortedFileNames = [self sortedFileNamesWithAttributeName:NSFileSize inDirectoryPath:directoryPath ascend:ascend];
    
    return sortedFileNames;
}

+ (NSArray *)sortedFileNamesByExtensionInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    // TODO:
    return nil;
}

#pragma mark - File Path Sort

+ (NSArray *)sortedFilePathsByCreationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    NSArray *sortedFilePaths = [self sortedFilePathsWithAttributeName:NSFileCreationDate inDirectoryPath:directoryPath ascend:ascend];
    
    return sortedFilePaths;
}

+ (NSArray *)sortedFilePathsByModificationDateInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    NSArray *sortedFilePaths = [self sortedFilePathsWithAttributeName:NSFileModificationDate inDirectoryPath:directoryPath ascend:ascend];
    
    return sortedFilePaths;
}

+ (NSArray *)sortedFilePathsBySizeInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    NSArray *sortedFilePaths = [self sortedFilePathsWithAttributeName:NSFileSize inDirectoryPath:directoryPath ascend:ascend];
    
    return sortedFilePaths;
}

+ (NSArray *)sortedFilePathsByExtensionInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    // TODO:
    return nil;
}

#pragma mark - File Attributes

/**
 *  Get creation date of file
 *
 *  @param path the path of file
 *
 *  @return If nil, path is not a file or the file not exists
 */
+ (NSDate *)creationDateOfFileAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory || !isExisted) {
        // If the path is a directory, no file at the path exists
        return nil;
    }
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    return attributes[NSFileCreationDate];
}

/**
 *  Get modified date of file
 *
 *  @param path the path of file
 *
 *  @return If nil, path is not a file or the file not exists
 */
+ (NSDate *)modificationDateOfFileAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory || !isExisted) {
        // If the path is a directory, no file at the path exists
        return nil;
    }
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    return attributes[NSFileModificationDate];
}

/**
 *  Get file size in bytes
 *
 *  @param path the path of file
 *
 *  @return the size of file in bytes. If 0, path is not a file or the file not exists
 */
+ (unsigned long long)sizeOfFileAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory || !isExisted) {
        // If the path is a directory, or no file at the path exists
        return 0;
    }
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    return [attributes[NSFileSize] unsignedLongLongValue];
}

/**
 *  Touch a file with a date
 *
 *  @param path the path of file
 *  @param date the modification date
 *
 *  @sa http://stackoverflow.com/questions/3511981/touch-a-file-update-its-modified-time-stamp
 *  @warning the date's sub-seconds will be lost, e.g. the passed date is 1446607039.469321 (timeIntervalSince1970), after modified, the modification date is 1446607039.000000
 *
 *  @return YES if touched successfully. NO if the path is not a file or touched failed or date is nil
 */
+ (BOOL)touchFileAtPath:(NSString *)path modificationDate:(NSDate *)date {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory || !isExisted || !date) {
        // If the path is a directory, no file at the path exists
        return NO;
    }
    
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] setAttributes:@{NSFileModificationDate: date} ofItemAtPath:path error:&error];
    WCLog(@"%@", success ? @"" : error.localizedDescription);
    
    return success;
}

#pragma mark - File Display Name

/**
 *  Get display name of a file
 *
 *  @param path the path of file
 *
 *  @return nil if the path is not a file or the path not exists
 */
+ (NSString *)fileNameAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory || !isExisted) {
        // If the path is a directory, no file at the path exists
        return nil;
    }
    
    return [[NSFileManager defaultManager] displayNameAtPath:path];
}

#pragma mark - Directory Creation

/**
 *  Create a new directory
 *
 *  @param path the path of a directory
 *
 *  @return YES if the directory created successfully or the directory is existed, or NO if created failed
 */
+ (BOOL)createNewDirectoryIfNeededAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}

#pragma mark - Directory Deletion

/**
 *  Delete a directory only
 *
 *  @param path the path of a directory
 *
 *  @return YES if deleted successfully or NO if 1. deletion failed, or 2. the path is not a directory, or 3. the path is not existed
 */
+ (BOOL)deleteDirectoryAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (!isDirectory || !isExisted) {
        // If the path is a file, or the path not exists
        return NO;
    }
    
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark - Directory Check

/**
 *  Check a directory if exists
 *
 *  @param path the path of directory
 *
 *  @return YES if the directory exists, or NO if the directory not exists or it's a file
 */
+ (BOOL)directoryExistsAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    return (isDirectory && isExisted) ? YES : NO;
}

#pragma mark - Directory Display Name

+ (NSString *)directoryNameAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (!isDirectory || !isExisted) {
        // If the path is a file, or the path not exists
        return nil;
    }
    
    return [[NSFileManager defaultManager] displayNameAtPath:path];
}

#pragma mark - Directory Attributes

/*!
 *  Get the total size of the directory
 *
 *  @warning If the path is a file, won't return the size of the file
 *  @see http://stackoverflow.com/questions/2188469/calculate-the-size-of-a-folder
 */
+ (unsigned long long)sizeOfDirectoryAtPath:(NSString *)path {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

#pragma mark - Internal Methods

+ (NSArray *)sortedFileNamesWithAttributeName:(NSString *)attributeName inDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    
    NSArray *sortedFileNames = [fileNames sortedArrayUsingComparator:^NSComparisonResult (NSString *fileName1, NSString *fileName2) {
        NSString *filePath1 = [directoryPath stringByAppendingPathComponent:fileName1];
        NSString *filePath2 = [directoryPath stringByAppendingPathComponent:fileName2];
        
        NSDictionary *attributes1 = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath1
                                                                                     error:nil];
        NSDictionary *attributes2 = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath2
                                                                                     error:nil];
        
        id attribute1 = attributes1[attributeName];
        id attrubute2 = attributes2[attributeName];
        
        return ascend ? [attribute1 compare:attrubute2] : [attrubute2 compare:attribute1];
    }];
    
    return sortedFileNames;
}

+ (NSArray *)sortedFilePathsWithAttributeName:(NSString *)attributeName inDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    // @sa http://stackoverflow.com/questions/7440662/how-to-get-all-paths-for-files-in-documents-directory
    NSArray *filePaths = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:directoryPath error:nil];
    
    NSArray *sortedFilePaths = [filePaths sortedArrayUsingComparator:^NSComparisonResult (NSString *filePath1, NSString *filePath2) {
        NSDictionary *attributes1 = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath1
                                                                                     error:nil];
        NSDictionary *attributes2 = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath2
                                                                                     error:nil];
        
        id attribute1 = attributes1[attributeName];
        id attrubute2 = attributes2[attributeName];
        
        return ascend ? [attribute1 compare:attrubute2] : [attrubute2 compare:attribute1];
    }];
    
    return sortedFilePaths;
}

@end
