//
//  TableViewCellShowContextMenuIssueViewController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TableViewCellShowCustomContextMenuViewController.h"
#import "MyTableViewCell.h"

@interface TableViewCellShowCustomContextMenuViewController () <UITableViewDelegate, UITableViewDataSource, MyTableViewCellDelete>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *listData;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation TableViewCellShowCustomContextMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listData = [@[ @"1", @"2", @"3" ] mutableCopy];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textField];
    
    UIMenuItem *menuItemDelete = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteCell:)];
    UIMenuItem *menuItemReloadTable = [[UIMenuItem alloc] initWithTitle:@"Reload Table" action:@selector(reloadTable:)];
    
    [UIMenuController sharedMenuController].menuItems = @[ menuItemDelete, menuItemReloadTable ];
    [[UIMenuController sharedMenuController] update];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 200) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 10;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.tableView.frame) + 1, screenSize.width - 2 * paddingH, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"Type here ...";
        
        _textField = textField;
    }
    
    return _textField;
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (MyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"sCellIdentifier";
    MyTableViewCell *cell = (MyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.listData[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - MyTableViewCellDelete

- (void)myTableViewCellMenuItemDeleteDidClick:(MyTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [self.listData removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)myTableViewCellMenuItemReloadTableDidClick:(MyTableViewCell *)cell {
    self.listData = [@[ @"1", @"2", @"3" ] mutableCopy];
    [self.tableView reloadData];
}

@end
