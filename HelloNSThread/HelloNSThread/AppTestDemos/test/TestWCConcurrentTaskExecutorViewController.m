//
//  TestWCConcurrentTaskExecutorViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2021/7/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "TestWCConcurrentTaskExecutorViewController.h"
#import "WCConcurrentTaskExecutor.h"
#import "WCMacroTool.h"

#define MaxConcurrentTaskNumber 5

static NSUInteger sCounter;

@interface TestWCConcurrentTaskExecutorViewController ()
@property (nonatomic, strong) WCConcurrentTaskExecutor *concurrentTaskExecutor;
@property (nonatomic, strong) NSMutableArray *finishedTaskIndex;
@property (nonatomic, assign) BOOL ignoreClick;
@property (nonatomic, strong) UIBarButtonItem *itemAddBatchTask;
@end

@implementation TestWCConcurrentTaskExecutorViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _concurrentTaskExecutor = [[WCConcurrentTaskExecutor alloc] initWithMaxConcurrency:MaxConcurrentTaskNumber];;
        _concurrentTaskExecutor.allTaskFinishedCompletion = ^(WCConcurrentTaskExecutor * _Nonnull executor) {
            NSLog(@"all tasks finished----------");
        };
        _finishedTaskIndex = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *addTaskItem = [[UIBarButtonItem alloc] initWithTitle:@"AddTasks" style:UIBarButtonItemStylePlain target:self action:@selector(addTaskItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[addTaskItem];
}

#pragma mark - Action

- (void)addTaskItemClicked:(id)sender {
    NSUInteger numberOfTasks = arc4random() % 10 + MaxConcurrentTaskNumber;
    
    NSLog(@"--- add %@ tasks", @(numberOfTasks));
    for (NSUInteger i = 0; i < numberOfTasks; ++i) {
        NSUInteger index = sCounter++;
        NSLog(@"adding task %@", @(index));
        
        weakify(self);
        [self.concurrentTaskExecutor addAsyncTask:^(id  _Nullable data, WCAsyncTaskCompletion  _Nonnull completion) {
            strongify(self);
            NSLog(@"Task %@ running", @(index));
            
            NSTimeInterval seconds = (arc4random() % 5000 + 3000) / 1000.0;
            [NSThread sleepForTimeInterval:seconds];
            
            NSLog(@"Task %@ finished", @(index));
            [self.finishedTaskIndex addObject:@(index)];
            completion();
        } data:nil timeout:0 timeoutBlock:^(id  _Nullable data, BOOL * _Nonnull shouldContinue) {
            NSLog(@"Task %@ timeout", @(index));
        }];
    }
}

@end
