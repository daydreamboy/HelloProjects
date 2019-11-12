//
//  TouchView.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TouchView.h"

#import "WCViewTool.h"

@interface TouchView ()
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UILabel *labelInsets;
@end

@implementation TouchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelText.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
        _labelText.numberOfLines = 0;
        _labelText.font = [UIFont systemFontOfSize:16];
        _labelText.text = LONG_TEXT;
        _labelText.backgroundColor = [UIColor colorWithRed:255.0 / 255.0 green:190.0 / 255.0 blue:118.0 / 255.0 alpha:1];
        
        [self addSubview:_labelText];
        
        _labelInsets = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _labelInsets.numberOfLines = 0;
        _labelInsets.textColor = [UIColor blueColor];
        _labelInsets.font = [UIFont boldSystemFontOfSize:14];
        _labelInsets.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_labelInsets];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /*
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    self.labelText.frame = self.safeAreaLayoutGuide.layoutFrame;
#pragma GCC diagnostic pop
    
    NSLog(@"safeAreaLayoutGuide.layoutFrame: %@", NSStringFromCGRect(self.labelText.frame));
     
    self.labelInsets.text = NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self]);
     */
    
//    BOOL contained = [WCViewTool checkEdgeInsets:[WCViewTool safeAreaInsetsWithView:self] containsOtherEdgeInsets:[WCViewTool safeAreaInsetsWithView:self.superview]];
//    if (contained) {
        CGRect safeAreaOfParentView = [WCViewTool safeAreaFrameWithParentView:self.superview];
        CGRect intersection = CGRectIntersection(safeAreaOfParentView, self.frame);
        if (!CGRectContainsRect(safeAreaOfParentView, self.frame) && !CGRectIsNull(intersection)) {
            NSLog(@"if, %@, %@, %@", NSStringFromCGRect(safeAreaOfParentView), NSStringFromCGRect(self.frame), NSStringFromCGRect(intersection));
            CGRect newFrame = [self.superview convertRect:intersection toView:self];
            
            self.labelText.frame = newFrame;//CGRectMake(self.labelText.frame.origin.x, self.labelText.frame.origin.y, intersection.size.width, intersection.size.height);
        }
        else {
            NSLog(@"else, %@, %@, %@", NSStringFromCGRect(safeAreaOfParentView), NSStringFromCGRect(self.frame), NSStringFromCGRect(intersection));
            self.labelText.frame = self.bounds;
        }
//        NSLog(@"super insets: %@", NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.superview]));
//    }
//    else {
//        self.labelText.frame = self.safeAreaLayoutGuide.layoutFrame;
//    }
    
    self.labelInsets.text = NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self]);
}

@end
