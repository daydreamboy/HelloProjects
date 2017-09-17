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
    // Loading the first dynamic library here works fine :)
    NSLog(@"Before referencing MFManager in MyFramework1");
    [self loadFramwork1];
    
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
    NSLog(@"Before referencing MFManager in MyFramework2");
    [self loadFramwork2];
}

- (void)loadFramwork1 {
    void *framework1Handle =
    dlopen("MyFramework1.framework/MyFramework1", RTLD_LAZY);
    
    if (NSClassFromString(@"MFManager")) {
        NSLog(@"Loaded MFManager in MyFramework1");
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
    void *framework1Handle =
    dlopen("MyFramework2.framework/MyFramework2", RTLD_LAZY);
    
    if (NSClassFromString(@"MFManager")) {
        NSLog(@"Loaded MFManager in MyFramework2");
    } else {
        NSLog(@"Could not load MFManager in MyFramework2");
    }
    
    dlclose(framework1Handle);
    
    if (NSClassFromString(@"MFManager")) {
        NSLog(@"MFManager from MyFramework2 still loaded after dlclose()");
    } else {
        NSLog(@"Unloaded MyFramework2");
    }
}

@end
