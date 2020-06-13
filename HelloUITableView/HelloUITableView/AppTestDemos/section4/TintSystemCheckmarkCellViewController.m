//
//  TintSystemCheckmarkCellViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TintSystemCheckmarkCellViewController.h"
#import "WCTableViewCellTool.h"
#import "WCIndexedCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TintSystemCheckmarkCell : WCIndexedCell
@property (nonatomic, strong, nullable) UIColor *checkmarkTintColor;
@end

@interface TintSystemCheckmarkCell ()
@end

@implementation TintSystemCheckmarkCell

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // Note: when cell is editing, the subviews in contentView is not interactive
    self.contentView.userInteractionEnabled = editing ? NO : YES;
}

- (void)setCheckmarkTintColor:(nullable UIColor *)checkmarkTintColor {
    [super setAttributeValue:(checkmarkTintColor ?: [NSNull null]) forAttributeKey:@"checkmarkTintColor"];
}

- (nullable UIColor *)checkmarkTintColor {
    return [super attributeValueForAttributeKey:@"checkmarkTintColor"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Note: indexPathForCell not works even though the cell is visible
    //NSIndexPath *indexPath = [tableView indexPathForCell:self];

    UIView *cellEditControl;
    UIColor *checkmarkTintColor = self.checkmarkTintColor;
    if (checkmarkTintColor) {
        if (NSClassFromString(@"UITableViewCellEditControl")) {
            for (UIView *subview in self.subviews) {
                if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
                    cellEditControl = subview;
                    break;
                }
            }
        }

        if (cellEditControl) {
            cellEditControl.tintColor = [checkmarkTintColor isKindOfClass:[UIColor class]] ? checkmarkTintColor : [UIColor systemBlueColor];
        }
    }
}

@end

NS_ASSUME_NONNULL_END

@interface TintSystemCheckmarkCellViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation TintSystemCheckmarkCellViewController

static NSString *sCellIdentifier = @"TintSystemCheckmarkCellViewController_sCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *toggleItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(itemToggleClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[ toggleItem ];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.editing = NO;
        tableView.allowsSelection = NO;
        tableView.allowsMultipleSelection = NO;
        tableView.allowsSelectionDuringEditing = NO;
        tableView.allowsMultipleSelectionDuringEditing = YES;
        [tableView registerClass:[TintSystemCheckmarkCell class] forCellReuseIdentifier:sCellIdentifier];
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSMutableArray *)listArr {
    if (!_listArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        
        _listArr = array;
    }
    return _listArr;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TintSystemCheckmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[TintSystemCheckmarkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    cell.textLabel.text = self.listArr[indexPath.row];
    [cell configureCellAtIndexPath:indexPath configureBlock:^{
        NSArray *colors = @[
            [UIColor orangeColor],
            [UIColor magentaColor],
            [NSNull null],
        ];
        
        UIColor *color = colors[indexPath.row % 3];
        cell.checkmarkTintColor = [color isKindOfClass:[UIColor class]] ? color : nil;
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"select: (%ld, %ld)", indexPath.section, indexPath.row);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"unselect: (%ld,%ld)", indexPath.section, indexPath.row);
}

#pragma mark - Action

- (void)itemToggleClicked:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

@end
