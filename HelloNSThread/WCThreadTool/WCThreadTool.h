//
//  WCThreadTool.h
//  HelloThread
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The WCThreadTool_shouldContinueBlockType block type
 
 @param container the container for adding data in every iterate block
 @param error the error in every iterate block, and maybe nil
 @param shouldContinue the flag should continue next iteration
 @param transmitData the transmited data from WCThreadTool_shouldContinueBlockType block or the initial transmitedData in +[WCThreadTool recursiveCallWithIterateBlock:transmitData:completionBlock:]
 */
typedef void(^WCThreadTool_shouldContinueBlockType)(NSMutableArray *container, NSError * _Nullable error, BOOL shouldContinue, id _Nullable transmitData);
/**
 The WCThreadTool_iterateBlockType block type
 
 @param container the container for adding data in every iterate block
 @param iterateCount the count for iterating which started by 1, not 0
 @param transmitData the transmited data from WCThreadTool_shouldContinueBlockType block or the initial transmitedData in +[WCThreadTool recursiveCallWithIterateBlock:transmitData:completionBlock:]
 @param shouldContinueBlock the block of WCThreadTool_shouldContinueBlockType type. See WCThreadTool_shouldContinueBlockType for more details.
 */
typedef void(^WCThreadTool_iterateBlockType)(NSMutableArray *container, NSUInteger iterateCount, id _Nullable transmitData, WCThreadTool_shouldContinueBlockType shouldContinueBlock);
/**
 The WCThreadTool_completionBlockType block type
 
 @param container the container for adding data in every iterate block
 @param error the error in iterate block when set shouldContinue = NO , and maybe nil.
 @param iterateCount the count for iterating which started by 1, not 0
 @param transmitData the transmited data from WCThreadTool_shouldContinueBlockType block or the initial transmitedData in +[WCThreadTool recursiveCallWithIterateBlock:transmitData:completionBlock:]
 */
typedef void(^WCThreadTool_completionBlockType)(NSMutableArray *container, NSError * _Nullable error, NSUInteger iterateCount, id _Nullable transmitData);

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

/**
 call block always on main thread
 
 @param block the block
 @return YES if perform the block successfully, NO if not
 */
+ (BOOL)performBlockOnMainThread:(void (^)(void))block;

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

#pragma mark - Call Stack

/**
 Get the stack of current thread
 
 @return the stack info
 @discussion the appExecutableLoadAddress and callStackReturnAddresses is provided for atos command.
 For usage
 $ atos -o XXX.app.dSYM/Contents/Resources/DWARF/XXX -l <appExecutableLoadAddress> <callStackReturnAddresses>
 */
+ (NSString *)currentThreadCallStackString;

#pragma mark - Task Schedule

/**
 Recursively call the task block with a completion block

 @param iterateBlock the each iterate block. See WCThreadTool_iterateBlockType for more details.
 @param transmitData the transmit data passed to the next iterate block. Can be nil.
 @param completionBlock the completion called only when set shouldContinue = NO in iterateBlock
 
 @return YES if the parameters are correct, NO if not
 
 @discussion This method simplify recursively calling the same task. Do customization for the task in iterateBlock and be careful to set shouldContinue = NO
 
 @example
 NSString *initialIndex = @"0";
 
 [WCThreadTool recursiveCallWithIterateBlock:^(NSMutableArray *container, NSUInteger iterateCount, id  _Nullable transmitData, WCThreadTool_shouldContinueBlockType shouldContinueBlock) {
     
     NSMutableDictionary *paramM = [NSMutableDictionary dictionary];
     paramM[@"pageIndex"] = @(iterateCount);
     [self requestWithParameter:paramM completion:^(NSString *data, NSError *error) {
         NSString *passedData = [NSString stringWithFormat:@"%@-%@", transmitData, data];
         if (error) {
             !shouldContinueBlock ?: shouldContinueBlock(container, error, NO, passedData);
         }
         else {
             [container addObject:data];
             !shouldContinueBlock ?: shouldContinueBlock(container, nil, YES, passedData);
         }
     }];
 } transmitData:initialIndex completionBlock:^(NSMutableArray * _Nonnull container, NSError * _Nullable error, NSUInteger iterateCount, id  _Nullable transmitData) {
     NSLog(@"iterateCount: %ld, error: %@, container: %@, transmitData: %@", (long)iterateCount, error, container, transmitData);
 }];
 */
+ (BOOL)recursiveCallWithIterateBlock:(WCThreadTool_iterateBlockType)iterateBlock transmitData:(id _Nullable)transmitData completionBlock:(WCThreadTool_completionBlockType)completionBlock;

@end

NS_ASSUME_NONNULL_END
