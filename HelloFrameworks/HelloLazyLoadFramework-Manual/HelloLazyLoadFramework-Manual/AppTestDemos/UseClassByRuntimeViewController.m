//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseClassByRuntimeViewController.h"
#import "dlfcn.h"

@interface UseClassByRuntimeViewController ()

@end

@implementation UseClassByRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadFramwork1];
    
    NSLog(@"-------------------------------------------");

    /*
     Loading the second framework will give a message in the console saying that
     both classes will be loaded and referencing the class will result in
     undefined behavior.

     objc[5074]: Class MFManager is implemented in both
     /private/var/containers/Bundle/Application/1688AD11-CA2A-44F5-9E98-AC1C7495B569/ios-dynamic-loading-framework.app/Frameworks/MyFramework1.framework/MyFramework1
     and
     /private/var/containers/Bundle/Application/1688AD11-CA2A-44F5-9E98-AC1C7495B569/ios-dynamic-loading-framework.app/Frameworks/MyFramework2.framework/MyFramework2.
     One of the two will be used. Which one is undefined.
     */

    [self loadFramwork2];
}

- (void)loadFramwork1 {
    void *framework1Handle = dlopen("MyFramework1.framework/MyFramework1", RTLD_LAZY);

    if (NSClassFromString(@"MFManager")) {
        NSLog(@"Loaded MFManager in MyFramework1");
        Class MFManagerClz = NSClassFromString(@"MFManager");
        [MFManagerClz performSelector:@selector(hello)];
    } else {
        NSLog(@"Could not load MFManager in MyFramework1");
    }

    dlclose(framework1Handle);

    if (NSClassFromString(@"MFManager")) {
        NSLog(@"MFManager from MyFramework1 still loaded after dlclose()");
    } else {
        NSLog(@"Unloaded MyFramework1");
    }
}

- (void)loadFramwork2 {
    void *framework2Handle = dlopen("MyFramework2.framework/MyFramework2", RTLD_LAZY);

    if (NSClassFromString(@"MFManager")) {
        NSLog(@"Loaded MFManager in MyFramework2");
        Class MFManagerClz = NSClassFromString(@"MFManager");
        [MFManagerClz performSelector:@selector(hello)]; // Warning: call hello from MyFramework1, because it's first loaded
    } else {
        NSLog(@"Could not load MFManager in MyFramework2");
    }

    dlclose(framework2Handle);

    if (NSClassFromString(@"MFManager")) {
        NSLog(@"MFManager from MyFramework2 still loaded after dlclose()");
    } else {
        NSLog(@"Unloaded MyFramework2");
    }
}

@end
