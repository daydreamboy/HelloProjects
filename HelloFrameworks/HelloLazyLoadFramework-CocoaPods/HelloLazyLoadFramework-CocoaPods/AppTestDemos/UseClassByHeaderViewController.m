//
//  UseClassByHeaderViewController.m
//  HelloLazyLoadFramework-Manual
//
//  Created by wesley_chen on 18/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "UseClassByHeaderViewController.h"

#import <MyFramework/MyFramework.h>

@interface UseClassByHeaderViewController ()

@end

@implementation UseClassByHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFramwork1];
}

- (void)loadFramwork1 {
    NSString *framework = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *MyFramework = [framework stringByAppendingPathComponent:@"MyFramework.framework"];
    NSBundle *MyFrameworkBundle = [NSBundle bundleWithPath:MyFramework];
    NSError *error = nil;
    BOOL loaded = [MyFrameworkBundle loadAndReturnError:&error];
    if (error) {
        NSLog(@"load failed: %@", error);
        return;
    }
    
    if (loaded) {
        // Note: can't call [MyManager hello] directly, calling class method will link framework on compile time
        [NSClassFromString(@"MyManager") hello];
        
        // Note: use Class only, will not link framework on compile time
        MyManager *manager = [[NSClassFromString(@"MyManager") alloc] initWithName:@"Lucy"];
        NSLog(@"manager: %@", manager);
        // Note: calling instance method will not link framework on compile time
        [manager sayHello];
    }
    
    [MyFrameworkBundle unload];
    
    if (MyFrameworkBundle.loaded) {
        NSLog(@"MyFramework still loaded after unload");
    }
    else {
        NSLog(@"Unloaded MyFramework");
        // Note: MyManager still alive
        [NSClassFromString(@"MyManager") hello];
    }
}

@end
