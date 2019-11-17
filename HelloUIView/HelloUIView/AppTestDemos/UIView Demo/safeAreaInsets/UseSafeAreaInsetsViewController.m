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
#import "ShowScrollViewContentInsetAdjustmentBehaviorViewController.h"
#import "AutomaticallyAdjustsScrollViewInsetsViewController.h"

#define kTitle @"Title"
#define kClass @"Class"

@interface UseSafeAreaInsetsViewController ()
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray<NSArray<NSDictionary *> *> *classes;
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

    
    // MARK: Configure sectionTitles and classes for table view
    NSArray<NSDictionary *> *section1 = @[
          @{ kTitle: @"Only status bar view controller", kClass: @"presentViewControllerWithStatusBar" },
          @{ kTitle: @"With nav bar's view controller", kClass: @"presentViewControllerWithNavBar" },
          @{ kTitle: @"With tab bar's view controller", kClass: @"presentViewControllerWithTabBar" },
          @{ kTitle: @"safe area of customized view", kClass: @"presentShowCustomViewSafeAreaViewController" },
          @{ kTitle: @"safe area layout frame of customized view", kClass: @"presentShowCustomViewFixedSafeAreaLayoutFrameViewController" },
          @{ kTitle: @"contentInsetAdjustmentBehavior of scroll view", kClass: @"presentShowScrollViewContentInsetAdjustmentBehaviorViewController" },
    ];

    NSArray<NSDictionary *> *section2 = @[
          @{ kTitle: @"UIScrollView inside UIViewController", kClass: @"presentAutomaticallyAdjustsScrollViewInsetsViewController1" },
          @{ kTitle: @"UIScrollView inside nav controller with nav bar hidden", kClass: @"presentAutomaticallyAdjustsScrollViewInsetsViewController2" },
          @{ kTitle: @"UIScrollView inside nav controller", kClass: @"presentAutomaticallyAdjustsScrollViewInsetsViewController3" },
          @{ kTitle: @"UIScrollView not top to the screen", kClass: @"presentAutomaticallyAdjustsScrollViewInsetsViewController4" },
    ];
    
    _sectionTitles = @[
        @"Safe Area",
        @"automaticallyAdjustsScrollViewInsets",
    ];
    
    _classes = @[
         section1,
         section2,
    ];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _classes[indexPath.section][indexPath.row];
    [self pushViewController:dict];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_classes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_classes[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *cellTitle = [_classes[indexPath.section][indexPath.row] objectForKey:kTitle];
    cell.textLabel.text = cellTitle;
    
    return cell;
}

- (void)pushViewController:(NSDictionary *)dict {
    id viewControllerClass = dict[kClass];
    
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
        vc.title = dict[kTitle];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Test Methods

#pragma mark - Section 1 (Run iOS 11+ simulator or device)

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

- (void)presentShowScrollViewContentInsetAdjustmentBehaviorViewController {
    ShowScrollViewContentInsetAdjustmentBehaviorViewController *vc = [ShowScrollViewContentInsetAdjustmentBehaviorViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Section 2 (Run iOS 11- simulator or device)

- (void)presentAutomaticallyAdjustsScrollViewInsetsViewController1 {
    AutomaticallyAdjustsScrollViewInsetsViewController *vc = [AutomaticallyAdjustsScrollViewInsetsViewController new];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)presentAutomaticallyAdjustsScrollViewInsetsViewController2 {
    AutomaticallyAdjustsScrollViewInsetsViewController *vc = [AutomaticallyAdjustsScrollViewInsetsViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.navigationBarHidden = YES;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentAutomaticallyAdjustsScrollViewInsetsViewController3 {
    AutomaticallyAdjustsScrollViewInsetsViewController *vc = [AutomaticallyAdjustsScrollViewInsetsViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.navigationBarHidden = NO;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentAutomaticallyAdjustsScrollViewInsetsViewController4 {
    AutomaticallyAdjustsScrollViewInsetsViewController *vc = [AutomaticallyAdjustsScrollViewInsetsViewController new];
    vc.startY = 40;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.navigationBarHidden = YES;
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
