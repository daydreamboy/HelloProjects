//
//  ViewController.m
//  HelloGCDForMac
//
//  Created by wesley_chen on 2017/10/1.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) dispatch_source_t source1;
@property (nonatomic, strong) dispatch_source_t source2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (IBAction)buttonWatchingProcessesClicked:(id)sender {
    
    // @see https://www.objc.io/issues/2-concurrency/low-level-concurrency-apis/#watching-processes
    NSArray *array = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.mail"];
    if (!array.count) {
        NSLog(@"not founf Mail.app is running");
        return;
    }
    
    NSLog(@"start to listening Mail.app");
    
    pid_t const pid = [array.firstObject processIdentifier];
    self.source1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, pid, DISPATCH_PROC_EXIT, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(self.source1, ^{
        NSLog(@"Mail quit");
        
        // If you would like continue watching for the app to quit,
        // you should cancel this source with dispatch_source_cancel and create new one
        // as with next run app will have another process identifier.
    });
    dispatch_resume(self.source1);
}

- (IBAction)buttonWatchingFilesClicked:(id)sender {
    NSString *path = @"~/watched";
    NSURL *directoryURL = [NSURL URLWithString:[path stringByExpandingTildeInPath]];
    NSLog(@"start watching: %@", directoryURL);
    int const fd = open([directoryURL.path fileSystemRepresentation], O_EVTONLY);
    if (fd < 0) {
        char buffer[80];
        strerror_r(errno, buffer, sizeof(buffer));
        NSLog(@"Unable to open \"%@\": %s (%d)", directoryURL.path, buffer, errno);
        return;
    }
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd, DISPATCH_VNODE_WRITE | DISPATCH_VNODE_DELETE, DISPATCH_TARGET_QUEUE_DEFAULT);
    dispatch_source_set_event_handler(source, ^{
        unsigned long const data = dispatch_source_get_data(source);
        if (data & DISPATCH_VNODE_WRITE) {
            // case for add/remove files to the directory
            NSLog(@"The wathced directory changed.");
        }
        if (data & DISPATCH_VNODE_DELETE) {
            // case for delete the directory in Trash (not moving it to Trash)
            NSLog(@"The watched directory has been deleted.");
        }
    });
    
    dispatch_source_set_cancel_handler(source, ^{
        close(fd);
    });
    
    self.source2 = source;
    dispatch_resume(self.source2);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
