//
//  WCExceptionTool.h
//  HelloNSException
//
//  Created by wesley_chen on 2019/1/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCExceptionTool : NSObject

/**
 Convert an NSException to reportable string which used to write a crash log
 
 @param exception the NSException
 @return the reportable string of the NSException
 */
+ (nullable NSString *)reportableStringWithException:(NSException *)exception;

/**
 Write a crash report with the NSException
 
 @param exception the NSException
 @param enablePrintToConsole YES if print the crash report to console, NO if only write to file
 @param crashReportFileName the name of the crash report, which located in NSDocumentDirectory
 @return YES if write successfully, NO if any error occurred.
 */
+ (BOOL)writeCrashReportWithException:(NSException *)exception enablePrintToConsole:(BOOL)enablePrintToConsole crashReportFileName:(nullable NSString *)crashReportFileName;

#pragma mark - Utility

/**
 Get the app executable image load address
 
 @return the app executable image load address, e.g. 0x104ffc000
 @header #import <mach-o/dyld.h>
 @see https://www.wandouip.com/t5i276951/
 */
+ (NSString *)appExecutableImageLoadAddress;

/**
 Get the UUID of the app executable image
 
 @return the UUID
 @header #import <mach-o/ldsyms.h>
 @see https://stackoverflow.com/questions/10119700/how-to-get-mach-o-uuid-of-a-running-process
 
 @discussion use the following command to check the app executable file
 @code
 $ otool -l <app executable file> | grep uuid
 @endcode
 */
+ (nullable NSString *)appExecutableUUID;

@end

NS_ASSUME_NONNULL_END
