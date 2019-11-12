//
//  UseSafeAreaInsetsViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/10.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseSafeAreaInsetsViewController.h"
#import "ShowSafeAreaViewController.h"
#import "ShowCustomViewSafeAreaViewController.h"
#import "ShowCustomViewFixedSafeAreaLayoutFrameViewController.h"

@interface UseSafeAreaInsetsViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@end

@implementation UseSafeAreaInsetsViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"Use safeAreaInsets";

    // MARK: Configure titles and classes for table view
    _titles = @[
        @"Only status bar view controller",
        @"With nav bar's view controller",
        @"With tab bar's view controller",
        @"safe area of customized view",
        @"safe area layout frame of customized view",
        @"call a test method",
    ];
    _classes = @[
        @"presentViewControllerWithStatusBar",
        @"presentViewControllerWithNavBar",
        @"presentViewControllerWithTabBar",
        @"presentShowCustomViewSafeAreaViewController",
        @"presentShowCustomViewFixedSafeAreaLayoutFrameViewController",
        @"testMethod",
    ];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushViewController:_classes[indexPath.row]];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = _titles[indexPath.row];

    return cell;
}

- (void)pushViewController:(id)viewControllerClass {
    
    id class = viewControllerClass;
    if ([class isKindOfClass:[NSString class]]) {
        SEL selector = NSSelectorFromString(viewControllerClass);
        if ([self respondsToSelector:selector]) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:selector];
#pragma GCC diagnostic pop
        }
        else {
            NSAssert(NO, @"can't handle selector `%@`", viewControllerClass);
        }
    }
    else if (class && [class isSubclassOfClass:[UIViewController class]]) {
        UIViewController *vc = [[class alloc] init];
        vc.title = _titles[[_classes indexOfObject:viewControllerClass]];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Test Methods

- (void)testMethod {
    NSLog(@"test something");
}

- (void)presentViewControllerWithStatusBar {
    ShowSafeAreaViewController *vc = [ShowSafeAreaViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)presentViewControllerWithNavBar {
    ShowSafeAreaViewController *vc = [ShowSafeAreaViewController new];
    vc.title = @"This is a nav bar";
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentViewControllerWithTabBar {
    ShowSafeAreaViewController *vc1 = [ShowSafeAreaViewController new];
    ShowSafeAreaViewController *vc2 = [ShowSafeAreaViewController new];
    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    tabController.viewControllers = @[vc1, vc2];
    [self presentViewController:tabController animated:YES completion:nil];
}

- (void)presentShowCustomViewSafeAreaViewController {
    ShowCustomViewSafeAreaViewController *vc = [ShowCustomViewSafeAreaViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)presentShowCustomViewFixedSafeAreaLayoutFrameViewController {
    ShowCustomViewFixedSafeAreaLayoutFrameViewController *vc = [ShowCustomViewFixedSafeAreaLayoutFrameViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
