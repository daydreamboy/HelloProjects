//
//  CreateVNodeDispatchSourceViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/31.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "CreateVNodeDispatchSourceViewController.h"

@interface NSDate (Addition)
+ (NSString *)stringFromCurrentDateWithFormat:(NSString *)format;
@end

@implementation NSDate (Addition)
+ (NSString *)stringFromCurrentDateWithFormat:(NSString *)format {
    static NSDateFormatter *sDateFormatter;
    if (!sDateFormatter) {
        sDateFormatter = [[NSDateFormatter alloc] init];
        sDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    }
    if (!format.length) {
        format = @"yyyy-MM-dd HH:mm:ss ZZ";
    }
    
    [sDateFormatter setDateFormat:format];
    
    return [sDateFormatter stringFromDate:[NSDate date]];
}
@end

@interface CreateVNodeDispatchSourceViewController ()
@property (nonatomic, strong) dispatch_source_t monitorFileNamesource;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) NSString *filePath;
@end

@implementation CreateVNodeDispatchSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *fileName = [NSDate stringFromCurrentDateWithFormat:@"yyyy-MM-dd'T'HH_mm_ss.SSS'Z'ZZ"];
    NSString *filePath = [self pathInCache:fileName];
    NSLog(@"filePath: %@", filePath);
    self.filePath = filePath;
    if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:[@"This is a test" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
        self.monitorFileNamesource = MonitorNameChangesToFile([filePath UTF8String]);
        
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC), 3ull * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, ^{
            NSString *newFilePath = [self pathInCache:[NSDate stringFromCurrentDateWithFormat:@"yyyy-MM-dd'T'HH_mm_ss.SSS'Z'ZZ"]];
            BOOL success = [[NSFileManager defaultManager] moveItemAtPath:self.filePath toPath:newFilePath error:nil];
            if (success) {
                NSLog(@"newFileName: %@", [newFilePath lastPathComponent]);
                self.filePath = newFilePath;
            }
        });
        dispatch_resume(timer);
        self.timer = timer;
    }
}

- (void)dealloc {
    dispatch_source_cancel(self.monitorFileNamesource);
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

dispatch_source_t MonitorNameChangesToFile(const char *fileme)
{
    int fd = open(fileme, O_EVTONLY);
    if (fd == -1) {
        return NULL;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd, DISPATCH_VNODE_RENAME, queue);
    if (source) {
        // Copy the filename for later use
        size_t length = strlen(fileme);
        char *newString = (char *)malloc(length + 1);
        newString = strcpy(newString, fileme);
        dispatch_set_context(source, newString);
        
        dispatch_source_set_event_handler(source, ^{
            const char *oldFilename = (char *)dispatch_get_context(source);
            MyUpdateFileName(oldFilename, fd);
        });
        
        dispatch_source_set_cancel_handler(source, ^{
            char *fileStr = dispatch_get_context(source);
            free(fileStr);
            close(fd);
        });
        
        dispatch_resume(source);
    }
    else {
        close(fd);
    }
    
    return source;
}

void MyUpdateFileName(const char *oldFileName, int fd)
{
    NSString *filePath = [NSString stringWithUTF8String:oldFileName];
    NSLog(@"first opened filename: %@", [filePath lastPathComponent]);
    /*
    NSDate *date = [NSDate date];
    NSString *dateString = [date description];
    
    int status = rename(oldFileName, [dateString UTF8String]);
    if (!status) {
        perror(oldFileName);
    }
    else {
        printf("renanme successfully");
    }
    */
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
