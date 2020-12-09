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

#define CheckErrorAndBreak(error) { if (error) { break; } }

NSFileAttributeKey const WCFileName = @"WCFileName";

@implementation WCFileManagerTool

#pragma mark - File

#pragma mark > File Creation

+ (BOOL)createNewFileAtPath:(NSString *)path content:(NSString *)content overwrite:(BOOL)overwrite {
    if (![path isKindOfClass:[NSString class]] || ![content isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSError *error;
    BOOL success = NO;
    
    path = [path stringByExpandingTildeInPath];
    NSString *parentFolderPath = [path stringByDeletingLastPathComponent];
    NSString *directoryPath = [parentFolderPath hasPrefix:@"/"]
        ? parentFolderPath
        : [NSString stringWithFormat:@"%@/%@", [[NSFileManager defaultManager] currentDirectoryPath], parentFolderPath];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:[path lastPathComponent]];
    
    do {
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:NULL]) {
            success = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
            CheckErrorAndBreak(error);
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            if (overwrite) {
                success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
                if (!success) {
                    // @sa http://stackoverflow.com/questions/1860070/more-detailed-error-from-createfileatpath
                    WCLog(@"Error code: %d - message: %s", errno, strerror(errno));
                }
            }
        }
        else {
            success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            if (!success) {
                // @sa http://stackoverflow.com/questions/1860070/more-detailed-error-from-createfileatpath
                WCLog(@"Error code: %d - message: %s", errno, strerror(errno));
            }
        }
    } while (NO);
    
    return success;
}

+ (BOOL)createNewFileAtPath:(NSString *)path overwrite:(BOOL)overwrite {
    return [self createNewFileAtPath:path content:@"" overwrite:overwrite];
}

+ (BOOL)copyFileAtPath:(NSString *)filePath toDirectoryPath:(NSString *)directoryPath overwrite:(BOOL)overwrite {
    NSString *fileName = [filePath lastPathComponent];
    NSString *destPath = [directoryPath stringByAppendingPathComponent:fileName];
    return [self copyFileAtPath:filePath toPath:destPath overwrite:overwrite];
}

+ (BOOL)copyFileAtPath:(NSString *)filePath toPath:(NSString *)destPath overwrite:(BOOL)overwrite {
    NSError *error;
    BOOL success = NO;
    
    do {
        NSString *directoryPath = [destPath stringByDeletingLastPathComponent];
        success = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        CheckErrorAndBreak(error);
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:destPath]) {
            if (overwrite) {
                success = [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
                CheckErrorAndBreak(error);
                
                success = [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destPath error:&error];
                CheckErrorAndBreak(error);
            }
        }
        else {
            success = [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:destPath error:&error];
            CheckErrorAndBreak(error);
        }
        
    } while (NO);
    
    return success;
}

+ (BOOL)moveFileAtPath:(NSString *)filePath toDirectoryPath:(NSString *)directoryPath {
    NSString *fileName = [filePath lastPathComponent];
    NSString *destPath = [directoryPath stringByAppendingPathComponent:fileName];
    return [self moveFileAtPath:filePath toPath:destPath];
}

+ (BOOL)moveFileAtPath:(NSString *)filePath toPath:(NSString *)destPath {
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
}

#pragma mark > File Deletion

+ (BOOL)deleteFileAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
        // If the path is a directory, don't delete the directory
        return NO;
    }
    
    NSError *error;
    BOOL success = NO;
    
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    
    return success;
}

#pragma mark > File Check

+ (BOOL)fileExistsAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory) {
        // If the path is a directory, no file at the path exists
        return NO;
    }
    
    return isExisted;
}

#pragma mark > File Name Sort

+ (NSArray *)sortedFileNamesInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    NSArray *sortedFileNames = [self sortedFileNamesWithAttributeName:WCFileName inDirectoryPath:directoryPath ascend:ascend];
    
    return sortedFileNames;
}

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

+ (NSArray *)sortedFileNamesWithAttributeName:(NSString *)attributeName inDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend {
    // Note: Get current item not recursively
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    
    if ([attributeName isEqualToString:WCFileName]) {
        NSArray *sortedFileNames = [fileNames sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull fileName1, NSString * _Nonnull fileName2) {
            return ascend ? [fileName1 localizedCompare:fileName2] : [fileName2 localizedCompare:fileName1];
        }];
        return sortedFileNames;
    }
    else {
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
}

#pragma mark > File Name Filter

+ (NSArray *)filteredFileNamesInDirectoryPath:(NSString *)directoryPath ascend:(BOOL)ascend extensions:(NSArray<NSString *> *)extensions {
    NSArray *sortedFileNames = [self sortedFileNamesInDirectoryPath:directoryPath ascend:ascend];
    
    NSMutableArray<NSPredicate *> *subpredicates = [NSMutableArray array];
    for (NSString *extension in extensions) {
        // @see https://stackoverflow.com/a/6921590
        [subpredicates addObject:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self ENDSWITH '.%@'", extension]]];
    }
    // @see https://stackoverflow.com/a/25636590
    NSCompoundPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    NSArray *filteredFileNames = [sortedFileNames filteredArrayUsingPredicate:predicate];
    
    return filteredFileNames;
}

#pragma mark > File Path Sort

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

#pragma mark > File Attributes

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

+ (long long)sizeOfFileAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory || !isExisted) {
        // If the path is a directory, or no file at the path exists
        return -1;
    }
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    return [attributes[NSFileSize] longLongValue];
}

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

#pragma mark > File Display Name

+ (NSString *)fileNameAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (isDirectory || !isExisted) {
        // If the path is a directory, no file at the path exists
        return nil;
    }
    
    return [[NSFileManager defaultManager] displayNameAtPath:path];
}

#pragma mark - Directory

#pragma mark > Directory Creation

+ (BOOL)createNewDirectoryIfNeededAtPath:(NSString *)path error:(NSError * _Nullable * _Nullable)error {
    if (![path isKindOfClass:[NSString class]]) {
        if (*error) {
            *error = nil;
        }
        return NO;
    }
    
    if ([path isKindOfClass:[NSString class]] && path.length == 0) {
        if (*error) {
            *error = nil;
        }
        return NO;
    }
    
    BOOL isExists = [self directoryExistsAtPath:path];
    
    if (isExists) {
        return YES;
    }
    else {
        // Note: path - This parameter must not be nil.
        NSError *errorL = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&errorL];
        
        if (*error) {
            *error = errorL;
        }
        
        return success;
    }
}

#pragma mark > Directory Deletion

+ (BOOL)deleteDirectoryAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (!isDirectory || !isExisted) {
        // If the path is a file, or the path not exists
        return NO;
    }
    
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

#pragma mark > Directory Check

+ (BOOL)directoryExistsAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    return (isDirectory && isExisted) ? YES : NO;
}

#pragma mark > Directory Display Name

+ (NSString *)directoryNameAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    
    if (!isDirectory || !isExisted) {
        // If the path is a file, or the path not exists
        return nil;
    }
    
    return [[NSFileManager defaultManager] displayNameAtPath:path];
}

#pragma mark > Directory Attributes

+ (long long)sizeOfDirectoryAtPath:(NSString *)path {
    if (![WCFileManagerTool directoryExistsAtPath:path]) {
        return -1;
    }
    
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    
    long long fileSize = 0;
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
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
