//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AppDelegate.h"

#import "RootViewController.h"

@implementation Person

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end

#pragma mark - 

@interface AppDelegate ()
@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navController;

@property (nonatomic, strong) NSMutableArray *people;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootViewController = [RootViewController new];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Public Methods

+ (NSArray *)people {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appDelegate.people) {
        NSArray *firstNames = @[ @"Alice", @"Bob", @"Charlie", @"Quentin" ];
        NSArray *lastNames = @[ @"Smith", @"Jones", @"Smith", @"Alberts" ];
        NSArray *ages = @[ @24, @27, @33, @31 ];
        
        NSMutableArray *people = [NSMutableArray array];
        [firstNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Person *person = [[Person alloc] init];
            person.firstName = firstNames[idx];
            person.lastName = lastNames[idx];
            person.age = ages[idx];
            [people addObject:person];
        }];
        
        appDelegate.people = people;
    }
    
    return appDelegate.people;
}

@end
