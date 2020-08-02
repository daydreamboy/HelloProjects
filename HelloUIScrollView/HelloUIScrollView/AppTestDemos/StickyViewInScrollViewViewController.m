//
//  StickyViewInScrollViewViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/7/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "StickyViewInScrollViewViewController.h"

@interface StickyViewInScrollViewViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UIView *stickyView1;
@property (nonatomic, assign) CGFloat headerViewInitialY;
@property (nonatomic, assign) CGFloat headerViewFixedY;
@end

@implementation StickyViewInScrollViewViewController

static NSString *sCellIdentifier = @"UITableViewCell_sCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.headerViewInitialY = 100;
    
    self.headerViewFixedY = 30;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView addSubview:self.stickyView1];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.tableView.frame = CGRectMake(0, startY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - startY);
        
    CGRect headerFrame = self.stickyView1.frame;
    headerFrame.origin.y = self.headerViewInitialY;
    self.stickyView1.frame = headerFrame;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect headerFrame = self.stickyView1.frame;
    
    // @see https://stackoverflow.com/questions/11272847/make-uiview-in-uiscrollview-stick-to-the-top-when-scrolled-up
    if (scrollView.contentOffset.y + self.headerViewFixedY > self.headerViewInitialY) {
        headerFrame.origin.y = self.headerViewFixedY + scrollView.contentOffset.y;
    }
    else {
        headerFrame.origin.y = self.headerViewInitialY;
    }
    
    self.stickyView1.frame = headerFrame;
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

- (UIView *)stickyView1 {
    if (!_stickyView1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerViewInitialY, CGRectGetWidth(self.view.bounds), 100)];
        view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        
        _stickyView1 = view;
    }
    
    return _stickyView1;
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
