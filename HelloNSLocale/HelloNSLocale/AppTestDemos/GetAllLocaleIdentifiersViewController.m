//
//  GetAllLocaleIdentifiersViewController.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/10.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetAllLocaleIdentifiersViewController.h"

@interface GetAllLocaleIdentifiersViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation GetAllLocaleIdentifiersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)setup {
    NSArray<NSString *> *identifiers = [NSLocale availableLocaleIdentifiers];
    NSMutableDictionary<NSString *, NSMutableArray *> *buckets = [NSMutableDictionary dictionaryWithCapacity:identifiers.count];
    
    for (NSString *identifier in identifiers) {
        NSString *prefixChar = [identifier substringToIndex:1];
        
        NSMutableArray *bucket = buckets[prefixChar];
        if (!bucket) {
            bucket = [NSMutableArray array];
        }
        
        [bucket addObject:identifier];
        buckets[prefixChar] = bucket;
    }
    
    NSArray *prefixChars = [buckets.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:prefixChars.count];
    
    for (NSString *prefixChar in prefixChars) {
        [arrM addObject:[buckets[prefixChar] sortedArrayUsingSelector:@selector(compare:)]];
    }
    
    self.listData = arrM;
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - 64) style:UITableViewStylePlain];
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
    static NSString *sCellIdentifier = @"FadeInCellRowByRowViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    cell.textLabel.text = self.listData[indexPath.section][indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *string = [self.listData[section] firstObject];
    
    return [string substringToIndex:1];
}

#pragma mark > Index Titles

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *sectionIndexTitles = [NSMutableArray array];
    
    for (NSArray *section in self.listData) {
        NSString *prefix = [[section firstObject] substringToIndex:1];
        [sectionIndexTitles addObject:prefix];
    }
    
    return sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

@end
