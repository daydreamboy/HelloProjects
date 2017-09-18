//
//  UseClassByHeaderViewController.m
//  HelloLazyLoadFramework-Manual
//
//  Created by wesley_chen on 18/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "UseClassByHeaderViewController.h"

#import <MyFramework1/MyFramework1.h>
#import <MyFramework2/MyFramework2.h>

@interface UseClassByHeaderViewController ()

@end

@implementation UseClassByHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFramwork1];
    
    NSLog(@"----------------------------------");
    
    [self loadFramwork2];
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
        MFManager *manager = [NSClassFromString(@"MFManager") new];
        NSLog(@"manager: %@", manager);
        // Note: calling instance method will not link framework on compile time
        [manager helloWithName:@"Lucy"];
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

- (void)loadFramwork2 {
    NSString *framework = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *myFramework2 = [framework stringByAppendingPathComponent:@"MyFramework2.framework"];
    NSBundle *myFramework2Bundle = [NSBundle bundleWithPath:myFramework2];
    NSError *error = nil;
    BOOL loaded = [myFramework2Bundle loadAndReturnError:&error];
    if (error) {
        NSLog(@"load failed: %@", error);
        return;
    }
    
    if (loaded) {
        [NSClassFromString(@"MFManager") hello]; // Warning: call hello from MyFramework1
    }
    
    [myFramework2Bundle unload];
    
    if (myFramework2Bundle.loaded) {
        NSLog(@"MyFramework2 still loaded after unload");
    }
    else {
        NSLog(@"Unloaded MyFramework2");
        // Note: MFManager still alive
        [NSClassFromString(@"MFManager") hello];
    }
}

@end
