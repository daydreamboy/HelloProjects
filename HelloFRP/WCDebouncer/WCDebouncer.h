//
//  WCDebouncer.h
//  HelloFRP
//
//  Created by wesley_chen on 2020/10/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDebouncer : NSObject

- (instancetype)initWithDelay:(NSTimeInterval)delay serialQueue:(nullable dispatch_queue_t)queue;
- (void)debounceWithBlock:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
