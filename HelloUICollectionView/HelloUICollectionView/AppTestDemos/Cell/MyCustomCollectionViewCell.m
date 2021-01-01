//
//  MyCustomCollectionViewCell.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/9.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MyCustomCollectionViewCell.h"

@interface MyCustomCollectionViewCell ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation MyCustomCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        
        // Note: not add subview to itself according to Apple Doc
        //[self addSubview:label];
        [self.contentView addSubview:label];
        
        _textLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
