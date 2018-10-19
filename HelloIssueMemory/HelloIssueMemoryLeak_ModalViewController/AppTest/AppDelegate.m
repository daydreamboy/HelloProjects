//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/9/5.
//
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) LoginViewController *viewController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[LoginViewController alloc] init];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)switchRootViewController {
    HomeViewController *homeViewController = [HomeViewController new];
    
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.window.rootViewController = homeViewController;
                    }
                    completion:^(BOOL finished) {
                        
                        // !!!: 下面会产生内存泄漏问题
                        
                        // Note: presentViewController和dismissViewControllerAnimated必须成对，否则可能存在内存泄漏
                        // 如果注释掉下面一行，则self.viewController present的ModalViewController不会被释放
                        //[self.viewController dismissViewControllerAnimated:NO completion:nil];
                        
                        // 如果注释上面一行，强制置为nil，也不会释放self.viewController
                        self.viewController = nil;
                    }];
}

@end
