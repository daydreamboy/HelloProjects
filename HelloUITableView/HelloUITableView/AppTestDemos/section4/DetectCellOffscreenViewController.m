//
//  DetectCellOffscreenViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2019/7/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "DetectCellOffscreenViewController.h"

#define NSStringFromIndexPath(indexPath) ([NSString stringWithFormat:@"row: %@, section: %@", @(indexPath.row), @(indexPath.section)])

@interface MyTableViewCell : UITableViewCell

@end

@implementation MyTableViewCell

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        __unused int a = 1;
    }
    else {
        __unused int a = 0;
    }
}

@end

@interface DetectCellOffscreenViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSMutableArray *> *listData;
@property (nonatomic, strong) UILabel *hudTip;
@end

@implementation DetectCellOffscreenViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        [groups addObject:[NSArray arrayWithObjects:@"R0", @"R1", @"R2", @"R3", @"R4", @"R5", @"R6", @"R7", @"R8", @"R9", @"R10", @"R11", @"R12", @"R13", @"R14", @"R15", @"R16", @"R17", @"R18", @"R19", @"R20", @"R21", @"R22", @"R23", @"R24", @"R25", @"R26", nil]];
        
        _listData = groups;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor blackColor];
    [self.view addSubview:_tableView];
    
    _hudTip = [[UILabel alloc] initWithFrame:CGRectZero];
    _hudTip.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    _hudTip.userInteractionEnabled = NO;
    _hudTip.layer.cornerRadius = 3;
    _hudTip.layer.masksToBounds = YES;
    _hudTip.alpha = 0;
    _hudTip.textColor = [UIColor whiteColor];
    _hudTip.font = [UIFont boldSystemFontOfSize:25];
    
//    [self.view addSubview:_hudTip];
    
    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(reloadItemClicked:)];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshItemClicked:)];
 
    self.navigationItem.rightBarButtonItems = @[ reloadItem, refreshItem ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numItemsInSection = [[self.listData objectAtIndex:section] count];
    return numItemsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    cell.textLabel.text = [[self.listData objectAtIndex:section] objectAtIndex:row];
    
    NSLog(@"cellForRow: %@", NSStringFromIndexPath(indexPath));
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // @see https://stackoverflow.com/a/15980777
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] == NSNotFound) {
        NSLog(@"offscreen: %@", NSStringFromIndexPath(indexPath));
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound) {
        NSLog(@"onscreen: %@", NSStringFromIndexPath(indexPath));
    }
}

#pragma mark - Action

- (void)reloadItemClicked:(id)sender {
    [self.tableView reloadData];
}

- (void)refreshItemClicked:(id)sender {
    
//    dispatch_group_t group = dispatch_group_create();
//
//    for (int i = 0; i < 100; i++) {
//        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        });
//    }
    
    for (NSInteger i = 0; i < 2; i++) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.tableView beginUpdates];
        [NSThread sleepForTimeInterval:arc4random_uniform(100) / 1000.0f];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [CATransaction commit];
    }
    
//    [self.listData[0] removeObjectAtIndex:0];
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //UIPickerView *pickerView = [[UIPickerView alloc] init];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"User begin dragging");
//
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    self.hudTip.alpha = 1;
//    self.hudTip.text = @"User begin dragging";
//    [self.hudTip sizeToFit];
//    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"User end dragging and is decelerate: %@", decelerate ? @"YES" : @"NO");
//
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    self.hudTip.alpha = 1;
//    self.hudTip.text = @"User end dragging";
//    [self.hudTip sizeToFit];
//    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
//    [UIView animateWithDuration:1.5 animations:^{
//        self.hudTip.alpha = 0;
//    }];
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"ScrollView begin decelerating");
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"ScrollView end decelerating");
//}

@end
