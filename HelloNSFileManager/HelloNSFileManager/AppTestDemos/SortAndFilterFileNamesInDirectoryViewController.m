//
//  SortAndFilterFileNamesInDirectoryViewController.m
//  HelloNSFileManager
//
//  Created by wesley_chen on 2018/8/8.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SortAndFilterFileNamesInDirectoryViewController.h"
#import "WCFileManagerTool.h"

@interface SortAndFilterFileNamesInDirectoryViewController ()

@end

@implementation SortAndFilterFileNamesInDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_filtered_file_names_by_extension];
}

- (void)test_filtered_file_names_by_extension {
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SampleData"];
    
    NSArray *fileNames1 = [WCFileManagerTool filteredFileNamesInDirectoryPath:directoryPath ascend:YES extensions:@[@"json"]];
    NSLog(@"sorted ascend------------------");
    NSLog(@"%@", fileNames1);
    
    NSLog(@"sorted descend------------------");
    NSArray *fileNames2 = [WCFileManagerTool filteredFileNamesInDirectoryPath:directoryPath ascend:NO extensions:@[@"json", @"txt"]];
    NSLog(@"%@", fileNames2);
}

@end
