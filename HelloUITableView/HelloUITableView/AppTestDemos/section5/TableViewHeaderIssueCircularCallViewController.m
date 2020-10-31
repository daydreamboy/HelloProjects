//
//  TableViewHeaderIssueViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/10/31.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TableViewHeaderIssueCircularCallViewController.h"
#import "WCColorTool.h"

@interface TableViewHeaderIssueCircularCallViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation TableViewHeaderIssueCircularCallViewController

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
        
        // !!!: Firstly set tableHeaderView will call numberOfSectionsInTableView: method
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
    NSLog(@"numberOfSectionsInTableView called");
    __unused NSInteger numOfSections = [self.listData count];
    
    // !!!: self.tableView will call getter method which set tableHeaderView again, this make a cycle to crash
    // MARK: Solution: use _tableView instead of self.tableView to break the cycle
    /*
    if (numOfSections) {
     */
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = nil;
    /*
    }
    else {
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        noDataLabel.text = @"No data available";
        noDataLabel.textColor = [UIColor redColor];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = noDataLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
     */
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"TableViewHeaderIssueViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - Action

- (void)rightItemClicked:(id)sender {
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 30)];
        view.backgroundColor = [WCColorTool randomColor];
        view;
    });
}

@end
