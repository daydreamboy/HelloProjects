//
//  TaskHandler2.m
//  Tests
//
//  Created by wesley_chen on 2020/8/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TaskHandler2.h"

@interface TaskHandler2 ()
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation TaskHandler2

- (instancetype)initWithBizKey:(NSString *)bizKey {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("com.wc.TaskHandler2", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (NSString *)name {
    return @"taskHandlder2";
}

- (void)handleWithContext:(WCAsyncTaskChainContext *)context taskHandlerCompletion:(TaskHandlerCompletion)taskHandlerCompletion {
    if ([context.data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:context.data];
        dictM[@"taskHandler2"] = @"handled";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), self.queue, ^{
            taskHandlerCompletion(dictM, nil);
        });
    }
}

- (NSTimeInterval)timeoutInterval {
    return 2;
}

@end
