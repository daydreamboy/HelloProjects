//
//  LocaleDetailInfoViewController.m
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/20.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "LocaleDetailInfoViewController.h"

@interface LocaleDetailInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@end

@implementation LocaleDetailInfoViewController

- (instancetype)initWithLocale:(NSLocale *)locale {
    self = [super init];
    if (self) {
        _locale = locale;
        
        _listData = @[
        @[
            [NSString stringWithFormat:@"localeIdentifier: %@", _locale.localeIdentifier],
            [NSString stringWithFormat:@"countryCode: %@", _locale.countryCode],
        ],
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
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

@end
