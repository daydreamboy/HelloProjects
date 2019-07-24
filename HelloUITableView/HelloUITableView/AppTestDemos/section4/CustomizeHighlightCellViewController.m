//
//  CustomizeHighlightCellViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2019/7/24.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CustomizeHighlightCellViewController.h"

@interface CustomizeHighlightCellViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listArr;
@end

@implementation CustomizeHighlightCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *toggleItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(itemToggleClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[ toggleItem ];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.editing = NO;
        tableView.allowsSelection = NO;
        tableView.allowsMultipleSelection = YES;
        tableView.allowsSelectionDuringEditing = NO;
        tableView.allowsMultipleSelectionDuringEditing = YES;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSArray *)listArr {
    if (!_listArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        
        _listArr = array;
    }
    return _listArr;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"HighlightCellViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    selectedBackgroundView.backgroundColor = [UIColor greenColor];
    cell.selectedBackgroundView = selectedBackgroundView;
    cell.textLabel.text = self.listArr[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select: (%ld, %ld)", indexPath.section, indexPath.row);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"unselect: (%ld,%ld)", indexPath.section, indexPath.row);
}

#pragma mark - Action

- (void)itemToggleClicked:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

@end
