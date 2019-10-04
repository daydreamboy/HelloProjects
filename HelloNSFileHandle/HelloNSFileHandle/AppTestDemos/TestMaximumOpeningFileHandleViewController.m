//
//  TestMaximumOpeningFileHandleViewController.m
//  HelloNSFileHandle
//
//  Created by wesley_chen on 2019/10/4.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TestMaximumOpeningFileHandleViewController.h"

#define SHOW_ALERT(title, msg, cancel, dismissCompletion) \
\
do { \
    if ([UIAlertController class]) { \
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(title) message:(msg) preferredStyle:UIAlertControllerStyleAlert]; \
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:(cancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { \
            dismissCompletion; \
        }]; \
        [alert addAction:cancelAction]; \
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; \
    } \
} while (0)

@interface TestMaximumOpeningFileHandleViewController ()

@end

@implementation TestMaximumOpeningFileHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *infoPlistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
    
    NSUInteger maximum = 10000;
    // maximum = 100;
    NSUInteger count = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:infoPlistPath]) {
        for (NSUInteger i = 0; i < maximum; ++i) {
            FILE *file = fopen([infoPlistPath UTF8String], "r");
            if (file != NULL) {
                // @see https://stackoverflow.com/questions/3167298/how-can-i-convert-a-file-pointer-file-fp-to-a-file-descriptor-int-fd
                int fd = fileno(file);
                
                // Note: pass NO to not close the file handle on purpose
                NSFileHandle *handle = [[NSFileHandle alloc] initWithFileDescriptor:fd closeOnDealloc:NO];
                NSLog(@"%@", handle);
                count++;
            }
            
            NSError *error;
            NSArray *list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mainBundleDirectory error:&error];
            
            if (error) {
                NSLog(@"maximum opening handle: %ld", (long)count);
                NSLog(@"%@", list);
                NSLog(@"%@", error); // Maybe error: {Error Domain=NSPOSIXErrorDomain Code=24 "Too many open files"}}
                
                NSString *msg = [NSString stringWithFormat:@"maximum opening file: %ld", (long)count];
                SHOW_ALERT(@"Error: Reached the maximum opening file", msg, @"Ok", nil);
                break;
            }
        }
    }
}

@end
