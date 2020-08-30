//
//  MixRenderListWKViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/8/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "MixRenderListWKViewController.h"
#import "WCMacroTool.h"
#import "HTMLCodeEditWKViewController.h"
#import "MixRenderWKViewController.h"

@interface MixRenderListWKViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *listData;
@end

@implementation MixRenderListWKViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *dirPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"HTMLTestList"];
        NSArray *fileNames = @[
            @"web_mix_with_native_control_1.html",
            @"web_mix_with_native_control_2.html",
        ];
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSString *fileName in fileNames) {
            if ([fileName.pathExtension isEqualToString:@"html"]) {
                [arrM addObject:[dirPath stringByAppendingPathComponent:fileName]];
            }
        }
        _listData = arrM;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HTMLCode列表";
    if (IOS11_OR_LATER) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#pragma GCC diagnostic pop
#endif
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        self.automaticallyAdjustsScrollViewInsets = NO;
#pragma GCC diagnostic pop
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editItemClicked:)];
    UIBarButtonItem *scanQRCodeItem = [[UIBarButtonItem alloc] initWithTitle:@"QRCode" style:UIBarButtonItemStylePlain target:self action:@selector(scanQRCodeItemClicked:)];
    self.navigationItem.rightBarButtonItems = @[editItem, scanQRCodeItem];
}

- (void)dealloc {
}

#pragma mark - Actions

- (void)editItemClicked:(id)sender {
    //[self.navigationController pushViewController:[TemplateJSONEditViewController new] animated:YES];
}

- (void)scanQRCodeItemClicked:(id)sender {
    //[self.navigationController pushViewController:[ScanQRCodeViewController new] animated:YES];
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
    static NSString *sCellIdentifier = @"JSCodeTestListViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    cell.textLabel.text = [self.listData[indexPath.row] lastPathComponent];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *filePath = self.listData[indexPath.row];
    NSError *error;
    NSString *JSCode = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        HTMLCodeEditWKViewController *vc = [HTMLCodeEditWKViewController new];
        vc.HTMLCodeString = JSCode;
        __weak typeof(self) weak_self = self;
        vc.runBlock = ^(NSString * _Nonnull HTMLCode) {
            MixRenderWKViewController *vc = [[MixRenderWKViewController alloc] initWithHTMLString:HTMLCode fileName:[filePath lastPathComponent]];
            [weak_self.navigationController pushViewController:vc animated:YES];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        NSLog(@"error: %@", error);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *filePath = self.listData[indexPath.row];
    
    NSError *error;
    NSString *HTMLCode = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        MixRenderWKViewController *vc = [[MixRenderWKViewController alloc] initWithHTMLString:HTMLCode fileName:[filePath lastPathComponent]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        SHOW_ALERT(@"An error occurred", [error description], @"I'll check", nil);
    }
}

@end
