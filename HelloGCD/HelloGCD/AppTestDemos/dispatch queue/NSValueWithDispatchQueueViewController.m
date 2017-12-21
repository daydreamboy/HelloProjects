//
//  NSValueWithDispatchQueueViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "NSValueWithDispatchQueueViewController.h"

typedef NS_ENUM(NSUInteger, QueueType) {
    QueueTypeGetToken,
    QueueTypeLogin,
    QueueTypeCount,
};

NSStringFromQueueType(QueueType queueType) {
    
}

@interface NSValueWithDispatchQueueViewController ()

@end

@implementation NSValueWithDispatchQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (dispatch_queue_t)serialQueueWithQueueType:(QueueType)queueType
{
    static NSMutableDictionary *serialQueueDict = nil;
    if (serialQueueDict == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            serialQueueDict = [[NSMutableDictionary alloc] initWithCapacity:QueueTypeCount];
        });
    }
    
    dispatch_queue_t queue;
    
    @synchronized (self) {
        NSString *key = [WXHttpTokenManager tokenName4Type:tokenType];
        key = [key stringByAppendingString:NSStringFromClass([self class])];
        NSValue *value = serialQueueDict[key];
        
        if (value == nil) {
            queue = dispatch_queue_create(key.UTF8String, DISPATCH_QUEUE_SERIAL);
            value = [NSValue valueWithBytes:&queue objCType:@encode(dispatch_queue_t)];
            serialQueueDict[key] = value;
        } else {
            [value getValue:&queue];
        }
    }
    
    return queue;
}

@end
