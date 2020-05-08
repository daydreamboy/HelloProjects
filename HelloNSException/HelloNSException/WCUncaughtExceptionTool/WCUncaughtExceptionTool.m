//
//  WCUncaughtExceptionTool.m
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCUncaughtExceptionTool.h"

@import UIKit;

#include <sys/signal.h>
#include <execinfo.h>

@interface WCUncaughtExceptionTool()
@property (nonatomic, assign) BOOL shouldAbort;
@property (nonatomic, strong) UIAlertView *alert;
@end

@interface WCUncaughtExceptionTool (Internal)
+ (NSArray *)backtrace;
+ (NSString *)signalNameWithSignal:(int)signal;
- (void)handleException:(NSException *)exception;
@end

#pragma mark - Handlers

static NSString * const UncaughtExceptionNameWrapSignalAsException = @"UncaughtExceptionNameWrapSignalAsException";
static NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
static NSString * const UncaughtExceptionHandlerCallStackKey = @"UncaughtExceptionHandlerCallStackKey";

void WCUncaughtExceptionTool_exceptionHandlerEntry(NSException *exception)
{
    NSArray *callStack = [WCUncaughtExceptionTool backtrace];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:exception.userInfo];
    userInfo[UncaughtExceptionHandlerCallStackKey] = callStack;
    
    NSException *exceptionAsParam = [NSException exceptionWithName:exception.name reason:exception.reason userInfo:userInfo];
    [[WCUncaughtExceptionTool new] performSelectorOnMainThread:@selector(handleException:) withObject:exceptionAsParam waitUntilDone:YES];
}

void WCUncaughtExceptionTool_signalHandlerEntry(int signal)
{
    NSArray *callStack = [WCUncaughtExceptionTool backtrace];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[UncaughtExceptionHandlerCallStackKey] = callStack;
    userInfo[UncaughtExceptionHandlerSignalKey] = @(signal);
    
    NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Signal %@ was raised.", nil), [WCUncaughtExceptionTool signalNameWithSignal:signal]];
    NSException *exceptionAsParam = [NSException exceptionWithName:UncaughtExceptionNameWrapSignalAsException reason:reason userInfo:userInfo];
    [[WCUncaughtExceptionTool new] performSelectorOnMainThread:@selector(handleException:) withObject:exceptionAsParam waitUntilDone:YES];
}

#pragma mark


@implementation WCUncaughtExceptionTool

+ (void)installUncaughtExceptionHandler {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self installExceptionHandler];
        [self installSignalHandler];
//    });
}

+ (void)installExceptionHandler {
    NSSetUncaughtExceptionHandler(&WCUncaughtExceptionTool_exceptionHandlerEntry);
}

+ (void)installSignalHandler {
    signal_handler_t SignalHandler = &WCUncaughtExceptionTool_signalHandlerEntry;
    
    signal(SIGABRT, SignalHandler);
    signal(SIGILL, SignalHandler);
    signal(SIGSEGV, SignalHandler);
    signal(SIGFPE, SignalHandler);
    signal(SIGBUS, SignalHandler);
    signal(SIGPIPE, SignalHandler);
}

+ (void)uninstallExceptionHandler {
    NSSetUncaughtExceptionHandler(NULL);
}

+ (void)uninstallSignalHandler {
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

#pragma mark - Private Methods

- (void)handleException:(NSException *)exception {
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You can try to continue but the application may be unstable.\n\n"
                                                                     @"Debug details follow:\n%@\n%@", nil), exception.reason, exception.userInfo[UncaughtExceptionHandlerCallStackKey]];
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Quit", nil)
                                           otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    [alert show];
//    _alert = alert;
#pragma GCC diagnostic pop
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    NSMutableArray *allModesM = [NSMutableArray arrayWithArray:(__bridge NSArray *)allModes];
    // Note: to avoid error log
    // invalid mode 'kCFRunLoopCommonModes' provided to CFRunLoopRunSpecific - break on _CFRunLoopError_RunCalledWithInvalidMode to debug. This message will only appear once per execution.
    [allModesM removeObject:(NSString *)kCFRunLoopCommonModes];
    
    // Note
    while (!_shouldAbort) {
        for (NSString *mode in (NSArray *)allModesM) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    [self.class uninstallExceptionHandler];
    [self.class uninstallSignalHandler];

    // Note: if this exception from signal, just kill, not raise it again
    if ([[exception name] isEqual:UncaughtExceptionNameWrapSignalAsException]) {
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    }
    else {
        [exception raise];
    }
}

#pragma mark - UIAlertDelegate

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
    if (anIndex == 0) {
        _shouldAbort = YES;
    }
}

#pragma mark - Helpers

+ (NSArray *)backtrace {
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

+ (NSString *)signalNameWithSignal:(int)signal {
    switch (signal) {
        case SIGABRT: { return @"SIGABRT"; }
        case SIGILL: { return @"SIGILL"; }
        case SIGFPE: { return @"SIGFPE"; }
        case SIGBUS: { return @"SIGBUS"; }
        case SIGPIPE: { return @"SIGPIPE"; }
        case SIGSEGV: { return @"SIGSEGV"; }
        default:
            return [NSString stringWithFormat:@"%d", signal];
    }
}

@end
