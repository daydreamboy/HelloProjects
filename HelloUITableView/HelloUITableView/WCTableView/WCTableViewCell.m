//
//  WCTableViewCell.m
//  LotteryMate
//
//  Created by chenliang-xy on 15/6/2.
//  Copyright (c) 2015年 Qihoo. All rights reserved.
//

#import "WCTableViewCell.h"
#import "WCTableView.h"
#import "UITableViewCell+Addition.h"
#import <objc/runtime.h>

#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

/*!
 *  The location of WCTableViewCell in its section
 */
typedef NS_ENUM(NSUInteger, WCTableViewCellLocation){
    /*!
     *  The middle cell in the section
     */
    WCTableViewCellLocationMiddle,
    /*!
     *  The first cell in the section
     */
    WCTableViewCellLocationTop,
    /*!
     *  The last cell in the section
     */
    WCTableViewCellLocationBottom,
    /*!
     *  The only one cell without siblings in the section which is not the top, bottom or middle type
     */
    WCTableViewCellLocationSingle,
};

@interface WCTableViewCell ()
/*!
 *  All types of WCTableViewCellLocation has separatorOfCell,
 *  and separatorOfCell can work as separatorOfSection when the cell's location is
 *  WCTableViewCellLocationBottom or WCTableViewCellLocationSingle
 */
@property (nonatomic, strong) UIView *separatorOfCell;
/*!
 *  Only cell of type is WCTableViewCellLocationTop or WCTableViewCellLocationSingle has separatorOfSection
 */
@property (nonatomic, strong) UIView *separatorOfSection;
@property (nonatomic, assign) CGFloat separatorHeight;
@property (nonatomic, assign) BOOL separatorInsetChanged;

@property (nonatomic, assign) WCTableViewCellLocation location;

@property (nonatomic, strong) WCTableView *tableView;

@end

@implementation WCTableViewCell {
    UIColor *_separatorColor;
}

@dynamic separatorInset;

static const char * const SeparatorInsetObjectTag = "SeparatorInsetObjectTag";

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    if (IOS7_OR_LATER) {
        [super setSeparatorInset:separatorInset];
    }
    else {
        _separatorInsetChanged = YES;
        NSValue *valueObj = [NSValue valueWithUIEdgeInsets:separatorInset];
        objc_setAssociatedObject(self, SeparatorInsetObjectTag, valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIEdgeInsets)separatorInset {
    if (IOS7_OR_LATER) {
        return [super separatorInset];
    }
    else {
        NSValue *valueObj = objc_getAssociatedObject(self, SeparatorInsetObjectTag);
        return [valueObj UIEdgeInsetsValue];
    }
}

#pragma mark - Public Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		if (!IOS7_OR_LATER) {
			_separatorHeight = 1.0 / [UIScreen mainScreen].scale;
            
			// iOS 6, tableView.separator always NOT nil, so _separatorColor not work
            _separatorColor = [UIColor colorWithRed:224 / 255.0 green:224 / 255.0 blue:224 / 255.0 alpha:1.0];

			_separatorOfCell = [UIView new];
			_separatorOfCell.frame = CGRectMake(0, 0, 0, _separatorHeight);
			_separatorOfCell.backgroundColor = [UIColor blackColor];
            
            UIColor *selectionColor = [UIColor colorWithRed:0xD9 / 255.0 green:0xD9 / 255.0 blue:0xD9 / 255.0 alpha:1];
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor colorWithCGColor:selectionColor.CGColor];
            self.selectedBackgroundView = view;
		}
	}

	return self;
}

