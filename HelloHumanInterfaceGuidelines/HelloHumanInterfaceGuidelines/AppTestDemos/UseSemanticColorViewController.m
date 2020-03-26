//
//  UseSemanticColorViewController.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/3/20.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseSemanticColorViewController.h"
#import "MyTableViewCell.h"
#import "WCImageTool.h"

@interface UseSemanticColorViewController () <UITableViewDelegate, UITableViewDataSource, MyTableViewCellDelete>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *listData;
@end

@implementation UseSemanticColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = [@[
        @"systemRed",
        @"systemOrange",
        @"systemYellow",
        @"systemGreen",
        @"systemTeal",
        @"systemBlue",
        @"systemIndigo",
        @"systemPurple",
        @"systemPink",
        @"systemGray",
        @"systemGray2",
        @"systemGray3",
        @"systemGray4",
        @"systemGray5",
        @"systemGray6",
    ] mutableCopy];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self.view addSubview:self.tableView];
    
    UIMenuItem *menuItemDelete = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteCell:)];
    UIMenuItem *menuItemReloadTable = [[UIMenuItem alloc] initWithTitle:@"Reload Table" action:@selector(reloadTable:)];
    
    [UIMenuController sharedMenuController].menuItems = @[ menuItemDelete, menuItemReloadTable ];
    [[UIMenuController sharedMenuController] update];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma GCC diagnostic pop
    }
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(deleteCell:) || action == @selector(reloadTable:)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSLog(@"performAction: %@", NSStringFromSelector(action));

    // Note: custom menu action not called at here
    if (action == @selector(deleteCell:)) {
        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (MyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"sCellIdentifier";
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    cell.textLabel.text = self.listData[indexPath.row];
    
    NSString *selectorString = [NSString stringWithFormat:@"%@Color", self.listData[indexPath.row]];
    SEL selector = NSSelectorFromString(selectorString);
    if ([UIColor respondsToSelector:selector]) {
        UIColor *color = [UIColor performSelector:selector];
        cell.textLabel.textColor = color;
        cell.imageView.image = [WCImageTool imageWithColor:color size:CGSizeMake(44, 44) cornerRadius:5];
    }
    else {
        cell.imageView.image = nil;
    }
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - MyTableViewCellDelete

- (void)myTableViewCellMenuItemDeleteDidClick:(MyTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
//        [self.listData removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)myTableViewCellMenuItemReloadTableDidClick:(MyTableViewCell *)cell {
//    self.listData = [@[ @"1", @"2", @"3" ] mutableCopy];
//    [self.tableView reloadData];
}

@end
