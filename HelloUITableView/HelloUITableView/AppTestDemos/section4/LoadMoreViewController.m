//
//  LoadMoreViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2018/10/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "LoadMoreViewController.h"
#import "WCTableViewTool.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface LoadMoreViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) WCLoadMoreTableFooterView *loadMoreView;
@end

@implementation LoadMoreViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _listData = [NSMutableArray array];
        
        [_listData addObject:@"0"];
        [_listData addObject:@"1"];
        [_listData addObject:@"2"];
        [_listData addObject:@"3"];
        // TEST: Comment the following lines to test
        [_listData addObject:@"4"];
        [_listData addObject:@"5"];
        [_listData addObject:@"6"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"contentInset: %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
//    NSLog(@"adjustedContentInset: %@", NSStringFromUIEdgeInsets(self.tableView.adjustedContentInset));
    [self.loadMoreView startActivityIndicatorIfNeeded];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect frame = self.view.bounds;
        frame = CGRectMake(0, 64, screenSize.width, 230);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#pragma GCC diagnostic pop
        }
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30)];
        footerView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        
        __weak typeof(self) weak_self = self;
        _loadMoreView = [[WCLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(tableView.bounds), 20) activityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadMoreView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
        _loadMoreView.didFirstShowActivityIndicatorBlock = ^(WCLoadMoreTableFooterView * _Nonnull loadMoreView) {
            NSLog(@"block called");
            loadMoreView.isRequesting = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weak_self.listData.count > 25) {
                    loadMoreView.isRequesting = NO;
                    [loadMoreView dismissActivityIndicatorWithTip:@"没有更多了"];
                }
                else {
                    for (NSInteger i = 0; i < 3; i++) {
                        [weak_self.listData addObject:[NSString stringWithFormat:@"%d", (int)(weak_self.listData.count)]];
                    }
                    [weak_self.tableView reloadData];
                    loadMoreView.isRequesting = NO;
                }
            });
        };
        [footerView addSubview:_loadMoreView];
        
        tableView.tableFooterView = footerView;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"LoadMoreViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    //NSLog(@"contentOffset: %@", NSStringFromCGPoint(contentOffset));
    
    CGRect visibleRect = scrollView.bounds;
    CGSize contentSize = scrollView.contentSize;
    CGRect tableFooterViewRect = _tableView.tableFooterView.frame;
    //NSLog(@"tableFooterViewRect: %@", NSStringFromCGRect(tableFooterViewRect));
    
//    [self check];
    [self.loadMoreView startActivityIndicatorIfNeeded];
}

@end
