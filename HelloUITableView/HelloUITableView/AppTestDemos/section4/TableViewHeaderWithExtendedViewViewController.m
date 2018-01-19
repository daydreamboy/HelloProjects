//
//  TableViewHeaderWithExtendedViewViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 18/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TableViewHeaderWithExtendedViewViewController.h"

@interface TableHeaderViewWithExtendedColorTableView : UITableView
@end

@implementation TableHeaderViewWithExtendedColorTableView
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    // http://stackoverflow.com/questions/1114587/different-background-colors-for-the-top-and-bottom-of-a-uitableview
    
    // Note: UITableViewWrapperView is an internal subview of UITableView, which contains tableHeaderView, tableFooterView, section views (header/footer) and cells. The `extendedView` just above UITableViewWrapperView, and its height is same as UITableView.
    CGRect frame = self.bounds;
    frame.origin.y = -frame.size.height;
    UIView *extendedView = [[UIView alloc] initWithFrame:frame];
    extendedView.backgroundColor = self.tableHeaderView.backgroundColor;
    [self addSubview:extendedView];
}
@end

@interface TableViewHeaderWithExtendedViewViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableViewPlain;
@property (nonatomic, strong) UITableView *tableViewGrouped;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation TableViewHeaderWithExtendedViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Plain", @"Grouped"]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControlIndexSelected:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableViewPlain];
    [self.view addSubview:self.tableViewGrouped];
    
    [self segmentedControlIndexSelected:segmentedControl];
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

#pragma mark - Actions

- (void)segmentedControlIndexSelected:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.tableViewPlain.hidden = NO;
        self.tableViewGrouped.hidden = YES;
    }
    else if (segmentedControl.selectedSegmentIndex == 1) {
        self.tableViewPlain.hidden = YES;
        self.tableViewGrouped.hidden = NO;
    }
}

#pragma mark - Getters

- (UITableView *)tableViewPlain {
    if (!_tableViewPlain) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        TableHeaderViewWithExtendedColorTableView *tableView = [[TableHeaderViewWithExtendedColorTableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        CGFloat tableHeaderViewHeight = 40;
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableHeaderViewHeight)];
        tableHeaderView.backgroundColor = [UIColor yellowColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
        label.text = @"This is table view header";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 4;
        [tableHeaderView addSubview:label];
        
        tableView.tableHeaderView = tableHeaderView;
        
        _tableViewPlain = tableView;
    }
    
    return _tableViewPlain;
}
     
- (UITableView *)tableViewGrouped {
    if (!_tableViewGrouped) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        TableHeaderViewWithExtendedColorTableView *tableView = [[TableHeaderViewWithExtendedColorTableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        CGFloat tableHeaderViewHeight = 40;
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableHeaderViewHeight)];
        tableHeaderView.backgroundColor = [UIColor yellowColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
        label.text = @"This is table view header";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20];
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 4;
        [tableHeaderView addSubview:label];
        
        tableView.tableHeaderView = tableHeaderView;
        
        _tableViewGrouped = tableView;
    }
    
    return _tableViewGrouped;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor lightGrayColor]];
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
    }
    
    cell.textLabel.text = self.listData[indexPath.section][indexPath.row];
    
    return cell;
}

@end
