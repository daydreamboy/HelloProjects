//
//  ColumnarLayoutView.m
//  HelloCoreText
//
//  Created by wesley_chen on 2019/4/23.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ColumnarLayoutView.h"

@implementation ColumnarLayoutView

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (CFArrayRef)createColumnsWithColumnCount:(int)columnCount {
    int column;
    
    CGRect *columnRects = (CGRect *)calloc(columnCount, sizeof(*columnRects));
    columnRects[0] = self.bounds;
    
    // Divide the columns equally across the frame's width
    CGFloat columnWidth = CGRectGetWidth(self.bounds) / columnCount;
    for (column = 0; column < columnCount - 1; column++) {
        CGRectDivide(<#CGRect rect#>, <#CGRect * _Nonnull slice#>, <#CGRect * _Nonnull remainder#>, <#CGFloat amount#>, <#CGRectEdge edge#>)
    }
}

@end
