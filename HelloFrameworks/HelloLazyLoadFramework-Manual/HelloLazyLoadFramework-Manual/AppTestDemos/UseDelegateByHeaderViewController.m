//
//  UseDelegateByHeaderViewController.m
//  HelloLazyLoadFramework-Manual
//
//  Created by wesley_chen on 18/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "UseDelegateByHeaderViewController.h"

#import <MyFramework1/MyFramework1.h>

@interface UseDelegateByHeaderViewController ()

@end

@implementation UseDelegateByHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFramwork1];
}

- (void)loadFramwork1 {
    NSString *framework = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *myFramework1 = [framework stringByAppendingPathComponent:@"MyFramework1.framework"];
    NSBundle *myFramework1Bundle = [NSBundle bundleWithPath:myFramework1];
    NSError *error = nil;
    BOOL loaded = [myFramework1Bundle loadAndReturnError:&error];
    if (error) {
        NSLog(@"load failed: %@", error);
        return;
    }
    
    if (loaded) {
        // Note: can't call [MFManager hello] directly, calling class method will link framework on compile time
        [NSClassFromString(@"MFManager") hello];
        
        // Note: use Class only, will not link framework on compile time
        id<ManagerBehavior> manager = [NSClassFromString(@"MFManager") defaultManager];
        NSLog(@"manager: %@, %@", manager, [manager defaultName]);
    }
    
    [myFramework1Bundle unload];
    
    if (myFramework1Bundle.loaded) {
        NSLog(@"MyFramework1 still loaded after unload");
    }
    else {
        NSLog(@"Unloaded MyFramework1");
        // Note: MFManager still alive
        [NSClassFromString(@"MFManager") hello];
    }
}

@end
