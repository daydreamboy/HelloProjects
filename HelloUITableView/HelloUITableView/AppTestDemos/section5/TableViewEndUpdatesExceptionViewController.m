//
//  TableViewEndUpdatesExceptionViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2021/2/1.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "TableViewEndUpdatesExceptionViewController.h"

@interface TableViewEndUpdatesExceptionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation TableViewEndUpdatesExceptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[
        @"1",
        @"2",
        @"3",
    ];
    
    _listArr = [arr mutableCopy];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"update" style:UIBarButtonItemStylePlain target:self action:@selector(updateTableView:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"TableViewEndUpdatesExceptionViewController_CellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }

    cell.textLabel.text = [_listArr[indexPath.row] description];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (void)updateTableView:(id)sender {
    [self.tableView beginUpdates];
    
    [_listArr addObject:@"3423"];
    
    [self.tableView endUpdates];
    
    // !!!: same as beginUpdates/endUpdates, also crash
    /*
    [self.tableView performBatchUpdates:^{
        [_listArr addObject:@"3423"];
    } completion:^(BOOL finished) {
            
    }];
     */
}

@end
