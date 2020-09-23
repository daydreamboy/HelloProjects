//
//  CellContentIssueAboveiOS14ViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CellContentIssueAboveiOS14ViewController.h"
#import "WCMacroTool.h"

@interface CellContentIssueAboveiOS14ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@property (nonatomic, assign) BOOL disableContentViewUserInteraction;
@end

@implementation CellContentIssueAboveiOS14ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithTitle:@"Fix cell.subview" style:UIBarButtonItemStylePlain target:self action:@selector(fixItemClicked:)];
    self.navigationItem.rightBarButtonItem = fixItem;
}

- (void)setup {
    NSArray *arr = @[
                     @[
                         @"viewDidLoad",
                         @"UITableView",
                         @"UITableView2",
                         @"screenSize",
                         @"UITableViewCell",
                         ],
                     @[
                         @"UIScreen",
                         @"backgroundColor",
                         @"view",
                         @"self",
                         @"whiteColor",
                         @"UIColor",
                         @"initWithFrame",
                         ],
                     @[
                         @"UITableViewStylePlain",
                         @"delegate",
                         @"dataSource",
                         @"UITableViewDelegate",
                         @"UITableViewDataSource",
                         @"FadeInCellRowByRowViewController",
                         @"listData",
                         ],
                     ];
    self.listData = arr;
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
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"CellContentIssueAboveiOS14ViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor greenColor];
        button.frame = CGRectMake(10, 10, 200, 10);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:button];
    }
    
    cell.textLabel.text = self.listData[indexPath.section][indexPath.row];
    
    if (self.disableContentViewUserInteraction) {
        cell.contentView.userInteractionEnabled = NO;
    }
    
    return cell;
}

#pragma mark - Action

- (void)buttonClicked:(id)sender {
    SHOW_ALERT(@"Button clicked", @"You hit the subview of the Cell", @"OK", nil);
}

- (void)fixItemClicked:(id)sender {
    self.disableContentViewUserInteraction = YES;
    [self.tableView reloadData];
}

@end
