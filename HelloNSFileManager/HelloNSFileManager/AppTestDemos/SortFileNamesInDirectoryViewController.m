//
//  SortFileNamesInDirectoryViewController.m
//  HelloNSFileManager
//
//  Created by wesley_chen on 2018/8/8.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SortFileNamesInDirectoryViewController.h"
#import "WCFileTool.h"

@interface SortFileNamesInDirectoryViewController ()

@end

@implementation SortFileNamesInDirectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_sorted_file_names_by_name];
    //[self test_sorted_file_names_by_size];
}

- (void)test_sorted_file_names_by_name {
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SampleData"];
    
    NSArray *fileNames1 = [WCFileTool sortedFileNamesInDirectoryPath:directoryPath ascend:YES];
    NSLog(@"sorted ascend------------------");
    NSLog(@"%@", fileNames1);
    
    NSLog(@"sorted descend------------------");
    NSArray *fileNames2 = [WCFileTool sortedFileNamesInDirectoryPath:directoryPath ascend:NO];
    NSLog(@"%@", fileNames2);
}

- (void)test_sorted_file_names_by_size {
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SampleData"];
    
    NSArray *fileNamesBySize1 = [WCFileTool sortedFileNamesBySizeInDirectoryPath:directoryPath ascend:YES];
    NSLog(@"sorted ascend------------------");
    NSLog(@"%@", fileNamesBySize1);
    
    NSLog(@"sorted descend------------------");
    NSArray *fileNamesBySize2 = [WCFileTool sortedFileNamesBySizeInDirectoryPath:directoryPath ascend:NO];
    NSLog(@"%@", fileNamesBySize2);
}

@end
