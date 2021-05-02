//
//  ResultsTableController.m
//  HelloUISearchController
//
//  Created by wesley_chen on 2021/5/2.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "ResultsTableController.h"
#import "Product.h"

@interface ResultsTableController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) UIView *resultsLabelBackgroundView;
@end

@implementation ResultsTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.resultsLabelBackgroundView];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat height = screenSize.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - CGRectGetHeight(_resultsLabelBackgroundView.frame);
    
    self.resultsLabelBackgroundView.frame = CGRectMake(0, 0, screenSize.width, 31);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(_resultsLabelBackgroundView.frame), screenSize.width, height);
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat height = screenSize.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - CGRectGetHeight(_resultsLabelBackgroundView.frame);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_resultsLabelBackgroundView.frame), screenSize.width, height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (UIView *)resultsLabelBackgroundView {
    if (!_resultsLabelBackgroundView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 31)];
        view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        
        [view addSubview:self.resultsLabel];
        
        _resultsLabelBackgroundView = view;
    }
    
    return _resultsLabelBackgroundView;
}

- (UILabel *)resultsLabel {
    if (!_resultsLabel) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat paddingH = 8;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, 0, screenSize.width - 2 * paddingH, 31)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor lightGrayColor];
        
        _resultsLabel = label;
    }
    
    return _resultsLabel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredProducts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"ResultsTableController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Product *product = self.filteredProducts[indexPath.row];
    
    cell.textLabel.text = product.title;
    
    NSString *priceString = [product formattedIntroPrice];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", priceString, @(product.yearIntroduced)];
    
    return cell;
}

@end
