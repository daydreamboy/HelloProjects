//
//  CallReloadDataInsideCellForRowAtIndexPathViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2019/5/27.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CallReloadDataInsideCellForRowAtIndexPathViewController.h"

@interface CallReloadDataInsideCellForRowAtIndexPathViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *listData;
@end

@implementation CallReloadDataInsideCellForRowAtIndexPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *insertItem = [[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStylePlain target:self action:@selector(insertItemClicked:)];
    self.navigationItem.rightBarButtonItem = insertItem;
}

- (void)setup {
    NSArray *arr = @[
                     @"viewDidLoad",
                     @"UITableView",
                     @"UITableView",
                     @"screenSize",
                     @"UITableViewCell",
                     @"viewDidLoad2",
                     @"UITableView2",
                     @"UITableView2",
                     @"screenSize2",
                     @"UITableViewCell2"
                     ];
    self.listData = [arr mutableCopy];
}

- (void)viewDidAppear:(BOOL)animated {
    // Note: iOS 10-, contentInset is {64, 0, 0, 0}
    //       iOS 11+, contentInset is {0, 0, 0, 0}
    NSLog(@"plain tableView's contentInset: %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FadeInCellRowByRowViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark -

- (void)insertItemClicked:(id)sender {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [self.tableView beginUpdates];
    
    for (NSInteger i = 0; i < 5; i++) {
        [self.listData insertObject:[NSString stringWithFormat:@"Insert %d", (int)i] atIndex:0];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    //[self.tableView reloadData];
    [self.tableView endUpdates];
    [CATransaction commit];
    
    NSLog(@"endUpdates");
}

@end
