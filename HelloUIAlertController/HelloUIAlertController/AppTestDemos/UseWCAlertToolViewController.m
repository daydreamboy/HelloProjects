//
//  UseWCAlertToolViewController.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/2/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseWCAlertToolViewController.h"
#import "WCAlertTool.h"

@interface UseWCAlertToolViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *methods;
@end

@implementation UseWCAlertToolViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self prepareForInit];
    }
    
    return self;
}

- (void)prepareForInit {
    self.title = @"Use WCAlertTool";

    // MARK: Configure titles and classes for table view
    _titles = @[
        @"Show action sheet with cancel button",
        @"show action with other button title",
        @"show action with other button title and callback",
        @"show action with other buttons",
    ];
    _methods = @[
        NSStringFromSelector(@selector(showActionSheetWithCancelButton)),
        NSStringFromSelector(@selector(showActionSheetWithOtherButtonTitle)),
        NSStringFromSelector(@selector(showActionSheetWithOtherButtonTitleAndCallback)),
        NSStringFromSelector(@selector(showActionSheetWithOtherButtons)),
    ];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushViewController:_methods[indexPath.row]];
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
        vc.title = _titles[[_methods indexOfObject:viewControllerClass]];
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Test Methods

- (void)showActionSheetWithCancelButton {
    [WCAlertTool presentActionSheetWithTitle:@"This is an action sheet" message:@"some tip here" cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    }, nil];
}

- (void)showActionSheetWithOtherButtonTitle {
    [WCAlertTool presentActionSheetWithTitle:@"This is an action sheet" message:nil cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    }, @"button1", nil];
}

- (void)showActionSheetWithOtherButtonTitleAndCallback {
    [WCAlertTool presentActionSheetWithTitle:@"This is an action sheet" message:@"" cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    }, @"button1", ^{
        NSLog(@"_cmd: %@, button1DidClick", NSStringFromSelector(_cmd));
    }, nil];
}

- (void)showActionSheetWithOtherButtons {
    [WCAlertTool presentActionSheetWithTitle:@"This is an action sheet" message:@"some tip here" cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:^{
        NSLog(@"_cmd: %@, cancelButtonDidClick", NSStringFromSelector(_cmd));
    }, @"button1", ^{
        NSLog(@"_cmd: %@, button1DidClick", NSStringFromSelector(_cmd));
    }, @"button2", ^{
        NSLog(@"_cmd: %@, button2DidClick", NSStringFromSelector(_cmd));
    }, nil];
}

@end
