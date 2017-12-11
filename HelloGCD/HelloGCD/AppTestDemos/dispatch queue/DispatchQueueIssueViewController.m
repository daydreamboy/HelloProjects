//
//  DispatchQueueIssueViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 11/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "DispatchQueueIssueViewController.h"

typedef NS_ENUM(NSUInteger, MyType) {
    MyTypeValue1,
    MyTypeValue2,
};

@interface DispatchQueueIssueViewController ()
@end

@implementation DispatchQueueIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test1];
    [self test2];
}

- (void)test1 {
    dispatch_block_t block = ^{
        NSLog(@"do something");
    };
    
    [self performSyncBlock:block onQueue4TokenType:MyTypeValue2];
}

- (void)test2 {
    dispatch_async([self.class serialQueueWithTokenType:MyTypeValue2], ^{
        NSLog(@"dispatch_async called");
    });
    
    for (NSInteger i = 0; i < 1; i++) {
        NSString *string = [NSString stringWithFormat:@"queue-%ld", (long)i];
        dispatch_queue_t queue = dispatch_queue_create(string.UTF8String, DISPATCH_QUEUE_SERIAL);
        dispatch_async(queue, ^{
            [self performSyncBlock:^{
                NSLog(@"performSyncBlock called");
            } onQueue4TokenType:MyTypeValue2];
        });
    }
}

- (void)performSyncBlock:(dispatch_block_t)block onQueue4TokenType:(MyType)tokenType {
    dispatch_queue_t queue = [self.class serialQueueWithTokenType:tokenType];
    if (dispatch_get_current_queue() == queue) {
        block();
    } else {
        dispatch_sync(queue, ^{
            block();
        });
    }
}

+ (dispatch_queue_t)serialQueueWithTokenType:(MyType)tokenType {
    static NSMutableDictionary *serialQueueDict = nil;
    if (serialQueueDict == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            serialQueueDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        });
    }
    
    dispatch_queue_t queue;
    
    @synchronized (self) {
        NSString *key = [self tokenNameWithType:tokenType];
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

+ (NSString *)tokenNameWithType:(MyType)tokenType {
    switch (tokenType) {
        case MyTypeValue1:
            return @"MyTypeValue1";
        case MyTypeValue2:
        default:
            return @"MyTypeValue2";
    }
}

@end
