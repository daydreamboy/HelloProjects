//
//  LoadMoreFromTopViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "LoadMoreFromTopViewController.h"
#import "WCTableViewTool.h"
#import "WCTableLoadMoreView.h"
#import "WCMacroTool.h"
#import "WCScrollViewTool.h"
#import "WCTableViewTool.h"

@interface LoadMoreFromTopViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) WCTableLoadMoreView *loadMoreView;
@property (nonatomic, strong) UISwitch *switchHide;
@property (nonatomic, strong) UISwitch *switchAnimatedForHide;
@end

@implementation LoadMoreFromTopViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        _listData = [NSMutableArray array];
        
        [_listData insertObject:@"0" atIndex:0];
        [_listData insertObject:@"1" atIndex:0];
        [_listData insertObject:@"2" atIndex:0];
        [_listData insertObject:@"3" atIndex:0];
        // TEST: Comment the following lines to test
        [_listData insertObject:@"4" atIndex:0];
        [_listData insertObject:@"5" atIndex:0];
        [_listData insertObject:@"6" atIndex:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
//    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
    [WCScrollViewTool scrollToBottomWithScrollView:self.tableView animated:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetItemClicked:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"contentInset: %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 300) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.layer.borderColor = [UIColor redColor].CGColor;
        tableView.layer.borderWidth = 1.0;
        
        // viewDidLayoutSubviews and viewDidAppear get not the same contentSize of UITableView
        // @see https://developer.apple.com/forums/thread/81895
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        
        if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
#if IOS11_SDK_OR_LATER_AVAILABLE
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#endif
#pragma GCC diagnostic pop
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 30)];
        contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        
        WCTableLoadMoreView *view = [[WCTableLoadMoreView alloc] initWithTableView:tableView viewController:self frame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 60) loadMoreType:WCTableLoadMoreTypeFromTop];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        view.contentFrame = contentView.frame;
        
        weakify(self);
        view.willShowLoadingIndicatorBlock = ^(WCTableLoadMoreView * loadMoreView) {
            strongifyWithReturn(self, return;);
            NSLog(@"block called");
            loadMoreView.isRequesting = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.listData.count > 9/*18*/) {
                    loadMoreView.isRequesting = NO;
                    [loadMoreView stopLoadingIndicatorWithTip:@"没有更多了" hide:YES animatedForHide:YES];
                }
                else {
                    for (NSInteger i = 0; i < 3; i++) {
                        [self.listData insertObject:[NSString stringWithFormat:@"%d", (int)(self.listData.count)] atIndex:0];
                    }
                    
                    [WCTableViewTool performOperationKeepStaticWithTableView:self.tableView block:^{
                        [self.tableView reloadData];
                    }];
                    
                    loadMoreView.isRequesting = NO;
                }
            });
        };
        [view addSubview:contentView];
        
        _loadMoreView = view;
        tableView.tableHeaderView = _loadMoreView;
        
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

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
}

#pragma mark - Action

- (void)resetItemClicked:(id)sender {
    [self.loadMoreView show];
}

@end
