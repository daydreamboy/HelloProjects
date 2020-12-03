//
//  SceneDelegate.m
//  HelloUISceneDelegate
//
//  Created by wesley_chen on 2020/12/2.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()
@property (nonatomic, strong) ViewController *viewController;
@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {

    // Note: suppose the scene is always UIWindowScene instance, which is from
    // Swift template code
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    self.viewController = [[ViewController alloc] init];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
}

@end
