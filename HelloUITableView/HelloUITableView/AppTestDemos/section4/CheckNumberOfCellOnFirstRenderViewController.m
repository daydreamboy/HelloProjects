//
//  CheckNumberOfCellOnFirstRenderViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/3/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CheckNumberOfCellOnFirstRenderViewController.h"

#define NSStringFromIndexPath(indexPath) ([NSString stringWithFormat:@"row: %@, section: %@", @(indexPath.row), @(indexPath.section)])

@interface CheckNumberOfCellOnFirstRenderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSMutableArray *> *listData;
@end

@implementation CheckNumberOfCellOnFirstRenderViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        [groups addObject:[NSArray arrayWithObjects:@"R0", @"R1", @"R2", @"R3", @"R4", @"R5", @"R6", @"R7", @"R8", @"R9", @"R10", @"R11", @"R12", @"R13", @"R14", @"R15", @"R16", @"R17", @"R18", @"R19", @"R20", @"R21", @"R22", @"R23", @"R24", @"R25", @"R26", nil]];
        
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
    return 300;
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
    
    NSLog(@"cellForRow: %@", NSStringFromIndexPath(indexPath));
    
    return cell;
}

@end
