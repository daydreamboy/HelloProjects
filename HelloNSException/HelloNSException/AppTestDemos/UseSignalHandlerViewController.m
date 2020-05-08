//
//  UseSignalHandlerViewController.m
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseSignalHandlerViewController.h"

#import "WCUncaughtExceptionTool.h"

#include <libkern/OSAtomic.h>
#include <execinfo.h>

#include <sys/signal.h> // for signal()

@interface UseSignalHandlerViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@end

void UseSignalHandlerViewController_SignalHandler(int signal)
{
    NSString *reason = [NSMutableString stringWithFormat:@"Signal %d", signal];
    NSString *name = [WCUncaughtExceptionTool signalNameWithSignal:signal];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss.sss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    NSArray *callStackReturnAddresses = [NSThread callStackReturnAddresses];
    
    NSMutableString *crashLogContent = [NSMutableString string];
    [crashLogContent appendFormat:@"appVersion: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [crashLogContent appendFormat:@"appBuildVersion: %@\n", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [crashLogContent appendFormat:@"systemVersion: %@\n", [[UIDevice currentDevice] systemVersion]];
    //    [crashLogContent appendFormat:@"platform: %@\n", [networkParameter platform]];
    [crashLogContent appendFormat:@"crashTime: %@\n", dateString];
    [crashLogContent appendFormat:@"crashLogName: %@ \n", name];
    [crashLogContent appendFormat:@"crashReason: %@ \n", reason];
    [crashLogContent appendFormat:@"callStackSymbols: %@\n", callStackSymbols];
    [crashLogContent appendFormat:@"callStackReturnAddresses: %@\n", callStackReturnAddresses];
    
    NSLog(@"CrashLog: %@", crashLogContent);
   
    NSString *filePath = SignalLogFilePath;
    [crashLogContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@implementation UseSignalHandlerViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Try Signal Handler must on iOS Device" delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil];
    [alert show];
#pragma GCC diagnostic pop

    [self installUncaughtExceptionHandler];
}

- (void)dealloc {
    [self uninstallUncaughtExceptionHandler];
}

- (void)installUncaughtExceptionHandler {    
    signal_handler_t SignalHandler = &UseSignalHandlerViewController_SignalHandler;
    
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

- (void)uninstallUncaughtExceptionHandler {
    // @see https://jameshfisher.com/2017/01/11/c-signal-unregister.html
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

@end
