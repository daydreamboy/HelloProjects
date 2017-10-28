//
//  FadeInCellRowByRowViewController.m
//  HelloCustomziedViews
//
//  Created by wesley_chen on 26/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "FadeInCellRowByRowViewController.h"

@interface FadeInCellRowByRowViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *listData;
@property (nonatomic, strong) NSMutableSet<NSIndexPath *> *animatedIndexPaths;
@end

@implementation FadeInCellRowByRowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)setup {
    NSArray *arr = @[
                     @"viewDidLoad",
                     @"UITableView",
                     @"UITableView2",
                     @"screenSize",
                     @"UITableViewCell",
                     @"UIScreen",
                     @"backgroundColor",
                     @"view",
                     @"self",
                     @"whiteColor",
                     @"UIColor",
                     @"initWithFrame",
                     @"UITableViewStylePlain",
                     @"delegate",
                     @"dataSource",
                     @"UITableViewDelegate",
                     @"UITableViewDataSource",
                     @"FadeInCellRowByRowViewController",
                     @"listData",
                     ];
    self.listData = arr;
    self.animatedIndexPaths = [NSMutableSet set];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // @see https://stackoverflow.com/questions/33274787/fade-in-uitableviewcell-row-by-row-in-swift
    
    if (![self.animatedIndexPaths containsObject:indexPath]) {
        if (self.tableView.isDragging || self.tableView.isDecelerating) {
            cell.contentView.alpha = 0;
            CGFloat duration = 0.5;
            [UIView animateWithDuration:duration delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.contentView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [self.animatedIndexPaths addObject:indexPath];
            }];
        }
        else {
            cell.contentView.alpha = 0;
            CGFloat duration = 0.2;
            [UIView animateWithDuration:duration delay:(duration / 2.0) * indexPath.row options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.contentView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [self.animatedIndexPaths addObject:indexPath];
            }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FadeInCellRowByRowViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.row];
    
    return cell;
}

@end
