//
//  WCFileTool.m
//  HelloNSData
//
//  Created by wesley_chen on 2021/5/30.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCFileTool.h"

// WCLog
#if DEBUG_LOG
#   define WCLog(fmt, ...) NSLog(fmt, ## __VA_ARGS__)
#else
#   define WCLog(fmt, ...)
#endif

#define CheckErrorAndBreak(error) { if (error) { break; } }

@implementation WCFileTool

+ (BOOL)createNewFileAtPath:(NSString *)path content:(NSString *)content overwrite:(BOOL)overwrite error:(NSError * _Nullable * _Nullable)error {
    if (![path isKindOfClass:[NSString class]] || ![content isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSError *errorL = nil;
    BOOL success = NO;
    
    path = [path stringByExpandingTildeInPath];
    NSString *parentFolderPath = [path stringByDeletingLastPathComponent];
    NSString *directoryPath = [parentFolderPath hasPrefix:@"/"]
        ? parentFolderPath
        : [NSString stringWithFormat:@"%@/%@", [[NSFileManager defaultManager] currentDirectoryPath], parentFolderPath];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:[path lastPathComponent]];
    
    do {
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:NULL]) {
            success = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&errorL];
            CheckErrorAndBreak(errorL);
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            if (overwrite) {
                success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
                if (!success) {
                    // @sa http://stackoverflow.com/questions/1860070/more-detailed-error-from-createfileatpath
                    WCLog(@"Error code: %d - message: %s", errno, strerror(errno));
                    NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
                    userInfoM[NSLocalizedFailureReasonErrorKey] = [NSString stringWithFormat:@"%s", strerror(errno)];
                    errorL = [NSError errorWithDomain:NSStringFromClass([self class]) code:errno userInfo:userInfoM];
                }
            }
        }
        else {
            success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            if (!success) {
                // @sa http://stackoverflow.com/questions/1860070/more-detailed-error-from-createfileatpath
                WCLog(@"Error code: %d - message: %s", errno, strerror(errno));
                NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
                userInfoM[NSLocalizedFailureReasonErrorKey] = [NSString stringWithFormat:@"%s", strerror(errno)];
                errorL = [NSError errorWithDomain:NSStringFromClass([self class]) code:errno userInfo:userInfoM];
            }
        }
    } while (NO);
    
    if (error) {
        *error = errorL;
    }
    
    return success;
}

+ (BOOL)createNewFileAtPath:(NSString *)path overwrite:(BOOL)overwrite error:(NSError * _Nullable * _Nullable)error {
    return [self createNewFileAtPath:path content:@"" overwrite:overwrite error:error];
}

@end
