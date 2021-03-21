//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AppDelegate.h"

#import "RootViewController.h"

#import <dlfcn.h>
#import <assert.h>
#import <stdio.h>
#import <dispatch/dispatch.h>
#import <string.h>

char * getenv(const char *name)
{
    static void *handle;
    static char * (*real_getenv)(const char *);
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = dlopen("/usr/lib/system/libsystem_c.dylib", RTLD_NOW);
#if DEBUG
        assert(handle);
#endif
        
        if (handle) {
            real_getenv = dlsym(handle, "getenv");
            if (real_getenv == NULL)
            {
                const char* error = dlerror();
                printf("can't not find symbol: %s", error);
            }
            dlclose(handle);
        }
    });
  
    if (strcmp(name, "HOME") == 0) {
        return "/";
    }
    
    if (real_getenv != NULL) {
        return real_getenv(name);
    }
    else {
        return "";
    }
}

@interface AppDelegate ()
@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootViewController = [RootViewController new];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    
    NSLog(@"HOME env: %s", getenv("HOME"));
    NSLog(@"PATH env: %s", getenv("PATH"));

    return YES;
}

@end
