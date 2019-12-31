//
//  JSCodeTestListViewController.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "JSCodeTestListViewController.h"
#import "WCFileManagerTool.h"
#import "JSCodeEditViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WCMacroKit.h"

@interface JSCodeTestListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *listData;
@property (nonatomic, strong) NSString *dirPath;
@end

@implementation JSCodeTestListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *dirPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"JSTestList"];
        NSArray *fileNames = [WCFileManagerTool sortedFileNamesInDirectoryPath:dirPath ascend:YES];
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSString *fileName in fileNames) {
            if ([fileName.pathExtension isEqualToString:@"js"]) {
                [arrM addObject:[dirPath stringByAppendingPathComponent:fileName]];
            }
        }
        _listData = arrM;
        _dirPath = dirPath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JSCode列表";
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
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editItemClicked:)];
    UIBarButtonItem *scanQRCodeItem = [[UIBarButtonItem alloc] initWithTitle:@"QRCode" style:UIBarButtonItemStylePlain target:self action:@selector(scanQRCodeItemClicked:)];
    self.navigationItem.rightBarButtonItems = @[editItem, scanQRCodeItem];
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
    static NSString *sCellIdentifier = @"CardListViewController_sCellIdentifier";
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
        JSCodeEditViewController *vc = [JSCodeEditViewController new];
        vc.JSCodeString = JSCode;
        __weak typeof(self) weak_self = self;
        vc.runBlock = ^(NSString * _Nonnull JSCode) {
            [weak_self runJSCode:JSCode atIndexPath:indexPath];
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
    NSString *JSCode = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        [self runJSCode:JSCode atIndexPath:indexPath];
    }
    else {
        NSLog(@"error: %@", error);
    }
}

#pragma mark - Inject JS Code into Context

- (void)runJSCode:(NSString *)JSCode atIndexPath:(NSIndexPath *)indexPath {
    JSContext *context = [[JSContext alloc] init];
    [self injectCodeWithContext:context atIndexPath:indexPath];
    [context evaluateScript:JSCode];
}

- (void)injectCodeWithContext:(JSContext *)context atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        context[@"alert"] = ^(id object) {
            NSString *message = [object description];
            if ([NSThread isMainThread]) {
                SHOW_ALERT(@"JS Alert", message, @"Ok", nil);
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_ALERT(@"JS Alert", message, @"Ok", nil);
                });
            }
        };
    }
    else if (indexPath.row == 1) {
        // @see https://stackoverflow.com/a/21325240
        [context evaluateScript:@"var console = {}"];
        context[@"console"][@"log"] = ^(id object) {
            NSString *message = [object description];
            NSLog(@"JSBridge log: %@", message);
        };
    }
}

@end
