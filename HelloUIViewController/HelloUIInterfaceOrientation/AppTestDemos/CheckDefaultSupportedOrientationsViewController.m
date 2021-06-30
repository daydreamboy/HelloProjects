//
//  CheckDefaultSupportedOrientationsViewController.m
//  HelloUIInterfaceOrientation
//
//  Created by wesley_chen on 2021/6/30.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "CheckDefaultSupportedOrientationsViewController.h"
#import "DummySingleViewController.h"
#import "DummyNavController.h"
#import "DummyNavRootViewController.h"

@interface CheckDefaultSupportedOrientationsViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classes;
@end

@implementation CheckDefaultSupportedOrientationsViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"Check Default SupportedOrientations";

    // MARK: Configure titles and classes for table view
    _titles = @[
        @"check single UIViewController",
        @"check UINavigationController",
    ];
    _classes = @[
        @"check_UIViewController",
        @"check_UINavigationController",
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

- (void)check_UIViewController {
    DummySingleViewController *viewController = [[DummySingleViewController alloc] init];
    
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (void)check_UINavigationController {
    DummyNavRootViewController *rootViewController = [DummyNavRootViewController new];
    DummyNavController *navController = [[DummyNavController alloc] initWithRootViewController:rootViewController];
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

@end
