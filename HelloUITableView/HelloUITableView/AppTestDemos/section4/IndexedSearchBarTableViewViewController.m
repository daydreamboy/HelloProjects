//
//  IndexedSearchBarTableViewViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2021/4/18.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "IndexedSearchBarTableViewViewController.h"

@interface IndexedSearchBarTableViewViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<NSArray *> *sectionListData;
@property (nonatomic, strong) NSMutableArray<NSArray *> *filteredSearchResult;
@property (nonatomic, strong) UIView *statusBarView;
@end

@implementation IndexedSearchBarTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.definesPresentationContext = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    [array sortUsingSelector:@selector(compare:)];
    
    _sectionListData = [NSMutableArray array];
    
    NSString *previousPrefix = nil;
    NSMutableArray *currentSection;
    
    for (NSString *string in array) {
        NSString *prefix = [string substringToIndex:1];
        if ([previousPrefix isEqualToString:prefix]) {
            [currentSection addObject:string];
        }
        else {
            currentSection = [NSMutableArray array];
            [currentSection addObject:string];
            [_sectionListData addObject:currentSection];
            
            previousPrefix = prefix;
        }
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - startY) style:UITableViewStylePlain];
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
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.delegate = self;
        
        _searchController.searchBar.translucent = NO;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searchController.active ? [self.filteredSearchResult count] : [self.sectionListData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchController.active ?  [self.filteredSearchResult[section] count] :  [self.sectionListData[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *string = self.searchController.active ? [self.filteredSearchResult[section] firstObject] : [self.sectionListData[section] firstObject];
    
    return [string substringToIndex:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"SearchBarTableViewViewController_CellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }

    NSString *string = self.searchController.active ? self.filteredSearchResult[indexPath.section][indexPath.row] : self.sectionListData[indexPath.section][indexPath.row];
    cell.textLabel.text = string;
    
    return cell;
}

#pragma mark > Index Titles

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *sectionIndexTitles = [NSMutableArray array];
    
    if (self.searchController.active) {
        for (NSArray *section in self.filteredSearchResult) {
            NSString *prefix = [[section firstObject] substringToIndex:1];
            [sectionIndexTitles addObject:prefix];
        }
    }
    else {
        for (NSArray *section in self.sectionListData) {
            NSString *prefix = [[section firstObject] substringToIndex:1];
            [sectionIndexTitles addObject:prefix];
        }
    }
    
    return sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *string = self.searchController.active ? self.filteredSearchResult[indexPath.section][indexPath.row] : self.sectionListData[indexPath.section][indexPath.row];
    NSLog(@"did select %@", string);
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"contentOffset: %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    // ISSUE: @see https://stackoverflow.com/questions/32493886/tap-on-a-uitableview-index-a-z-when-a-uisearchcontrollers-searchbar-is-acti
    
    // SOLUTION (still has bugs): manually fix the content offset, and must set _searchController.hidesNavigationBarDuringPresentation = NO
    // Avoid to trigger scrollViewDidScroll again. @see https://stackoverflow.com/questions/9418311/setting-contentoffset-programmatically-triggers-scrollviewdidscroll
    if (self.searchController.active && !scrollView.isDragging && !scrollView.isDecelerating) {
        CGRect scrollBounds = scrollView.bounds;
        CGPoint offset = scrollBounds.origin;
        CGFloat searchBarHeight = CGRectGetHeight(self.searchController.searchBar.bounds);
        offset.y = offset.y - searchBarHeight;

        scrollBounds.origin = offset;
        scrollView.bounds = scrollBounds;
    }
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
        [self.filteredSearchResult addObjectsFromArray:self.sectionListData];
        [self.tableView reloadData];
    }
}

#pragma mark - Filter

- (NSArray <NSArray *> *)filterByKeyword:(NSString *)keyword {
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self CONTAINS[c] %@", keyword];
    NSMutableArray *filteredSectionsM = [NSMutableArray array];
    
    [self.sectionListData enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *section = [obj filteredArrayUsingPredicate:predicate];
        
        // Note: if have no matched items in section, no need to add this section to filteredSectionItemsM
        if (section.count) {
            [filteredSectionsM addObject:section];
        }
    }];
    
    return filteredSectionsM;
}

@end
