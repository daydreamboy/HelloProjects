//
//  CheckJSContextFeatureViewController.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2020/4/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CheckJSContextFeatureViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WCJSCTool.h"

@interface CheckJSContextFeatureViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *listData;
@property (nonatomic, strong) NSString *dirPath;
@property (nonatomic, strong) NSArray<NSString *> *fileNames;
@property (nonatomic, strong) JSContext *context;
@end

@implementation CheckJSContextFeatureViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _listData = @[
            @{
                @"feature": @"window",
                @"avaibility": @([WCJSCTool checkIfAvaiableInJSCWithFeatureType:WCJSCToolFeatureTypeWindow]),
            },
            @{
                @"feature": @"self",
                @"avaibility": @([WCJSCTool checkIfAvaiableInJSCWithFeatureType:WCJSCToolFeatureTypeSelf]),
            },
            @{
                @"feature": @"global",
                @"avaibility": @([WCJSCTool checkIfAvaiableInJSCWithFeatureType:WCJSCToolFeatureTypeGlobal]),
            },
            @{
                @"feature": @"globalThis",
                @"avaibility": @([WCJSCTool checkIfAvaiableInJSCWithFeatureType:WCJSCToolFeatureTypeGlobalThis]),
            },
            @{
                @"feature": @"Promise",
                @"avaibility": @([WCJSCTool checkIfAvaiableInJSCWithFeatureType:WCJSCToolFeatureTypePromise]),
            },
            @{
                @"feature": @"Map",
                @"avaibility": @([WCJSCTool checkIfAvaiableInJSCWithFeatureType:WCJSCToolFeatureTypeMap]),
            },
            @{
                @"feature": @"Arrow Function",
                @"avaibility": @([WCJSCTool checkIfAvaiableInJSCWithFeatureType:WCJSCToolFeatureTypeArrowFunction]),
            },
            @{
                @"feature": @"let variable",
                @"avaibility": @([WCJSCTool checkIfAvaiableInJSCWithFeatureType:WCJSCToolFeatureTypeLetVariable]),
            },
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Feature列表";
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma GCC diagnostic pop
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"CheckJSContextFeatureViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:sCellIdentifier];
    }
    
    NSDictionary *item = self.listData[indexPath.row];
    
    cell.textLabel.text = item[@"feature"];
    cell.detailTextLabel.text = [item[@"avaibility"] boolValue] ? @"available" : @"unavailable";
    cell.detailTextLabel.textColor = [item[@"avaibility"] boolValue] ? [UIColor greenColor] : [UIColor redColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
