//
//  StickyHeaderSectionInScrollViewViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/7/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "StickyHeaderSectionInScrollViewViewController.h"
#import "WCStickyHeaderSectionManager.h"
#import "WCMacroTool.h"

@interface StickyHeaderSectionInScrollViewViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) WCStickyHeaderSectionManager *stickyHeaderSectionManager;
@property (nonatomic, strong) UIView *heightChangedView;
@end

@implementation StickyHeaderSectionInScrollViewViewController

static NSString *sCellIdentifier = @"UITableViewCell_sCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _stickyHeaderSectionManager = [[WCStickyHeaderSectionManager alloc] initWithScrollView:self.tableView];    
    [_stickyHeaderSectionManager addStickyHeaderSection:({
        WCStickySection *view = [[WCStickySection alloc] initWithFixedY:10 height:100];
        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
//        view.sticky = NO;
        self.heightChangedView = view;
        view;
    }) priority:2];
    [_stickyHeaderSectionManager addStickyHeaderSection:({
        WCStickySection *view = [[WCStickySection alloc] initWithFixedY:60 height:100];
        view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        view.sticky = NO; // MARK: set sticky or not
        view.autoFixed = YES;
        view;
    }) priority:1];
    [_stickyHeaderSectionManager addStickyHeaderSection:({
        WCStickySection *view = [[WCStickySection alloc] initWithFixedY:0 height:100];
        view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//        view.sticky = NO; // MARK: set sticky or not
        view.autoFixed = YES;
        view;
    }) priority:0];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Change H" style:UIBarButtonItemStylePlain target:self action:@selector(itemChangeClicked:)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.tableView.frame = CGRectMake(0, startY, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - startY);
    
    [self.stickyHeaderSectionManager viewDidLayoutSubviews];
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

- (void)itemChangeClicked:(id)sender {
    WCStickySection *section = [self.stickyHeaderSectionManager.sortedSections firstObject];
    if (section.height == 100) {
        self.heightChangedView.frame = FrameSetSize(self.heightChangedView.frame, NAN, 200);
        [self.stickyHeaderSectionManager changeStickyHeaderSection:section toHeight:200];
    }
    else {
        self.heightChangedView.frame = FrameSetSize(self.heightChangedView.frame, NAN, 100);
        [self.stickyHeaderSectionManager changeStickyHeaderSection:section toHeight:100];
    }
}

@end
