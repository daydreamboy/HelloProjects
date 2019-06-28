//
//  SelectMeViewController.m
//  HelloEditableTableView
//
//  Created by wesley chen on 15/8/4.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "SelectMeViewController.h"

@interface SelectMeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listArr;
@property (nonatomic, strong) UIBarButtonItem *itemDelete;
@end

@implementation SelectMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareData];
    [self prepareView];
}

- (void)prepareData {
    if (!_listArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        _listArr = array;
    }
}

- (void)prepareView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.editing = YES;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(itemDeleteClicked:)];
    deleteItem.enabled = _tableView.indexPathsForSelectedRows.count ? YES : NO;
    
    UIBarButtonItem *toggleItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(itemToggleClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[ deleteItem, toggleItem ];
    
    _itemDelete = deleteItem;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"SelectMeViewController_CellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        cell.imageView.image = [UIImage imageNamed:@"babelfish"];
    }
    
    cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
    
    cell.textLabel.text = _listArr[indexPath.row];
    // Counterpart for return NO in - tableView:canEditRowAtIndexPath: method
    cell.userInteractionEnabled = indexPath.row == 0 ? NO : YES;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // Can't edit at row 0
        return NO;
    }
    
    return YES;
}

#pragma mark > Move

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // After the move has completed, call this method
    NSUInteger fromRow = fromIndexPath.row;
    NSUInteger toRow = toIndexPath.row;
    
    id object = _listArr[fromRow];
    [_listArr removeObjectAtIndex:fromRow];
    [_listArr insertObject:object atIndex:toRow];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // No reorder control show at row 0
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select: %@", indexPath);
    _itemDelete.enabled = _tableView.indexPathsForSelectedRows.count ? YES : NO;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"deselect: %@", indexPath);
    _itemDelete.enabled = _tableView.indexPathsForSelectedRows.count ? YES : NO;
}

#pragma mark - Action

- (void)itemDeleteClicked:(id)sender {
    
    if (_tableView.indexPathsForSelectedRows.count) {
        for (NSIndexPath *indexPath in _tableView.indexPathsForSelectedRows) {
            [_listArr removeObjectAtIndex:indexPath.row];
        }
        [_tableView deleteRowsAtIndexPaths:_tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        _itemDelete.enabled = _tableView.indexPathsForSelectedRows.count ? YES : NO;
    }
}

- (void)itemToggleClicked:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        self.tableView.editing = !self.tableView.editing;
    }];
    // OR
    //[self.tableView setEditing:!self.tableView.editing animated:YES];
}

@end
