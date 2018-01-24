//
//  UseExceptionHanderViewController.m
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseExceptionHanderViewController.h"
#import "WCCrashCaseTool.h"

void UseExceptionHanderViewController_HandleException(NSException *exception)
{
    NSArray *arr = [exception callStackSymbols];
    
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSMutableString *crashLogContent = [NSMutableString string];
    [crashLogContent appendFormat:@"appVersion: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [crashLogContent appendFormat:@"appBuildVersion: %@\n", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [crashLogContent appendFormat:@"systemVersion: %@\n", [[UIDevice currentDevice] systemVersion]];
    //    [crashLogContent appendFormat:@"platform: %@\n", [networkParameter platform]];
    [crashLogContent appendFormat:@"crashTime: %@\n", dateString];
    [crashLogContent appendFormat:@"crashLogName: %@ \n", name];
    [crashLogContent appendFormat:@"crashReason: %@ \n", reason];
    [crashLogContent appendFormat:@"callStackInfo: %@ \n", arr];
    
    NSLog(@"CrashLog: %@", crashLogContent);
    
    NSString *filePath = ExceptionLogFilePath;
    [crashLogContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@interface UseExceptionHanderViewController ()
@end

@implementation UseExceptionHanderViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self installUncaughtExceptionHandler];
}

- (void)dealloc {
    [self uninstallUncaughtExceptionHandler];
}

#pragma mark

- (void)installUncaughtExceptionHandler {
    NSSetUncaughtExceptionHandler(&UseExceptionHanderViewController_HandleException);
}

- (void)uninstallUncaughtExceptionHandler {
    NSSetUncaughtExceptionHandler(NULL);
}

@end
