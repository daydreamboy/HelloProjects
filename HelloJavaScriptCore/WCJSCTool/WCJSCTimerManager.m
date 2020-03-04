//
//  WCJSCTimerManager.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2020/3/4.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCJSCTimerManager.h"
#import <objc/runtime.h>

#define WCJSCTimerManagerJSInstanceName @"_wcjscTimerManagerInstance"
#define WCJSCTimerManagerJSClassName @"WCJSCTimerManager"

static void * const kAssociatedKeyWCJSCTimerManager = (void *)&kAssociatedKeyWCJSCTimerManager;

@interface WCJSCTimerManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSTimer *> *timers;
@end

@implementation WCJSCTimerManager

#pragma mark - Public Method

+ (BOOL)registerWithContext:(JSContext *)context {
    if (![context isKindOfClass:[JSContext class]]) {
        return NO;
    }
    
    id object = objc_getAssociatedObject(context, kAssociatedKeyWCJSCTimerManager);
    if (object) {
        return NO;
    }
    
    
    WCJSCTimerManager *manager = [[WCJSCTimerManager alloc] init];
    context[WCJSCTimerManagerJSClassName] = [WCJSCTimerManager class];
    context[WCJSCTimerManagerJSInstanceName] = manager;
    
    NSString *injectedJSCode = [NSString stringWithFormat:@"\
        function setTimeout(callback, ms, arg1, arg2, arg3, arg4, arg5) { return %@.setTimeoutDelayInMSArg1Arg2Arg3Arg4Arg5(callback, ms, arg1, arg2, arg3, arg4, arg5); }; \
        function clearTimeout(timeoutID) { return %@.clearTimeout(timeoutID) }; \
        function setInterval(callback, ms, arg1, arg2, arg3, arg4, arg5) { return %@.setIntervalDelayInMSArg1Arg2Arg3Arg4Arg5(callback, ms, arg1, arg2, arg3, arg4, arg5); }; \
                                ", WCJSCTimerManagerJSInstanceName, WCJSCTimerManagerJSInstanceName, WCJSCTimerManagerJSInstanceName];
    [context evaluateScript:injectedJSCode];
    
    objc_setAssociatedObject(context, kAssociatedKeyWCJSCTimerManager, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return YES;
}

+ (BOOL)unregisterWithContext:(JSContext *)context {
    if (![context isKindOfClass:[JSContext class]]) {
        return NO;
    }
    
    id object = objc_getAssociatedObject(context, kAssociatedKeyWCJSCTimerManager);
    if (![object isKindOfClass:[WCJSCTimerManager class]]) {
        return NO;
    }
    
    WCJSCTimerManager *manager = (WCJSCTimerManager *)object;
    [manager cleanupTimers];
    
    return YES;
}

#pragma mark > WCJSCTimerManagerJSExports

- (NSString *)setTimeout:(JSValue *)callback delayInMS:(NSTimeInterval)delayInMS arg1:(JSValue *)arg1 arg2:(JSValue *)arg2 arg3:(JSValue *)arg3 arg4:(JSValue *)arg4 arg5:(JSValue *)arg5 {
    return [self createTimerWithCallback:callback delayInMS:delayInMS repeated:NO arg1:arg1 arg2:arg2 arg3:arg3 arg4:arg4 arg5:arg5];
}

- (BOOL)clearTimeout:(JSValue *)timeoutID {
    if (timeoutID.isUndefined) {
        return NO;
    }
    
    NSString *UUID = [timeoutID toString];
    if (!UUID) {
        return NO;
    }
    
    [self.timers[UUID] invalidate];
    self.timers[UUID] = nil;
    
    return YES;
}

- (NSString *)setInterval:(JSValue *)callback delayInMS:(NSTimeInterval)delayInMS arg1:(JSValue *)arg1 arg2:(JSValue *)arg2 arg3:(JSValue *)arg3 arg4:(JSValue *)arg4 arg5:(JSValue *)arg5 {
    return [self createTimerWithCallback:callback delayInMS:delayInMS repeated:YES arg1:arg1 arg2:arg2 arg3:arg3 arg4:arg4 arg5:arg5];
}

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        _timers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    [self cleanupTimers];
}

#pragma mark -

- (void)cleanupTimers {
    for (NSString *UUID in _timers) {
        [_timers[UUID] invalidate];
    }
    
    [_timers removeAllObjects];
    _timers = nil;
}

- (NSString *)createTimerWithCallback:(JSValue *)callback delayInMS:(NSTimeInterval)delayInMS repeated:(BOOL)repeated arg1:(JSValue *)arg1 arg2:(JSValue *)arg2 arg3:(JSValue *)arg3 arg4:(JSValue *)arg4 arg5:(JSValue *)arg5 {
    NSTimeInterval intervalInSeconds = delayInMS / 1000.0;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"callback"] = callback;
    userInfo[@"arguments"] = @[ arg1, arg2, arg3, arg4, arg5 ];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:intervalInSeconds target:self selector:@selector(timerFired:) userInfo:userInfo repeats:repeated];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    NSString *timeoutID = [[NSUUID UUID] UUIDString];
    self.timers[timeoutID] = timer;
    
    return timeoutID;
}

- (void)timerFired:(NSTimer *)timer {
    NSMutableDictionary *userInfo = [timer userInfo];
    JSValue *callback = userInfo[@"callback"];
    NSArray *arguments = userInfo[@"arguments"];
    
    [callback callWithArguments:arguments];
}

@end
