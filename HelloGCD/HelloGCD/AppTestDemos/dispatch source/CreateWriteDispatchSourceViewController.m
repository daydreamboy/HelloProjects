//
//  CreateWriteDispatchSourceViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/31.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "CreateWriteDispatchSourceViewController.h"

@interface CreateWriteDispatchSourceViewController ()
@property (nonatomic, strong) dispatch_source_t writeSource;
@end

@implementation CreateWriteDispatchSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *filePath = [self pathInCache:@"log.txt"];
    NSLog(@"filePath: %@", filePath);
    self.writeSource = WriteDataToFile([filePath UTF8String]);
}

dispatch_source_t WriteDataToFile(const char *filename)
{
    int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC, (S_IRUSR | S_IWUSR | S_ISUID | S_ISGID));
    if (fd == -1) {
        return NULL;
    }
    fcntl(fd, F_SETFL); // Block during the write
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t writeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_WRITE, fd, 0, queue);
    if (!writeSource) {
        close(fd);
        return NULL;
    }
    
    dispatch_source_set_event_handler(writeSource, ^{
        size_t bufferSize = MyGetDataSize();
        void *buffer = malloc(bufferSize);
        
        size_t actual = MyGetData(buffer, bufferSize);
        write(fd, buffer, actual);
        
        free(buffer);
        
        // Cancel and release the dispatch source when done
        dispatch_source_cancel(writeSource);
    });
    
    dispatch_source_set_cancel_handler(writeSource, ^{
        close(fd);
    });
    
    dispatch_resume(writeSource);
    
    return writeSource;
}

size_t MyGetDataSize()
{
    return 1024 * 1024 * 1024; // 1MB
}

size_t MyGetData(void *buffer, size_t bufferSize)
{
    char *str = "hello, world";
    size_t actualSize = strlen(str) * sizeof(char);
    
    strcpy(buffer, str);
    
    return actualSize;
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
