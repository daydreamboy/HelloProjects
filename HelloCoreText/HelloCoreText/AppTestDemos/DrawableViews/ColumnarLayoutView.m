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
        CGRectDivide(columnRects[column], &columnRects[column], &columnRects[column + 1], columnWidth, CGRectMinXEdge);
    }
    
    // Inset all columns by a few pixels of margin
    for (column = 0; column < columnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column], 8.0, 15.0);
    }
    
    // Create an array of layout paths, one for each column
    CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, columnCount, &kCFTypeArrayCallBacks);
    
    for (column = 0; column < columnCount; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRects[column]);
        CFArrayInsertValueAtIndex(array, column, path);
        CFRelease(path);
    }
    free(columnRects);
    
    return array;
}

@end
