//
//  FileTestListWKViewController.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/9/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "FileTestListWKViewController.h"
#import "WCFileManagerTool.h"
#import "FilePreviewWKViewController.h"
#import "WCMacroTool.h"

@interface FileTestListWKViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *listData;
@property (nonatomic, strong) NSString *dirPath;
@property (nonatomic, strong) NSArray<NSString *> *fileNames;
@end

@implementation FileTestListWKViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *dirPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"FileTestList"];
        NSArray *fileNames = [WCFileManagerTool sortedFileNamesInDirectoryPath:dirPath ascend:YES];
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSString *fileName in fileNames) {
            if (fileName.pathExtension.length) {
                [arrM addObject:[dirPath stringByAppendingPathComponent:fileName]];
            }
        }
        _listData = arrM;
        _dirPath = dirPath;
        _fileNames = fileNames;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件列表";
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
}

- (void)dealloc {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *filePath = self.listData[indexPath.row];
    
    FilePreviewWKViewController *vc = [[FilePreviewWKViewController alloc] initWithFilePath:filePath];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
