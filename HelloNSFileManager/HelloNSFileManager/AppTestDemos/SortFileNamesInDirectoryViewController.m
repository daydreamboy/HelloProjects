//
//  SortFileNamesInDirectoryViewController.m
//  HelloNSFileManager
//
//  Created by wesley_chen on 2018/8/8.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "SortFileNamesInDirectoryViewController.h"
#import "WCFileManagerTool.h"

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
    
    NSArray *fileNamesBySize1 = [WCFileManagerTool sortedFileNamesInDirectoryPath:directoryPath ascend:YES];
    NSLog(@"sorted ascend------------------");
    NSLog(@"%@", fileNamesBySize1);
    
    NSLog(@"sorted descend------------------");
    NSArray *fileNamesBySize2 = [WCFileManagerTool sortedFileNamesInDirectoryPath:directoryPath ascend:NO];
    NSLog(@"%@", fileNamesBySize2);
}


- (void)test_sorted_file_names_by_size {
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"SampleData"];
    
    NSArray *fileNamesBySize1 = [WCFileManagerTool sortedFileNamesBySizeInDirectoryPath:directoryPath ascend:YES];
    NSLog(@"sorted ascend------------------");
    NSLog(@"%@", fileNamesBySize1);
    
    NSLog(@"sorted descend------------------");
    NSArray *fileNamesBySize2 = [WCFileManagerTool sortedFileNamesBySizeInDirectoryPath:directoryPath ascend:NO];
    NSLog(@"%@", fileNamesBySize2);
}

@end
