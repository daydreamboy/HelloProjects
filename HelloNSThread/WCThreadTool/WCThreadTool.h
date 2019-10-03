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

#pragma mark - Execute Task on Thread

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

#pragma mark - Resident Thread

/**
 Create and start a resident thread

 @param name the name of the thread
 @param startImmediately YES if start the thread after created, or NO to start it later by -[NSThread start]
 @return the thread which is resident, and use +[WCThreadTool stopResidentThread:] to stop it running.
 @discussion the returned thread should be hold by yourself
 */
+ (NSThread *)createResidentThreadWithName:(NSString *)name startImmediately:(BOOL)startImmediately;

/**
 Stop the resident thread

 @param residentThread the resident thread created by +[WCThreadTool createResidentThreadWithName:startImmediately:]
 @return YES if it operates succesfully, or NO if it fails
 @discussion the residentThread not created by +[WCThreadTool createResidentThreadWithName:startImmediately:] will make
 this method no effective.
 */
+ (BOOL)stopResidentThread:(NSThread *)residentThread;

@end

NS_ASSUME_NONNULL_END
