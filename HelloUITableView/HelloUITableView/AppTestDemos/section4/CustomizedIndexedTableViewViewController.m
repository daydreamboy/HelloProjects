//
//  CustomizedIndexedTableViewViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2021/4/19.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "CustomizedIndexedTableViewViewController.h"
#import "WCTableViewIndexView.h"

@interface CustomizedIndexedTableViewViewController () <UITableViewDelegate, UITableViewDataSource, TableIndexViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *sectionListData;
@property (nonatomic, strong) WCTableViewIndexView *indexView;
@end

@implementation CustomizedIndexedTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
        
    NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    [array sortUsingSelector:@selector(compare:)];
    
    _sectionListData = [NSMutableArray array];
    
    NSString *previousPrefix = nil;
    NSMutableArray *currentSection;
    
    for (NSString *string in array) {
        NSString *prefix = [string substringToIndex:1];
        if ([previousPrefix isEqualToString:prefix]) {
            [currentSection addObject:string];
        }
        else {
            currentSection = [NSMutableArray array];
            [currentSection addObject:string];
            [_sectionListData addObject:currentSection];
            
            previousPrefix = prefix;
        }
    }
    
    _indexView = [[WCTableViewIndexView alloc] initWithTableView:self.tableView];
    _indexView.backgroundColor = [UIColor yellowColor];
    _indexView.delegate = self;
    [self.view addSubview:_indexView];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (void)tableViewIndexView:(WCTableViewIndexView *)tableIndexView didSwipeToSection:(NSUInteger)section {
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionListData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionListData[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *string = [self.sectionListData[section] firstObject];
    
    return [string substringToIndex:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"SearchBarTableViewViewController_CellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }

    NSString *string = self.sectionListData[indexPath.section][indexPath.row];
    cell.textLabel.text = string;
    
    return cell;
}

#pragma mark > Index Titles

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *sectionIndexTitles = [NSMutableArray array];
    
    for (NSArray *section in self.sectionListData) {
        NSString *prefix = [[section firstObject] substringToIndex:1];
        [sectionIndexTitles addObject:prefix];
    }
    
    return sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end