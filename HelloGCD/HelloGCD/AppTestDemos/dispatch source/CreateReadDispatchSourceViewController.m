//
//  CreateDescriptorDispatchSourceViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/27.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "CreateReadDispatchSourceViewController.h"

@interface CreateReadDispatchSourceViewController ()

@end

@implementation CreateReadDispatchSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *codeResourcesPath = [bundlePath stringByAppendingPathComponent:@"_CodeSignature/CodeResources"];
    NSLog(@"codeResourcesPath: %@", codeResourcesPath);
    ProcessContentsOfFile([codeResourcesPath UTF8String]);
}

dispatch_source_t ProcessContentsOfFile(const char *fileName)
{
    int fd = open(fileName, O_RDONLY);
    if (fd == -1) return NULL;
    fcntl(fd, F_SETFL, O_NONBLOCK); // Avoid blocking the read operation
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t readSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, queue);
    if (!readSource) {
        close(fd);
        return NULL;
    }
    
    dispatch_source_set_event_handler(readSource, ^{
        size_t estimated = dispatch_source_get_data(readSource) + 1;
        char *buffer = (char *)malloc(estimated);
        if (buffer) {
            ssize_t actual = read(fd, buffer, (estimated));
            Boolean done = MyProcessFileData(buffer, actual);
            
            free(buffer);
            
            if (done) {
                dispatch_source_cancel(readSource);
            }
        }
    });
    
    dispatch_source_set_cancel_handler(readSource, ^{
        NSLog(@"close file");
        close(fd);
    });
    
    dispatch_resume(readSource);
    
    return readSource;
}

Boolean MyProcessFileData(char *data, ssize_t size) {
    printf("%s", data);
    return true;
}

@end