+ (instancetype)cellForTableView:(UITableView *)tableView cellClass:(Class)cellClass cellIdentifier:(NSString *)cellIdentifier {
    
    WCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

+ (WCTableViewCell *)cellForTableView:(UITableView *)tableView {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

+ (CGFloat)cellHeight {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

+ (CGFloat)cellDynamicHeightWithData:(id)object {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)setData:(id)object {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


#pragma mark - 

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if (!IOS7_OR_LATER) {
        // Reset reusable cell
        self.separatorInset = _tableView.separatorInset;
        _separatorInsetChanged = NO;
    }
}

- (void)layoutSubviews {
    
    if (IOS7_OR_LATER) {
        [super layoutSubviews];
    }
    else {
        [super layoutSubviews];
        
        if (!_tableView) {
            _tableView = (WCTableView *)[self superTableView];
        }
        
        if (_tableView) {
            self.backgroundColor = [UIColor whiteColor];
            
            _location = [self locationOfCell];
            [self addSeparatorToCellAtLocation:_location];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
    if (!IOS7_OR_LATER) {
        
        if (!_tableView) {
            _tableView = (WCTableView *)[self superTableView];
        }
        
        if (_tableView && self.selectionStyle != UITableViewCellSelectionStyleNone) {
            NSIndexPath *indexPath = [_tableView indexPathForCell:self];
            if (indexPath) {
                
                if (highlighted) {
                    _separatorOfCell.hidden = YES;
                    _separatorOfSection.hidden = YES;
                }
                else {
                    _separatorOfCell.hidden = NO;
                    _separatorOfSection.hidden = NO;
                }
                
                WCTableViewCellLocation location = [self locationOfCell];
                if ((location != WCTableViewCellLocationSingle || location != WCTableViewCellLocationTop)
                    && indexPath.row - 1 >= 0) {
                    NSIndexPath *prevousCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
                    WCTableViewCell *previousCell = (WCTableViewCell *)[_tableView cellForRowAtIndexPath:prevousCellIndexPath];
                    if (previousCell) {
                        previousCell.separatorOfCell.hidden = highlighted ? YES : NO;
                    }
                }
            }
        }
    }
}

#pragma mark -

- (void)addSeparatorToCellAtLocation:(WCTableViewCellLocation)location {
    
    NSAssert(_tableView != nil, @"The cell's tableView can't be nil");
    [self handleSeparatorOfCell:location];
    [self handleSeparatorOfSection:location];
}

- (void)handleSeparatorOfCell:(WCTableViewCellLocation)location {
    // Handle _separatorOfCell
    if (!_separatorInsetChanged) {
        self.separatorInset = _tableView.separatorInset;
    }

    switch (location) {
        case WCTableViewCellLocationBottom:
        case WCTableViewCellLocationSingle: {
            _separatorOfCell.frame = CGRectMake(0,
                                              CGRectGetHeight(self.bounds) - _separatorHeight,
                                              CGRectGetWidth(self.bounds),
                                              _separatorHeight);
            break;
        }
        case WCTableViewCellLocationTop:
        case WCTableViewCellLocationMiddle: {
            _separatorOfCell.frame = CGRectMake(self.separatorInset.left,
                                              CGRectGetHeight(self.bounds) - _separatorHeight,
                                              CGRectGetWidth(self.bounds) - self.separatorInset.left - self.separatorInset.right,
                                              _separatorHeight);
            break;
        }
    }
    
    _separatorOfCell.backgroundColor = [UIColor colorWithCGColor:_tableView.separatorColor ? _tableView.separatorColor.CGColor : _separatorColor.CGColor];
    
    if (!_separatorOfCell.superview) {
        [self addSubview:_separatorOfCell];
        [self bringSubviewToFront:_separatorOfCell];
    }
}

- (void)handleSeparatorOfSection:(WCTableViewCellLocation)location {
    // Handle _separatorOfSection
    switch (location) {
        case WCTableViewCellLocationTop:
        case WCTableViewCellLocationSingle: {
            if (!_separatorOfSection.superview) {
                if (!_separatorOfSection) {
                    _separatorOfSection = [UIView new];
                }
                
                [self addSubview:_separatorOfSection];
                [self bringSubviewToFront:_separatorOfSection];
            }
            _separatorOfSection.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _separatorHeight);
            break;
        }
        case WCTableViewCellLocationMiddle:
        case WCTableViewCellLocationBottom: {
            [_separatorOfSection removeFromSuperview];
            break;
        }
    }
    
	_separatorOfSection.backgroundColor = [UIColor colorWithCGColor:_tableView.separatorColor ? _tableView.separatorColor.CGColor : _separatorColor.CGColor];
}

- (WCTableViewCellLocation)locationOfCell {
    
    NSAssert(_tableView != nil, @"The cell's tableView can't be nil");
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:self];

    NSInteger numberOfRowsInSection = [_tableView.dataSource tableView:_tableView numberOfRowsInSection:indexPath.section];
    NSAssert(numberOfRowsInSection > 0, @"numberOfRows in section %ld must be > 0", (long)indexPath.section);
    
    if (numberOfRowsInSection - 1 == 0) {
        return WCTableViewCellLocationSingle;
    }
    else {
        if (indexPath.row == 0) {
            return WCTableViewCellLocationTop;
        }
        else if (indexPath.row == numberOfRowsInSection - 1) {
            return WCTableViewCellLocationBottom;
        }
        else {
            return WCTableViewCellLocationMiddle;
        }
    }
}

@end
