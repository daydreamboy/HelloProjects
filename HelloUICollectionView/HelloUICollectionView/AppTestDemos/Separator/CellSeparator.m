//
//  CellSeparator.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CellSeparator.h"

@implementation CellSeparator

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.frame = layoutAttributes.frame;
}

@end
