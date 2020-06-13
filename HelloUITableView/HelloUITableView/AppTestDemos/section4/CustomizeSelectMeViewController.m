//
//  CustomizeSelectMeViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CustomizeSelectMeViewController.h"
#import "WCCustomizeSystemCheckmarkCell.h"

#ifndef UNSPECIFIED
#define UNSPECIFIED 0
#endif

@interface CustomizeSelectMeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listArr;
@property (nonatomic, strong) UIBarButtonItem *itemDelete;
@end

@implementation CustomizeSelectMeViewController

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
        //_listArr = [[array subarrayWithRange:NSMakeRange(0, 2)] mutableCopy];
        _listArr = array;
    }
}

- (void)prepareView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.editing = NO;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    //_tableView.allowsMultipleSelection = YES;
    [_tableView registerClass:[WCCustomizeSystemCheckmarkCell class] forCellReuseIdentifier:NSStringFromClass([WCCustomizeSystemCheckmarkCell class])];
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
    static NSString *CellIdentifer;
    if (!CellIdentifer) {
        CellIdentifer = NSStringFromClass([WCCustomizeSystemCheckmarkCell class]);
    }
    
    WCCustomizeSystemCheckmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    cell.checkmarkButton.frame = CGRectMake(0, 0, 40, 40);
    cell.checkmarkButton.adjustsImageWhenHighlighted = NO;
    cell.checkmarkButton.backgroundColor = [UIColor yellowColor];
    [cell.checkmarkButton setImage:[UIImage imageNamed:@"button_normal"] forState:UIControlStateNormal];
    [cell.checkmarkButton setImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateSelected];
    [cell.checkmarkButton addTarget:self action:@selector(buttonCheckmarkClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkmarkButtonInsets = UIEdgeInsetsMake(2, 10, 2, UNSPECIFIED);
    
    cell.imageView.image = [UIImage imageNamed:@"babelfish"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _listArr[indexPath.row];
    if (indexPath.row % 2 == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    else {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    // Counterpart for return NO in - tableView:canEditRowAtIndexPath: method
    //cell.userInteractionEnabled = indexPath.row == 0 ? NO : YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(300, 10, 30, 30);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:button];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // Can't edit at row 0
        return NO;
    }
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
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

//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}

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
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (void)buttonCheckmarkClicked:(id)sender {
    NSLog(@"456");
}

- (void)buttonClicked:(id)sender {
    NSLog(@"123");
}

@end
