//
//  WCExceptionTool.m
//  HelloNSException
//
//  Created by wesley_chen on 2019/1/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCExceptionTool.h"
#import "WCMachOTool.h"

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
    [crashReportableContent appendFormat:@"appExecutableUUID: %@\n", [WCMachOTool appExecutableUUID]];
    [crashReportableContent appendFormat:@"appExecutableLoadAddress: %@\n", [WCMachOTool appExecutableImageLoadAddress]];
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

@end
