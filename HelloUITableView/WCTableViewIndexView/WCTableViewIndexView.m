//
//  WCTableViewIndexView.m
//  HelloUITableView
//
//  Created by wesley_chen on 2021/4/19.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCTableViewIndexView.h"
#import <QuartzCore/QuartzCore.h>

#define TableIndexViewDefaultWidth    20.0f
#define TableIndexViewDefaultMargin   16.0f

@interface WCTableViewIndexView ()
@property (nonatomic) NSUInteger currentSection;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;

- (void)show;
- (void)hide;

@end

@implementation WCTableViewIndexView

@synthesize delegate = _delegate;
@synthesize numberOfSections = _numberOfSections;

- (instancetype)initWithTableView:(UITableView *)tableView {
    CGRect tableBounds = [tableView bounds];
    CGRect outerFrame = CGRectZero;

    outerFrame.origin.x = tableBounds.size.width - (40 + TableIndexViewDefaultWidth);
    outerFrame.origin.y = 0;
    outerFrame.size.width  = (40 + TableIndexViewDefaultWidth);
    outerFrame.size.height = tableBounds.size.height;

    CGRect indexFrame = CGRectZero;
    indexFrame.origin.x = tableBounds.size.width - (TableIndexViewDefaultWidth + TableIndexViewDefaultMargin);
    indexFrame.origin.y = TableIndexViewDefaultMargin;
    indexFrame.size.width = TableIndexViewDefaultWidth;
    indexFrame.size.height = tableBounds.size.height - 2*TableIndexViewDefaultMargin;

    if ((self = [super initWithFrame:outerFrame])) {
        // Initialization code

        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;

        // Content View (Background color, Round Corners)
        indexFrame.origin.x = 20;

        _backgroundView = [[UIView alloc] initWithFrame:indexFrame];

        _backgroundView.backgroundColor = [UIColor colorWithRed:1.00f
                                                          green:1.00f
                                                           blue:1.00f
                                                          alpha:0.75f];

        CGFloat radius = 0.5f*TableIndexViewDefaultWidth;
        _backgroundView.layer.cornerRadius = radius;

        [self addSubview:_backgroundView];

        _numberOfSections = [[tableView dataSource] numberOfSectionsInTableView:tableView];

        CGRect contentFrame = CGRectZero;
        contentFrame.origin.x = 0;
        contentFrame.origin.y = radius;
        contentFrame.size.width = TableIndexViewDefaultWidth;
        contentFrame.size.height = indexFrame.size.height - 2*radius;

        _contentView = [[UIView alloc] initWithFrame:contentFrame];
        _contentView.backgroundColor = [UIColor clearColor];

        [_backgroundView addSubview:_contentView];

        CGFloat labelWidth = contentFrame.size.width;
        CGFloat labelHeight = 12;

        CGFloat interLabelHeight = (contentFrame.size.height - (_numberOfSections)*labelHeight)/(_numberOfSections - 1.0);

        CGFloat fontSize = 12;

        for (NSUInteger i = 0; i < _numberOfSections; i++) {

            if ( _numberOfSections > 20 && i%2 == 0 ) {
                // Skip even section labels if count is greater than, say, 20
                continue;
            }

            CGRect labelFrame = CGRectZero;
            labelFrame.size.width  = labelWidth;
            labelFrame.size.height = labelHeight;
            labelFrame.origin.x    = 0;
            labelFrame.origin.y    = i*(labelHeight+interLabelHeight);

            UILabel* label = [[UILabel alloc] initWithFrame:labelFrame];
            label.text = [NSString stringWithFormat:@"%lu", i+1];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:floorf(1.0f*fontSize)];

            [_contentView addSubview:label];
        }

//        [_backgroundView setHidden:YES];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Control Actions

- (void)didTap:(id) sender {
    [_backgroundView setHidden:NO];
}

- (void)didRelease:(id) sender {
    [_backgroundView setHidden:YES];
}

#pragma mark - Internal Operation

- (void)show {
    [self didTap:nil];
}

- (void)hide {
    [self didRelease:nil];
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:_contentView];
    CGFloat ratio = location.y / _contentView.frame.size.height;

    NSUInteger newSection = ratio*_numberOfSections;

    if (newSection != _currentSection) {
        _currentSection = newSection;
        if ([_delegate respondsToSelector:@selector(tableViewIndexView:didSwipeToSection:)]) {
            [_delegate tableViewIndexView:self didSwipeToSection:_currentSection];
        }
    }

//    [_backgroundView setHidden:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:_contentView];
    CGFloat ratio = location.y / _contentView.frame.size.height;

    NSUInteger newSection = ratio*_numberOfSections;

    if (newSection != _currentSection) {
        _currentSection = newSection;

        if (newSection < _numberOfSections) {
            if (_delegate) {
                [_delegate tableViewIndexView:self didSwipeToSection:_currentSection];
            }
            else{
                // **Perhaps call the table view directly
            }
        }
    }

//    [_backgroundView setHidden:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [_backgroundView setHidden:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    [_backgroundView setHidden:YES];
}

@end
