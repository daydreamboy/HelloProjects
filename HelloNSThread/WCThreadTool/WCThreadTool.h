//
//  WCThreadTool.h
//  HelloThread
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCThreadTool : NSObject

/**
 call block on the specific NSThread

 @param block the block
 @param thread the NSThread instance
 @param waitUntilDone YES if the current thread waits the block completes, NO if the current thread not waits
        and this method returns immediately. If the thread is the current thread, YES will make the block called
        immediately; NO will make the block called in next run loop. (See details in -[NSObject(NSThreadPerformAdditions) performSelector:onThread:withObject:waitUntilDone:])
 */
+ (void)performBlock:(dispatch_block_t)block onThread:(NSThread *)thread waitUntilDone:(BOOL)waitUntilDone;

/**
 call block with a parameter on the specific NSThread

 @param block the block
 @param thread the NSThread instance
 @param object the paramert for the block
 @param waitUntilDone see +[WCThreadTool performBlock:onThread:waitUntilDone:] for detail
 */
+ (void)performBlock:(void (^)(id))block onThread:(NSThread *)thread withObject:(id)object waitUntilDone:(BOOL)waitUntilDone;

@end

NS_ASSUME_NONNULL_END
