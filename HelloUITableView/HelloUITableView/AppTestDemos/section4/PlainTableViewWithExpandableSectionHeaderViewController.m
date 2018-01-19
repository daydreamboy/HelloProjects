//
//  PlainTableViewWithExpandableSectionHeaderViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 19/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "PlainTableViewWithExpandableSectionHeaderViewController.h"

#import "WCExpandableHeaderView.h"

@interface PlainTableViewWithExpandableSectionHeaderViewController () <UITableViewDelegate, UITableViewDataSource, WCExpandableHeaderViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *listData;
@end

@implementation PlainTableViewWithExpandableSectionHeaderViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        [groups addObject:[NSArray arrayWithObjects:@"G1-R1", @"G1-R2", @"G1-R3", @"G1-R4", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G2-R1", @"G2-R2", @"G2-R3", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G3-R1", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G4-R1", @"G4-R2", @"G4-R3", @"G4-R4", @"G4-R5", @"G4-R6", nil]];
        [groups addObject:[NSArray arrayWithObjects:@"G5-R1", @"G5-R2", @"G5-R3", @"G5-R4", nil]];
        
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
    _tableView.expandableHeaderView_delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numItemsInSection = [[self.listData objectAtIndex:section] count];
    
    // Check the section is opening or closed
    WCExpandableHeaderView *headerView = [self.tableView expandableHeaderViewAtSectionIndex:section];
    return headerView.closed ? 0 : numItemsInSection;
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
    
    return cell;
}

#define HEADER_HEIGHT 30

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    WCExpandableHeaderView *headerView = [self.tableView expandableHeaderViewAtSectionIndex:section];
    if (!headerView) {
        //headerView = [[WCExpandableHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, HEADER_HEIGHT)];
        headerView = [[WCExpandableHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, HEADER_HEIGHT) title:[NSString stringWithFormat:@"section %ld", (long)section]];
        //        headerView.backgroundColor = [UIColor greenColor];
        [self.tableView recordExpandableHeaderView:headerView atSectionIndex:section];
    }
    
    return headerView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

#pragma mark - WCExpandableHeaderViewDelegate

- (NSArray *)tableViewData:(UITableView *)tableView {
    return self.listData;
}

- (void)sectionDidExpandAtIndex:(NSInteger)sectionIndex expandableHeaderView:(WCExpandableHeaderView *)expandableHeaderView {
    NSLog(@"section %ld expanded", (long)sectionIndex);
}

- (void)sectionDidCollapseAtIndex:(NSInteger)sectionIndex expandableHeaderView:(WCExpandableHeaderView *)expandableHeaderView {
    NSLog(@"section %ld collapsed", (long)sectionIndex);
}

@end
