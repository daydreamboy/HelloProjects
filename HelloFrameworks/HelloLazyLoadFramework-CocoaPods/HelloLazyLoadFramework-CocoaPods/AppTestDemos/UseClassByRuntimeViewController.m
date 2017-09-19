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
}

- (void)loadFramwork1 {
    void *framework1Handle = dlopen("MyFramework.framework/MyFramework", RTLD_LAZY);

    if (NSClassFromString(@"MyManager")) {
        NSLog(@"Loaded MyManager in MyFramework");
        Class MyManagerClz = NSClassFromString(@"MyManager");
        [MyManagerClz performSelector:@selector(hello)];
        
        id myManagerInstance = [[NSClassFromString(@"MyManager") alloc] initWithName:@"Mike"];
        [myManagerInstance performSelector:@selector(sayHello)];
    } else {
        NSLog(@"Could not load MyManager in MyFramework");
    }

    dlclose(framework1Handle);

    if (NSClassFromString(@"MyManager")) {
        NSLog(@"MFManager from MyFramework still loaded after dlclose()");
    } else {
        NSLog(@"Unloaded MyFramework");
    }
}

@end
