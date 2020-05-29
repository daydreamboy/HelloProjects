//
//  UseNSConditionLockViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/24.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSConditionLockViewController.h"

typedef NS_ENUM(NSUInteger, DataState) {
    DataStateNoData,
    DataStateHasData,
};

static NSConditionLock *sCLock;
static NSMutableArray *sQueue;

@interface ThreadProducer : NSObject
@end

@implementation ThreadProducer
+ (void)produceData {
    int i = 0;
    while (YES) {
        [sCLock lock];
        
        // Note: at least produce an item for marking DataStateHasData
        uint32_t numberOfItems = arc4random() % 10 + 1;
        
        for (int j = 0; j < numberOfItems; j++) {
            [sQueue addObject:@(i)];
            printf("produced %i\n", i);
            i++;
        }
        
        [sCLock unlockWithCondition:DataStateHasData];
        printf("================\n");
        
        unsigned int seconds = arc4random() % 10 + 1;
        sleep(seconds);
    }
}
@end

@interface ThreadConsumer : NSObject
@end

@implementation ThreadConsumer
+ (void)consumeData {
    while (YES) {
        [sCLock lockWhenCondition:DataStateHasData];
        
        // Note: make consume random number of items in the queue
        NSUInteger numberOfItems = arc4random() % sQueue.count + 1;
        for (int i = 0; i < numberOfItems; i++) {
            NSNumber *itemToRemove = [sQueue firstObject];
            
            [sQueue removeObject:itemToRemove];
            printf("consumed %i\n", [itemToRemove intValue]);
        }
        printf("-------------\n");
        
        // Note: no data in the queue, release the lock with DataStateNoData, so the consumer
        // can't get the lock again
        [sCLock unlockWithCondition:(sQueue.count == 0 ? DataStateNoData : DataStateHasData)];
    }
}
@end

@implementation UseNSConditionLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sCLock = [[NSConditionLock alloc] initWithCondition:DataStateNoData];
    sQueue = [NSMutableArray array];
    
    [NSThread detachNewThreadSelector:@selector(produceData) toTarget:[ThreadProducer class] withObject:nil];
    [NSThread detachNewThreadSelector:@selector(consumeData) toTarget:[ThreadConsumer class] withObject:nil];
}

@end
