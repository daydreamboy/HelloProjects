//
//  WCJSCTimerManager.h
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2020/3/4.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WCJSCTimerManagerJSExports <JSExport>
// Note: make `new` available in JS Code
- (instancetype)init;
- (NSString *)setTimeout:(JSValue *)callback delayInMS:(NSTimeInterval)delayInMS arg1:(JSValue *)arg1 arg2:(JSValue *)arg2 arg3:(JSValue *)arg3 arg4:(JSValue *)arg4 arg5:(JSValue *)arg5;
- (BOOL)clearTimeout:(JSValue *)timeoutID;
- (NSString *)setInterval:(JSValue *)callback delayInMS:(NSTimeInterval)delayInMS arg1:(JSValue *)arg1 arg2:(JSValue *)arg2 arg3:(JSValue *)arg3 arg4:(JSValue *)arg4 arg5:(JSValue *)arg5;
@end

/**
 A timer manager provides setTimeout, setInterval, clearTimeout function to JS front code
 
 @see https://stackoverflow.com/a/39864295
 */
@interface WCJSCTimerManager : NSObject <WCJSCTimerManagerJSExports>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Register setTimeout/setInterval/clearTimeout functions to JSContext
 
 @discussion This method only register once
 */
+ (BOOL)registerWithContext:(JSContext *)context;

/**
 Unregister timers when JSContext will be destroyed
 
 @discussion The JS code maybe create repeated timers by `setInterval` function, which will make
 a cycle: NSTimer.userInfo -> JSValue -> JSContext -> WCJSCTimerManager.timers -> NSTimer instance
 */
+ (BOOL)unregisterWithContext:(JSContext *)context;

@end

NS_ASSUME_NONNULL_END
