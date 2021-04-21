//
//  ShowEmptyTipViewInUITableViewViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2019/6/5.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ShowEmptyTipViewInUITableViewViewController.h"
#import "WCMacroTool.h"
#import "WCTableViewTool.h"

@interface ShowEmptyTipViewInUITableViewViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation ShowEmptyTipViewInUITableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setup {
    NSArray *arr = @[
                     @[
                         @"viewDidLoad",
                         @"UITableView",
                         @"UITableView2",
                         @"screenSize",
                         @"UITableViewCell",
                         ],
                     @[
                         @"UIScreen",
                         @"backgroundColor",
                         @"view",
                         @"self",
                         @"whiteColor",
                         @"UIColor",
                         @"initWithFrame",
                         ],
                     @[
                         @"UITableViewStylePlain",
                         @"delegate",
                         @"dataSource",
                         @"UITableViewDelegate",
                         @"UITableViewDataSource",
                         @"FadeInCellRowByRowViewController",
                         @"listData",
                         ],
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
        tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30)];
            view.backgroundColor = [UIColor yellowColor];
            view;
        });
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numOfSections = [self.listData count];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [WCTableViewTool showEmptyViewWithTableView:tableView numberOfRows:numOfSections customizeBlock:^(UITableView * _Nonnull tableView, UIView * _Nonnull contentView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)];
        noDataLabel.text = @"No data available";
        noDataLabel.textColor = [UIColor redColor];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        
        [contentView addSubview:noDataLabel];
    }];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ARR_SAFE_GET(self.listData, section) count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FadeInCellRowByRowViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - Action

- (void)rightItemClicked:(id)sender {
    static int count;
    count++;
    
    if (count % 2 == 0) {
        [self setup];
    }
    else {
        self.listData = nil;
    }
    [self.tableView reloadData];
}

@end
