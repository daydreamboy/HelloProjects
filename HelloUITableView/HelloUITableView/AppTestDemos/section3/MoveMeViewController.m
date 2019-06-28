//
//  MoveMeViewController.m
//  HelloEditableTableView
//
//  Created by wesley chen on 15/8/3.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "MoveMeViewController.h"


@interface MoveMeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listArr;
@end

@implementation MoveMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    // Note: disable multiple select
    //_tableView.allowsMultipleSelectionDuringEditing = YES;
    _tableView.allowsSelectionDuringEditing = YES;
    _tableView.allowsSelection = YES;
//    _tableView.allowsMultipleSelection = YES;
    [self.view addSubview:_tableView];
    
    if (!_listArr) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Eeny", @"Meeny", @"Miney", @"Moe", @"Catch", @"A", @"Tiger", @"By", @"The", @"Toe", @"Eeny", @"Meeny", @"Miney", @"Moe", @"Catch", @"A", @"Tiger", @"By", @"The", @"Toe", nil];
        _listArr = array;
    }
    
    UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithTitle:@"Move" style:UIBarButtonItemStylePlain target:self action:@selector(toggleMove)];
    self.navigationItem.rightBarButtonItem = moveButton;
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Default is UITableViewCellEditingStyleDelete by no impletation
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // Counterpart for return UITableViewCellEditingStyleNone in - tableView:editingStyleForRowAtIndexPath: method
    // Return NO won't work when return UITableViewCellEditingStyleInsert or UITableViewCellEditingStyleDelete
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"MoveMeViewController_CellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        cell.showsReorderControl = YES;
        cell.imageView.image = [UIImage imageNamed:@"dog"];
        
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onebit"]];
        cell.accessoryView = iconView;
    }
    
    cell.textLabel.text = _listArr[indexPath.row];
    
    return cell;
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

#pragma mark - Action

- (void)toggleMove {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    [UIView setAnimationsEnabled:NO];
    if (self.tableView.editing) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    }
    else {
        [self.navigationItem.rightBarButtonItem setTitle:@"Move"];
    }
    [UIView setAnimationsEnabled:YES];
}


@end
