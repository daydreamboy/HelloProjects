//
//  PlainTableViewWithFullSeparatorsViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 18/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "PlainTableViewWithFullSeparatorsViewController.h"

@interface PlainTableViewWithFullSeparatorsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation PlainTableViewWithFullSeparatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
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
        tableView.tableFooterView = [UIView new];
        
        _tableView = tableView;
    }
    
    return _tableView;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6]];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FadeInCellRowByRowViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        
        // Note: works on iOS 7、iOS 10+
        cell.separatorInset = UIEdgeInsetsZero;
        
        // iOS 8-9
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        
        // iOS 8-9
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
    }
    
    cell.textLabel.text = self.listData[indexPath.section][indexPath.row];
    
    return cell;
}

@end
