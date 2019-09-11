//
//  WCGCDTool.h
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCGCDGroupTaskInfo : NSObject
@property (nonatomic, copy, nullable) NSString *groupName;
@property (nonatomic, assign) dispatch_queue_t taskQueue;
@property (nonatomic, assign) dispatch_queue_t completionQueue;
@property (nonatomic, strong) NSArray<id> *dataArray;
@property (nonatomic, assign) BOOL ordered;
@end

@interface WCGCDTool : NSObject

/**
 Safe run a block always on the main queue

 @param block the block to run
 @return YES if operate successfully, or NO if failed
 @see https://stackoverflow.com/a/10341532
 */
+ (BOOL)safePerformBlockOnMainQueue:(dispatch_block_t)block;

+ (BOOL)safeDispatchGroupAsyncWithGroupTaskInfo:(WCGCDGroupTaskInfo *)groupTaskInfo runTaskBlock:(void(^)(id data, void (^taskBlockFinished)(id processedData, NSError * _Nullable error)))singleTaskBlock allTaskCompletionBlock:(void (^)(NSArray *dataArray, NSError * _Nullable error))allTaskCompletionBlock;

@end

NS_ASSUME_NONNULL_END
