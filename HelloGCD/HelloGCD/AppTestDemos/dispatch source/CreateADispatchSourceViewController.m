//
//  CreateADispatchSourceViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/18.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "CreateADispatchSourceViewController.h"

@interface CreateADispatchSourceViewController ()
@property (nonatomic, strong) dispatch_source_t fileSource;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CreateADispatchSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *filePath = [self pathInCache:@"log.txt"];
    if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
        NSLog(@"create a log at path: %@", filePath);
        
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        [self test_create_a_dispatch_source];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
    
    NSString *filePath = [self pathInCache:@"log.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

- (void)test_create_a_dispatch_source {
    dispatch_queue_t myQueue = dispatch_queue_create("com.example.serialQueue", NULL);
    
    int fd = _fileHandle.fileDescriptor;
    dispatch_source_t readSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, myQueue);
    dispatch_source_set_event_handler(readSource, ^{
        size_t estimated = dispatch_source_get_data(readSource) + 1;
        char *buffer = (char *)malloc(estimated);
        
        if (buffer) {
            ssize_t actual = read(fd, buffer, (estimated));
            printf("%s", buffer);
            
            free(buffer);
        }
        
    });
    dispatch_resume(readSource);
    self.fileSource = readSource;
}

#pragma mark - NSTimer

- (void)timerFired:(NSTimer *)timer {
    NSString *line = @"hello, world\n";
    [_fileHandle writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"write a line");
}

#pragma mark - Utility

- (NSString *)pathInCache:(NSString *)subpath {
    static NSString *sCachePath;
    if (!sCachePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        sCachePath = ([paths count] > 0) ? paths[0] : nil;
    }
    return [sCachePath stringByAppendingPathComponent:subpath];
}

@end
