//
//  TestWCAsyncTaskExecutorViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2020/6/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TestWCAsyncTaskExecutorViewController.h"
#import "WCAsyncTaskExecutor.h"
#import "WCMacroTool.h"

@interface TestWCAsyncTaskExecutorViewController ()
@property (nonatomic, strong) WCAsyncTaskExecutor *asyncTaskExecutor;
@property (nonatomic, strong) NSMutableArray *timestamps;
@property (nonatomic, assign) BOOL ignoreClick;
@end

@implementation TestWCAsyncTaskExecutorViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        weakify(self);
        _asyncTaskExecutor = [WCAsyncTaskExecutor new];
        _asyncTaskExecutor.allTaskFinishedCompletion = ^(WCAsyncTaskExecutor * _Nonnull executor) {
            strongifyWithReturn(self, return;);
            
            [self batchTasksAllFinishedWithAsyncTaskExecutor:executor];
        };
        _timestamps = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addTaskItem = [[UIBarButtonItem alloc] initWithTitle:@"AddTask" style:UIBarButtonItemStylePlain target:self action:@selector(addTaskItemClicked:)];
    self.navigationItem.rightBarButtonItem = addTaskItem;
}

#pragma mark - Action

- (void)addTaskItemClicked:(id)sender {
    if (self.ignoreClick) {
        return;
    }
    
    NSUInteger numberOfTasks = arc4random() % 10 + 1;
    NSLog(@"--- add %@ tasks", @(numberOfTasks));
    for (NSUInteger i = 0; i < numberOfTasks; ++i) {
        NSString *timestamp = [NSString stringWithFormat:@"%f",  [[NSDate date] timeIntervalSince1970]];
        NSLog(@"adding task %@", timestamp);
        
        weakify(self);
        [self.asyncTaskExecutor addAsyncTask:^(id _Nullable data, WCAsyncTaskCompletion  _Nonnull completion) {
            strongify(self);
            
            NSTimeInterval seconds = (arc4random() % 1000 + 500) / 1000.0;
            [NSThread sleepForTimeInterval:seconds];
            
            NSLog(@"Task %@ finished", timestamp);
            [self.timestamps addObject:timestamp];
            completion();
        } data:nil forKey:timestamp timeout:0 timeoutBlock:nil];
    }
}

#pragma mark - 

- (void)batchTasksAllFinishedWithAsyncTaskExecutor:(WCAsyncTaskExecutor *)exectuor {
    self.ignoreClick = YES;
    
    BOOL success = YES;
    NSTimeInterval maxTimestamp = 0;
    for (NSUInteger i = 0; i < [self.timestamps count]; ++i) {
        NSTimeInterval timestamp = [self.timestamps[i] doubleValue];
        if (timestamp > maxTimestamp) {
            maxTimestamp = timestamp;
        }
        else {
            success = NO;
            NSLog(@"*** Test failed, expect %f > %f", timestamp, maxTimestamp);
            break;
        }
    }
    
    if (success) {
        NSLog(@"*** Test successfully with %@ tasks", @([self.timestamps count]));
    }
    
    self.ignoreClick = NO;
}

@end
