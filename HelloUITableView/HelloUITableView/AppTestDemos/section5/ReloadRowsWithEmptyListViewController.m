//
//  ReloadRowsWithEmptyListViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/9/3.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ReloadRowsWithEmptyListViewController.h"
#import "WCTableViewTool.h"

@interface ReloadRowsWithEmptyListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation ReloadRowsWithEmptyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *reloadRowsItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload Rows" style:UIBarButtonItemStylePlain target:self action:@selector(reloadRowsItemClicked:)];
    
    UIBarButtonItem *reloadRowsFixedItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload Rows (Fixed)" style:UIBarButtonItemStylePlain target:self action:@selector(reloadRowsFixedItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[ reloadRowsFixedItem, reloadRowsItem ];
}

- (void)setup {
    NSArray *arr = @[
                     ];
    self.listData = arr;
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - Action

- (void)reloadRowsItemClicked:(id)sender {
    NSArray *indexPaths = @[
        [NSIndexPath indexPathForRow:0 inSection:0],
    ];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadRowsFixedItemClicked:(id)sender {
    NSArray *indexPaths = @[
        [NSIndexPath indexPathForRow:0 inSection:0],
    ];
    
    if ([WCTableViewTool checkWithTableView:self.tableView canReloadRowsAtIndexPaths:indexPaths]) {
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"ReloadRowsWithEmptyListViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.section][indexPath.row];
    
    return cell;
}

@end
