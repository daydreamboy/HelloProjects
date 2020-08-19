//
//  LoadMoreFromBottomViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2018/10/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "LoadMoreFromBottomViewController.h"
#import "WCTableViewTool.h"
#import "WCTableLoadMoreView.h"
#import "WCMacroTool.h"

@interface LoadMoreFromBottomViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) WCTableLoadMoreView *loadMoreView;
@end

@implementation LoadMoreFromBottomViewController

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
        CGRect frame = self.view.bounds;
        frame = CGRectMake(0, 64, screenSize.width, 300);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.layer.borderColor = [UIColor redColor].CGColor;
        tableView.layer.borderWidth = 1.0;
        //tableView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
        
        if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#pragma GCC diagnostic pop
        }
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(tableView.bounds), 30)];
        contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        
        WCTableLoadMoreView *view = [[WCTableLoadMoreView alloc] initWithTableView:tableView frame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 60) loadMoreType:WCTableLoadMoreTypeFromBottom];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        view.contentFrame = contentView.frame;
        
        weakify(self);
        view.didFirstShowActivityIndicatorBlock = ^(WCTableLoadMoreView * loadMoreView) {
            strongifyWithReturn(self, return;);
            
            NSLog(@"block called");
            loadMoreView.isRequesting = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.listData.count > 9) {
                    loadMoreView.isRequesting = NO;
                    [loadMoreView stopLoadingIndicatorWithTip:@"没有更多了" hide:YES animatedForHide:YES];
                }
                else {
                    for (NSInteger i = 0; i < 3; i++) {
                        [self.listData addObject:[NSString stringWithFormat:@"%d", (int)(self.listData.count)]];
                    }
                    [self.tableView reloadData];
                    loadMoreView.isRequesting = NO;
                }
            });
        };
        [view addSubview:contentView];
        
        _loadMoreView = view;
        tableView.tableFooterView = _loadMoreView;
        
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

#pragma mark - Action

- (void)resetItemClicked:(id)sender {
    [self.loadMoreView show];
}

@end
