//
//  CustomizeSelectMeViewController.m
//  HelloUITableView
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CustomizeSelectMeViewController.h"

@interface CustomizeSelectMeCell : UITableViewCell
@property (nonatomic, strong) UIColor *checkmarkTintColor;
@property (nonatomic, strong, readonly) UIButton *checkmarkButton;
@property (nonatomic, assign) UIEdgeInsets checkmarkButtonInsets;
@property (nonatomic, assign) BOOL shiftContentViewWhileEditing;
@end

@interface CustomizeSelectMeCell ()
@property (nonatomic, strong, readwrite) UIButton *checkmarkButton;
@end

@implementation CustomizeSelectMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _shiftContentViewWhileEditing = YES;
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    self.contentView.userInteractionEnabled = editing ? NO : YES;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    //[super willTransitionToState:state];
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
    [super didTransitionToState:state];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.checkmarkButton.selected = selected;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView *cellEditControl;
    if (NSClassFromString(@"UITableViewCellEditControl")) {
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
                cellEditControl = subview;
                cellEditControl.hidden = YES;
                break;
            }
        }
    }
    
    if (cellEditControl) {
        if (self.checkmarkButton) {
            cellEditControl.hidden = YES;
            
            BOOL isFirstLayoutSubviews = NO;
            if (!self.checkmarkButton.superview) {
                [self addSubview:self.checkmarkButton];
                isFirstLayoutSubviews = YES;
            }
            
            UIEdgeInsets paddings = UIEdgeInsetsEqualToEdgeInsets(self.checkmarkButtonInsets, UIEdgeInsetsZero)
                                    ? UIEdgeInsetsMake(
                                                       (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.checkmarkButton.bounds)) / 2.0,
                                                       (CGRectGetWidth(cellEditControl.bounds) - CGRectGetWidth(self.checkmarkButton.bounds)) / 2.0,
                                                       (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.checkmarkButton.bounds)) / 2.0,
                                                       (CGRectGetWidth(cellEditControl.bounds) - CGRectGetWidth(self.checkmarkButton.bounds)) / 2.0
                                                       )
                                    : self.checkmarkButtonInsets;

            CGFloat offsetXForCheckmarkButton = self.isEditing ? paddings.left : (-(paddings.right + CGRectGetWidth(self.checkmarkButton.bounds)));
            if (isFirstLayoutSubviews) {
                offsetXForCheckmarkButton = 0;//(-(paddings.right + CGRectGetWidth(self.checkmarkButton.bounds)));
            }
            
            CGFloat offsetXForContentView = (self.isEditing && self.shiftContentViewWhileEditing)
                                            ? (paddings.left + paddings.right + CGRectGetWidth(self.checkmarkButton.bounds))
                                            : 0;
            
            self.contentView.frame = CGRectMake(offsetXForContentView, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
            self.checkmarkButton.frame = CGRectMake(offsetXForCheckmarkButton, paddings.top, CGRectGetWidth(self.checkmarkButton.bounds), CGRectGetHeight(self.checkmarkButton.bounds));
        }
        else if (self.checkmarkTintColor) {
            cellEditControl.tintColor = self.checkmarkTintColor;
        }
    }
}

#pragma mark - Getter

- (UIButton *)checkmarkButton {
    if (!_checkmarkButton) {
        CGFloat offset = 32.0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-(offset/2.0)-(25.0/2.0),  (self.contentView.frame.size.height/2.0)-(25/2.0), 25  , 25);
        button.adjustsImageWhenHighlighted = NO;
        button.backgroundColor = [UIColor yellowColor];
        [button setImage:[UIImage imageNamed:@"button_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonCheckmarkClicked:) forControlEvents:UIControlEventTouchUpInside];

        _checkmarkButton = button;
    }

    return _checkmarkButton;
}

#pragma mark - Action

- (void)buttonCheckmarkClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

@end

@interface CustomizeSelectMeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listArr;
@property (nonatomic, strong) UIBarButtonItem *itemDelete;
@end

@implementation CustomizeSelectMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareData];
    [self prepareView];
}

- (void)prepareData {
    if (!_listArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
//        id firstObject = [array firstObject];
//        [array removeAllObjects];
//        [array addObject:firstObject];
        _listArr = [array subarrayWithRange:NSMakeRange(0, 2)];
    }
}

- (void)prepareView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.editing = NO;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    //_tableView.allowsMultipleSelection = YES;
    [_tableView registerClass:[CustomizeSelectMeCell class] forCellReuseIdentifier:NSStringFromClass([CustomizeSelectMeCell class])];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(itemDeleteClicked:)];
    deleteItem.enabled = _tableView.indexPathsForSelectedRows.count ? YES : NO;
    
    UIBarButtonItem *toggleItem = [[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(itemToggleClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[ deleteItem, toggleItem ];
    
    _itemDelete = deleteItem;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer;
    if (!CellIdentifer) {
        CellIdentifer = NSStringFromClass([CustomizeSelectMeCell class]);
    }
    
    CustomizeSelectMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    //cell.imageView.image = [UIImage imageNamed:@"babelfish"];
    
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    cell.checkmarkButton.frame = CGRectMake(0, 0, 40, 40);
    cell.checkmarkButton.adjustsImageWhenHighlighted = NO;
    cell.checkmarkButton.backgroundColor = [UIColor yellowColor];
    [cell.checkmarkButton setImage:[UIImage imageNamed:@"button_normal"] forState:UIControlStateNormal];
    [cell.checkmarkButton setImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateSelected];
    //[cell.checkmarkButton addTarget:self action:@selector(buttonCheckmarkClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.checkmarkTintColor = [UIColor orangeColor];
    cell.checkmarkButtonInsets = UIEdgeInsetsMake(5, 10, 0, 20);
    //cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _listArr[indexPath.row];
    if (indexPath.row % 2 == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.shiftContentViewWhileEditing = YES;
    }
    else {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.shiftContentViewWhileEditing = NO;
    }
    // Counterpart for return NO in - tableView:canEditRowAtIndexPath: method
    //cell.userInteractionEnabled = indexPath.row == 0 ? NO : YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(300, 10, 30, 30);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:button];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        // Can't edit at row 0
//        return NO;
//    }
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select: %@", indexPath);
    _itemDelete.enabled = _tableView.indexPathsForSelectedRows.count ? YES : NO;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"deselect: %@", indexPath);
    _itemDelete.enabled = _tableView.indexPathsForSelectedRows.count ? YES : NO;
}

//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}

#pragma mark - Action

- (void)itemDeleteClicked:(id)sender {
    
    if (_tableView.indexPathsForSelectedRows.count) {
        for (NSIndexPath *indexPath in _tableView.indexPathsForSelectedRows) {
            [_listArr removeObjectAtIndex:indexPath.row];
        }
        [_tableView deleteRowsAtIndexPaths:_tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        _itemDelete.enabled = _tableView.indexPathsForSelectedRows.count ? YES : NO;
    }
}

- (void)itemToggleClicked:(id)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (void)buttonClicked:(id)sender {
    NSLog(@"123243");
}

@end
