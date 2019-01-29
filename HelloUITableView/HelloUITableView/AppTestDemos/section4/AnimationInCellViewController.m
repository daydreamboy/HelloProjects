//
//  AnimationInCellViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2019/1/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "AnimationInCellViewController.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface AnimationInCellViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation AnimationInCellViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i = 0; i < 30; i++) {
            [arrM addObject:[NSString stringWithFormat:@"%d", (int)i]];
        }
        
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        [groups addObject:arrM];
        
        _listData = groups;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numItemsInSection = [[self.listData objectAtIndex:section] count];
    return numItemsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    cell.textLabel.text = [[self.listData objectAtIndex:section] objectAtIndex:row];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([cell.contentView viewWithTag:100] == nil) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 100)];
            view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
            view.tag = 100;
            [cell.contentView addSubview:view];
            view.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^{
                view.alpha = 1;
            }];
        }
    });
    
    return cell;
}

@end
