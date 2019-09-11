//
//  SafeDispatchGroupEnterAndLeaveViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 2019/9/11.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import "SafeDispatchGroupEnterAndLeaveViewController.h"
#import "WCGCDTool.h"
#import "LoremIpsum.h"

@interface File : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *path;
@end

@implementation File
@end

@interface SafeDispatchGroupEnterAndLeaveViewController ()

@end

@implementation SafeDispatchGroupEnterAndLeaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)test_safeDispatchGroupEnterLeavePairWithGroupTaskInfo_runTaskBlock_allTaskCompletionBlock {
    WCGCDGroupTaskInfo *groupTaskInfo = [WCGCDGroupTaskInfo new];
    groupTaskInfo.taskQueue = dispatch_queue_create("com.wc.concurrent", DISPATCH_QUEUE_CONCURRENT);
    groupTaskInfo.completionQueue = dispatch_queue_create("com.wc.completion", DISPATCH_QUEUE_SERIAL);
    groupTaskInfo.dataArray = [self createTestData];
    
    [WCGCDTool safeDispatchGroupEnterLeavePairWithGroupTaskInfo:groupTaskInfo runTaskBlock:^(id  _Nonnull data, NSUInteger index, void (^ _Nonnull taskBlockFinished)(id _Nonnull, NSError * _Nullable)) {
        File *file = data;
        
        NSError *error = nil;
        file.name = [NSString stringWithFormat:@"test_%d", (int)index];
        file.path = [NSTemporaryDirectory() stringByAppendingPathComponent:file.name];
        BOOL success = [file.content writeToFile:file.path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (!success) {
            file.path = nil;
        }
        
        [NSThread sleepForTimeInterval:((arc4random() % 1000) / 1000.0)];
        
        taskBlockFinished(file, error);
        
    } allTaskCompletionBlock:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull errorArray) {
        // TODO
    }];
}

- (NSArray *)createTestData {
    NSUInteger count = 100;
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        File *file = [File new];
        file.content = [[NSString stringWithFormat:@"content of test_%d\n", (int)i] stringByAppendingString:[LoremIpsum paragraphsWithNumber:arc4random() % 100]];
        
        [arrM addObject:file];
    }
    
    return arrM;
}

@end
