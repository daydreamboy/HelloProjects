//
//  IndexedTableViewViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/10.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "IndexedTableViewViewController.h"

@interface IndexedTableViewViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray<NSArray *> *sectionListData;
@end

@implementation IndexedTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (!_listData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        _listData = array;
        
        [_listData sortUsingSelector:@selector(compare:)];
        
        _sectionListData = [NSMutableArray array];
        
        NSString *previousPrefix = nil;
        NSMutableArray *currentSection;
        
        for (NSString *string in _listData) {
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
    }
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
