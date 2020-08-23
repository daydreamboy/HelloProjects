//
//  FontInfoViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/8/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "FontInfoViewController.h"
#import "WCMacroTool.h"

@interface FontInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *listData;
@property (nonatomic, strong) WCFontInfo *fontInfo;
@end

@implementation FontInfoViewController

- (instancetype)initWithFontFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _fontInfo = [WCFontTool fontInfoWithFilePath:filePath];
        
        _listData = @[
            @{ @"fileName": _fontInfo.fileName },
            @{ @"filePath": _fontInfo.filePath },
            @{ @"numberOfGlyphs": STR_OF_INTEGER(_fontInfo.glyphInfos.count) },
            @{ @"postScriptName": _fontInfo.postScriptName },
            @{ @"familyName": _fontInfo.familyName },
            @{ @"fullName": _fontInfo.fullName },
            @{ @"displayName": _fontInfo.displayName },
            @{ @"ascent": STR_OF_FLOAT(_fontInfo.ascent) },
            @{ @"descent": STR_OF_FLOAT(_fontInfo.descent) },
            @{ @"leading": STR_OF_FLOAT(_fontInfo.leading) },
            @{ @"capHeight": STR_OF_FLOAT(_fontInfo.capHeight) },
            @{ @"xHeight": STR_OF_FLOAT(_fontInfo.xHeight) },
            @{ @"slantAngle": STR_OF_FLOAT(_fontInfo.slantAngle) },
            @{ @"underlineThickness": STR_OF_FLOAT(_fontInfo.underlineThickness) },
            @{ @"underlinePosition": STR_OF_FLOAT(_fontInfo.underlinePosition) },
            @{ @"boundingBox": NSStringFromCGRect(_fontInfo.boundingBox) },
            @{ @"unitsPerEm": STR_OF_INTEGER(_fontInfo.unitsPerEm) },
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - startY) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.layer.borderColor = [UIColor redColor].CGColor;
        tableView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FontInfoViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:sCellIdentifier];
    }
    
    NSDictionary *entry = self.listData[indexPath.row];
    cell.textLabel.text = [[entry allKeys] firstObject];
    cell.detailTextLabel.text = [[entry allValues] firstObject];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

@end
