//
//  StaticCellHeightAboveiOS11IssuesViewController.m
//  HelloUITableViewCell
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "StaticCellHeightAboveiOS11IssuesViewController.h"

@interface StaticCellHeightAboveiOS11IssuesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *staticCells;
@end

@implementation StaticCellHeightAboveiOS11IssuesViewController

static NSString *sStaticCell1Identifier = @"sStaticCell1Identifier";
static NSString *sStaticCell2Identifier = @"sStaticCell2Identifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)changeHeight:(CGFloat)height forView:(UIView *)view {
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSArray *)staticCells {
    if (!_staticCells) {
        UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sStaticCell1Identifier];
        cell1.textLabel.text = @"cell1";
        cell1.backgroundColor = [UIColor yellowColor];
        [self changeHeight:20 forView:cell1];
        
        UITableViewCell *cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sStaticCell2Identifier];
        cell2.textLabel.text = @"cell2";
        cell2.backgroundColor = [UIColor orangeColor];
        [self changeHeight:100 forView:cell2];
        
        _staticCells = @[cell1, cell2];
    }
    
    return _staticCells;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.staticCells.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.staticCells[indexPath.row];
    CGFloat cellHeight = CGRectGetHeight(cell.bounds);
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.staticCells[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
