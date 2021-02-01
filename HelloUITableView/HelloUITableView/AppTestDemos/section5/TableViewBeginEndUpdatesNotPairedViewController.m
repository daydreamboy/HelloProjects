//
//  TableViewBeginEndUpdatesNotPairedViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/11/10.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TableViewBeginEndUpdatesNotPairedViewController.h"

@interface TableViewBeginEndUpdatesNotPairedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation TableViewBeginEndUpdatesNotPairedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[
        @"viewDidLoad",
        @"UITableView",
        @"UITableView2",
//        @"screenSize",
//        @"UITableViewCell",
//        @"UIScreen",
//        @"backgroundColor",
//        @"view",
//        @"self",
//        @"whiteColor",
//        @"UIColor",
//        @"initWithFrame",
//        @"UITableViewStylePlain",
//        @"delegate",
//        @"dataSource",
//        @"UITableViewDelegate",
//        @"UITableViewDataSource",
//        @"FadeInCellRowByRowViewController",
//        @"listData",
//        @"dataSource",
//        @"UITableViewDelegate",
//        @"UITableViewDataSource",
//        @"FadeInCellRowByRowViewController",
//        @"listData",
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
    static NSString *CellIdentifer = @"InsertMeViewController_CellIdentifer";
    
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

#pragma mark - Action

- (void)updateTableView:(id)sender {
    
    [self.tableView beginUpdates];
    
    [_listArr addObject:@"3423"];
    
    [self.tableView endUpdates];
    
    
    
    //[self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
//    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
//
//    for (NSInteger i = 0; i < array.count; ++i) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//
//        [_listArr insertObject:array[i] atIndex:i];
//
//        [self.tableView beginUpdates];
//
//        // !!!: Here cause to beginUpdates/endUpdates not paired
//        if (i == 10) {
//            continue;
//        }
//
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//        [self.tableView endUpdates];
//    }
}

@end
