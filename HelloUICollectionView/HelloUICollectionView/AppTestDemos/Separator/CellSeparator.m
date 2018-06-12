//
//  CellSeparator.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CellSeparator.h"

@implementation CellSeparator

@dynamic color;

static UIColor *sColor;

+ (UIColor *)color {
    // @see http://blog.andrewmadsen.com/post/145919242155/objective-c-class-properties
    return sColor;
}

+ (void)setColor:(UIColor *)color {
    sColor = color;
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.frame = layoutAttributes.frame;
    self.backgroundColor = self.class.color;
}

@end
