//
//  UseDynamicFontInTableViewViewController.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseDynamicFontInTableViewViewController.h"
#import "WCTheme.h"
#import "AppFontProvider.h"

@interface UseDynamicFontInTableViewViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *listData;
@property (nonatomic, strong) NSArray *fontProviderNames;
@end

@implementation UseDynamicFontInTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    NSArray *providerNames = [[WCDynamicFontManager sharedManager] fontProviderNames];
    NSInteger index = 0;
    
    NSString *currentFontProviderName = [[WCDynamicFontManager sharedManager] currentFontProviderName];
    if (currentFontProviderName.length) {
        self.title = currentFontProviderName;
        NSInteger indexToFound = [providerNames indexOfObject:currentFontProviderName];
        if (indexToFound != NSNotFound) {
            index = indexToFound;
        }
    }
    
    UIStepper *stepper = [UIStepper new];
    [stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    stepper.value = index;
    stepper.minimumValue = 0;
    stepper.maximumValue = providerNames.count - 1;
    _fontProviderNames = providerNames;
    
    UIBarButtonItem *adjustItem = [[UIBarButtonItem alloc] initWithCustomView:stepper];
    self.navigationItem.rightBarButtonItem = adjustItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWCDynamicFontDidChangeNotification:) name:WCDynamicFontDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWCDynamicFontWillChangeNotification:) name:WCDynamicFontWillChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WCDynamicFontDidChangeNotification object:nil];
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

#pragma mark - NSNotification

- (void)handleWCDynamicFontDidChangeNotification:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (void)handleWCDynamicFontWillChangeNotification:(NSNotification *)notification {
    NSString *providerName = notification.userInfo[WCDynamicFontChangeNotificationUserInfoProviderName];
    
    [[WCDynamicValueManager sharedManager] setCurrentValueProviderName:providerName];
}

#pragma mark - Action

- (void)stepperValueChanged:(UIStepper *)sender {
    int index = (int)sender.value;
    NSString *providerName = self.fontProviderNames[index];
    self.title = providerName;
    [[WCDynamicFontManager sharedManager] setCurrentFontProviderName:providerName];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - 64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        // Note: disable cell auto resize
        tableView.estimatedRowHeight = 0;
        
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
    cell.textLabel.font = WCThemeGetDynamicFont(cell.textLabel, AppFontKey_cell_title, [UIFont systemFontOfSize:17], nil);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WCDynamicValue *dynamicValue = WCThemeGetDynamicValue(nil, AppValueKey_cell_height, WCDynamicValueDouble(44.0), nil);
    return dynamicValue.doubleValue;
}

@end
