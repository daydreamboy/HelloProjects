//
//  UseTimerInNonMainThreadViewController.m
//  HelloNSTimer
//
//  Created by wesley_chen on 2019/5/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseTimerInNonMainThreadViewController.h"
#import "WCWeakProxy.h"

/**
 Weakify the object variable

 @param object the original variable
 @discussion Use weakify/strongify as pair
 @see https://www.jianshu.com/p/9e18f28bf28d
 @see https://github.com/ReactiveCocoa/ReactiveObjC/blob/master/ReactiveObjC/extobjc/EXTScope.h#L83
 @code
 
 id foo = [[NSObject alloc] init];
 id bar = [[NSObject alloc] init];
 
 weakify(foo);
 weakify(bar);
 
 // this block will not keep 'foo' or 'bar' alive
 BOOL (^matchesFooOrBar)(id) = ^ BOOL (id obj){
    // but now, upon entry, 'foo' and 'bar' will stay alive until the block has
    // finished executing
    strongify(foo);
    strongifyWithReturn(bar, return NO);
 
    return [foo isEqual:obj] || [bar isEqual:obj];
 };
 
 @endcode
 */
#define weakify(object) \
__weak __typeof__(object) object##_weak_ = object;

/**
 Strongify the weak object variable which is created by weakify(object)

 @param object the original variable
 @discussion Use weakify/strongify as pair
 @see https://www.jianshu.com/p/9e18f28bf28d
 @note See #weakify for an example of usage.
 */
#define strongify(object) \
__strong __typeof__(object) object = object##_weak_;

@interface UseTimerInNonMainThreadViewController ()
@property (nonatomic, weak) NSTimer *timerInNonMainThread;
@end

@implementation UseTimerInNonMainThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weak_self = self;
    //weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //strongify(self);
        NSLog(@"NSTimer will be scheduled...");
        weak_self.timerInNonMainThread = [NSTimer scheduledTimerWithTimeInterval:1 target:WCWeakProxy_NEW(weak_self) selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:weak_self.timerInNonMainThread forMode:NSDefaultRunLoopMode];
        NSLog(@"NSTimer scheduled...");
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"block task is over...");
    });
}

- (void)dealloc {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.timerInNonMainThread invalidate]; // Don't use weakSelf in dealloc
    });
}

- (void)timerFired:(NSTimer *)timer {
    NSLog(@"%@: The timer is fired.", NSStringFromSelector(_cmd));
    NSLog(@"The current thread: %@, is main thread: %@", [NSThread currentThread], [NSThread isMainThread] ? @"YES" : @"NO");
}

@end
