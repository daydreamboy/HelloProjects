//
//  WCExceptionTool.m
//  HelloNSException
//
//  Created by wesley_chen on 2019/1/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCExceptionTool.h"
#import <mach-o/dyld.h>
#import <mach-o/ldsyms.h>

@implementation WCExceptionTool

+ (nullable NSString *)reportableStringWithException:(NSException *)exception {
    if (![exception isKindOfClass:[NSException class]]) {
        return nil;
    }
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *sFormatter;
    if (!sFormatter) {
        sFormatter = [[NSDateFormatter alloc] init];
        
        [sFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss.sss"];
        [sFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    
    NSArray *callStackSymbols = [exception callStackSymbols];
    NSArray *callStackReturnAddresses = [exception callStackReturnAddresses];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSDictionary *userInfo = [exception userInfo];
    
    NSString *dateString = [sFormatter stringFromDate:date];
    
    NSMutableString *crashReportableContent = [NSMutableString string];
    [crashReportableContent appendFormat:@"appVersion: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [crashReportableContent appendFormat:@"appBuildVersion: %@\n", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [crashReportableContent appendFormat:@"appExecutableUUID: %@\n", [self appExecutableUUID]];
    [crashReportableContent appendFormat:@"appExecutableLoadAddress: %@\n", [self appExecutableImageLoadAddress]];
    [crashReportableContent appendFormat:@"systemVersion: %@\n", [[UIDevice currentDevice] systemVersion]];
    [crashReportableContent appendFormat:@"crashTime: %@\n", dateString];
    [crashReportableContent appendFormat:@"crashExceptionName: %@\n", name];
    [crashReportableContent appendFormat:@"crashReason: %@\n", reason];
    [crashReportableContent appendFormat:@"crashUserInfo: %@\n", userInfo];
    [crashReportableContent appendFormat:@"callStackSymbols: %@\n", callStackSymbols];
    [crashReportableContent appendFormat:@"callStackReturnAddresses: %@\n", callStackReturnAddresses];

    return crashReportableContent;
}

+ (BOOL)writeCrashReportWithException:(NSException *)exception enablePrintToConsole:(BOOL)enablePrintToConsole crashReportFileName:(nullable NSString *)crashReportFileName {
    
    NSString *filePath;
    NSString *userHomeFileName = crashReportFileName.length ? crashReportFileName : [NSString stringWithFormat:@"crash_report_%f.txt", [[NSDate date] timeIntervalSince1970]];
    
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
    filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:userHomeFileName];
#endif
    
    NSString *crashContent = [self reportableStringWithException:exception];
    if (enablePrintToConsole) {
        printf("\n%s\n", [crashContent UTF8String]);
    }
    
    NSError *error;
    BOOL success = [crashContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    return success;
}

#pragma mark - Utility

+ (NSString *)appExecutableImageLoadAddress {
    static NSString *sAddress;
    
    if (!sAddress) {
        const struct mach_header *executableHeader = NULL;
        for (uint32_t i = 0; i < _dyld_image_count(); i++){
            const struct mach_header *header = _dyld_get_image_header(i);
            // Note: find the image type is executable, which is the executable binary file
            if (header->filetype == MH_EXECUTE){
                executableHeader = header;
                break;
            }
        }
        sAddress = [NSString stringWithFormat:@"0x%lx", (long)executableHeader];
    }
    
    return sAddress;
}

+ (nullable NSString *)appExecutableUUID {
    static NSString *sUUID;
    static dispatch_semaphore_t sLock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sLock = dispatch_semaphore_create(1);
    });
    
    if (!sUUID) {
        dispatch_semaphore_wait(sLock, DISPATCH_TIME_FOREVER);
        
        const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
        for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
            if (((const struct load_command *)command)->cmd == LC_UUID) {
                command += sizeof(struct load_command);
                sUUID = [[NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
                         command[0], command[1],
                         command[2], command[3],
                         command[4], command[5],
                         command[6], command[7],
                         command[8], command[9],
                         command[10], command[11],
                         command[12], command[13],
                         command[14], command[15]] copy];
                break;
            }
            else {
                command += ((const struct load_command *)command)->cmdsize;
            }
        }
        
        dispatch_semaphore_signal(sLock);
    }

    return sUUID;
}

@end
