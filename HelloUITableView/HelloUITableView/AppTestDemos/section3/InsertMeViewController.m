//
//  InsertMeViewController.m
//  HelloEditableTableView
//
//  Created by wesley chen on 15/8/4.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "InsertMeViewController.h"

@interface InsertMeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listArr;
@end

@implementation InsertMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if (!_listArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        _listArr = array;
    }
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEdit:)];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSDate *now = [NSDate date];
        [_listArr insertObject:now atIndex:indexPath.row];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_listArr removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // Can't delete at row 0
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Default is UITableViewCellEditingStyleDelete by no impletation
    
    id object = _listArr[indexPath.row];
    if ([object isKindOfClass:[NSDate class]]) {
        return UITableViewCellEditingStyleDelete;
    }
    else if ([object isKindOfClass:[NSString class]]) {
        return UITableViewCellEditingStyleInsert;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (void)toggleEdit:(id)sender {
    [_tableView setEditing:!_tableView.editing animated:YES];
    _tableView.allowsSelectionDuringEditing = YES;
    
    if (_tableView.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"Add"];
}

@end
