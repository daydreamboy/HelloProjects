//
//  SearchBarTableViewViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "SearchBarTableViewViewController.h"

@interface SearchBarTableViewViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UIView *statusBarView;
@end

@implementation SearchBarTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (!_listArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        _listArr = array;
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
        //_searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.delegate = self;
        
//        if (@available(iOS 13.0, *)) {
//#if __IPHONE_13_0
//            _searchController.searchBar.searchTextField.backgroundColor = [UIColor redColor];
//#endif
//        }
//        else {
            _searchController.searchBar.backgroundColor = [UIColor greenColor];
//        }
        
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"SearchBarTableViewViewController_CellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        cell.imageView.image = [UIImage imageNamed:@"babelfish"];
    }

    cell.textLabel.text = [_listArr[indexPath.row] description];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
