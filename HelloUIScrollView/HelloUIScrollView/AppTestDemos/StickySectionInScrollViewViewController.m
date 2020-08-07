//
//  StickySectionInScrollViewViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "StickySectionInScrollViewViewController.h"
#import "WCStickySectionManager.h"

@interface StickySectionInScrollViewViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) WCStickySectionManager *stickySectionManager;
@end

@implementation StickySectionInScrollViewViewController

static NSString *sCellIdentifier = @"UITableViewCell_sCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _stickySectionManager = [[WCStickySectionManager alloc] initWithScrollView:self.tableView];
    [_stickySectionManager addStickySection:({
        WCStickySection *view = [[WCStickySection alloc] initWithFixed:0 height:100];
        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
//        view.sticky = NO;
        view;
    }) atInitialY:50];
    [_stickySectionManager addStickySection:({
        WCStickySection *view = [[WCStickySection alloc] initWithFixed:0 height:100];
        view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
//        view.sticky = NO; // MARK: set sticky or not
        view;
    }) atInitialY:200];
    [_stickySectionManager addStickySection:({
        WCStickySection *view = [[WCStickySection alloc] initWithFixed:0 height:100];
        view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//        view.sticky = NO; // MARK: set sticky or not
        view;
    }) atInitialY:350];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.tableView.frame = CGRectMake(0, startY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - startY);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.editing = YES;
        tableView.allowsSelection = NO;
        tableView.allowsMultipleSelection = NO;
        tableView.allowsSelectionDuringEditing = NO;
        tableView.allowsMultipleSelectionDuringEditing = YES;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sCellIdentifier];
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSMutableArray *)listArr {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    cell.textLabel.text = self.listArr[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"select: (%ld, %ld)", indexPath.section, indexPath.row);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"unselect: (%ld,%ld)", indexPath.section, indexPath.row);
}

#pragma mark - Action

- (void)itemToggleClicked:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

@end
