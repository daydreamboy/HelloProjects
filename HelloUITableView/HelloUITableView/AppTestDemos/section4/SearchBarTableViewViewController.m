//
//  SearchBarTableViewViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "SearchBarTableViewViewController.h"

@interface SearchBarTableViewViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) NSMutableArray *filteredSearchResult;
@end

@implementation SearchBarTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (!_listData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        _listData = array;
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.searchController.searchBar;
    }
    
    return _tableView;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        // Note: disable dim to make filtered result list can be scrolling
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.delegate = self;
        
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

- (NSMutableArray *)filteredSearchResult {
    if (!_filteredSearchResult) {
        _filteredSearchResult = [NSMutableArray array];
    }
    return _filteredSearchResult;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchController.active ? self.filteredSearchResult.count : self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"SearchBarTableViewViewController_CellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }

    if (self.searchController.active) {
        cell.textLabel.text = [self.filteredSearchResult[indexPath.row] description];
    }
    else {
        cell.textLabel.text = [self.listData[indexPath.row] description];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
    if (!self.statusBarView) {
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *statusBarView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

        CGSize size = [UIApplication sharedApplication].statusBarFrame.size;
        statusBarView.frame = CGRectMake(0, 0, size.width, size.height);
        _statusBarView = statusBarView;
    }

    // @see https://stackoverflow.com/questions/32234778/status-bar-changes-color-when-searching/34229176#34229176
    [self.searchController.view addSubview:self.statusBarView];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (self.searchController.searchBar.text.length) {
        [self.filteredSearchResult removeAllObjects];
        [self.filteredSearchResult addObjectsFromArray:[self filterByKeyword:self.searchController.searchBar.text]];
        [self.tableView reloadData];
    }
    else {
        [self.filteredSearchResult removeAllObjects];
        [self.filteredSearchResult addObjectsFromArray:self.listData];
        [self.tableView reloadData];
    }
}

#pragma mark - Filter

- (NSArray *)filterByKeyword:(NSString *)keyword {
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[c] %@", keyword];
    NSArray *filteredItems = [self.listData filteredArrayUsingPredicate:predicate];
    
    return filteredItems;
}

@end
