//
//  CombineInsertionAndDeletionViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/12/3.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CombineInsertionAndDeletionViewController.h"

#define TIME_UNIX_TIMESTAMP ([NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]])

@interface CombineInsertionAndDeletionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, strong) NSMutableArray *fixedSizeListData;
@property (nonatomic, assign) NSUInteger currentRow;
@property (nonatomic, assign) NSUInteger fixedSize;
@end

@implementation CombineInsertionAndDeletionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // TODO: Configure list size here
    _fixedSize = 3;
    
    _fixedSizeListData = [NSMutableArray arrayWithCapacity:_fixedSize];
    for (NSUInteger i = 0; i < _fixedSize; ++i) {
        [_fixedSizeListData addObject:TIME_UNIX_TIMESTAMP];
    }
    
    
    [self.view addSubview:self.labelTip];
    [self.view addSubview:self.tableView];
    
    UIStepper *stepper = [[UIStepper alloc] init];
    stepper.minimumValue = 0;
    stepper.maximumValue = _fixedSizeListData.count - 1;
    [stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *itemStepper = [[UIBarButtonItem alloc] initWithCustomView:stepper];
    
    UIBarButtonItem *itemInsert = [[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStylePlain target:self action:@selector(itemInsertClicked:)];
    
    UIBarButtonItem *itemDelete = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(itemDeleteClicked:)];
    
    UIBarButtonItem *itemReload = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(itemReloadClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[ itemReload, itemDelete, itemInsert, itemStepper];
}

#pragma mark - Getter

- (UILabel *)labelTip {
    if (!_labelTip) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, CGRectGetWidth(self.view.bounds), 80)];
        label.text = [NSString stringWithFormat:@"Operate at row: %ld", (long)_currentRow];
        label.font = [UIFont systemFontOfSize:17];
        
        _labelTip = label;
    }
    
    return _labelTip;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_labelTip.frame), CGRectGetWidth(self.view.bounds), screenSize.height - startY - CGRectGetHeight(_labelTip.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fixedSizeListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"InsertMeViewController_CellIdentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        cell.imageView.image = [UIImage imageNamed:@"babelfish"];
    }

    cell.textLabel.text = [_fixedSizeListData[indexPath.row] description];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action

- (void)stepperValueChanged:(id)sender {
    UIStepper *stepper = (UIStepper *)sender;
    self.currentRow = stepper.value;
    self.labelTip.text = [NSString stringWithFormat:@"Operate at row: %ld", (long)self.currentRow];
}

- (void)itemInsertClicked:(id)sender {
    if (0 <= self.currentRow && self.currentRow < self.fixedSizeListData.count) {
        
        NSUInteger deleteIndex = self.fixedSize - 1;
        NSUInteger insertIndex = self.currentRow;
        
        [self.fixedSizeListData removeObjectAtIndex:self.fixedSizeListData.count - 1];
        [self.fixedSizeListData insertObject:TIME_UNIX_TIMESTAMP atIndex:self.currentRow];
        
        [self.tableView beginUpdates];
        
        NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:deleteIndex inSection:0];
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:insertIndex inSection:0];

        [self.tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)itemDeleteClicked:(id)sender {
    if (0 <= self.currentRow && self.currentRow < self.fixedSizeListData.count) {
        
        NSUInteger deleteIndex = self.currentRow;
        NSUInteger insertIndex = self.fixedSize - 1;
        
        [self.fixedSizeListData removeObjectAtIndex:deleteIndex];
        [self.fixedSizeListData insertObject:TIME_UNIX_TIMESTAMP atIndex:insertIndex];
        
        [self.tableView beginUpdates];
        
        NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:deleteIndex inSection:0];
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:insertIndex inSection:0];

        [self.tableView insertRowsAtIndexPaths:@[insertIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

- (void)itemReloadClicked:(id)sender {
    [self.tableView reloadData];
}

@end
