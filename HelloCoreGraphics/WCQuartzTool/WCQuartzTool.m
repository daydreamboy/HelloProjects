//
//  WCQuartzTool.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/8/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCQuartzTool.h"

@implementation WCQuartzTool

static void MyCGPathApplierFunc (void *info, const CGPathElement *element) {
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;

    CGPoint *points = element->points;
    CGPathElementType type = element->type;

    switch(type) {
        case kCGPathElementMoveToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;

        case kCGPathElementAddLineToPoint: // contains 1 point
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            break;

        case kCGPathElementAddQuadCurveToPoint: // contains 2 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            break;

        case kCGPathElementAddCurveToPoint: // contains 3 points
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[0]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[1]]];
            [bezierPoints addObject:[NSValue valueWithCGPoint:points[2]]];
            break;

        case kCGPathElementCloseSubpath: // contains no point
            break;
    }
}

+ (nullable NSArray<NSValue *> *)allPointsWithCGPath:(CGPathRef)path {
    if (path == NULL) {
        return nil;
    }
    
    NSMutableArray *bezierPoints = [NSMutableArray array];
    CGPathApply(path, (__bridge void * _Nullable)(bezierPoints), MyCGPathApplierFunc);
    
    return bezierPoints;
}


@end
