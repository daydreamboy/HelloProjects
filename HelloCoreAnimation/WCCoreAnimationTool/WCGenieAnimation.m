//
//  WCGenieAnimation.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "WCGenieAnimation.h"

#pragma mark - Data Structure

typedef NS_ENUM(NSUInteger, WCGenieAnimationAxis) {
    WCGenieAnimationAxisX = 0,
    WCGenieAnimationAxisY = 1,
};

typedef union WCGenieAnimationPoint {
    struct { double x, y; };
    double v[2];
} WCGenieAnimationPoint;

typedef struct WCGenieAnimationSegment {
    WCGenieAnimationPoint p1;
    WCGenieAnimationPoint p2;
} WCGenieAnimationSegment;

typedef WCGenieAnimationSegment WCGenieAnimationCurve;

#pragma mark - Macro

#pragma mark > Utility

/**
 Check the edge should move vertically
 
 @param d the edge
 @return YES if should move vertically, NO if should move horizontally
 @discussion the WCGenieAnimationRectEdge should follow the rule:
 top edge: 00 & 01 = 00 !->  YES vertically
 left edge: 01 & 01 = 01 !->  NO vertically
 bottom edge: 10 & 01 = 00 !-> YES vertically
 right edge: 11 & 01 = 01 !-> NO vertically
 */
#define isEdgeMoveVertically(d) (!((d) & 0x01))

/**
 Check the edge is moving `negative`
 The `negative` means ?
 
 @discussion the WCGenieAnimationRectEdge should follow the rule:
 top edge: 00 & 10 = 00 ->  NO
 left edge: 01 & 10 = 00 ->  NO
 bottom edge: 10 & 10 = 10  -> YES
 right edge: 11 & 10 = 11 -> YES
 */
#define isEdgeMoveNegative(d) ((d) & 0x10)

/**
 Check which axis to move for the edge
 
 @param d the edge
 @return the axis of the movement. WCGenieAnimationAxisX for horizontally, WCGenieAnimationAxisY for vertically.
 */
#define movementAxisForEdge(d) ((WCGenieAnimationAxis)isEdgeMoveVertically(d))

/**
 Get the perpendicular axis for the specific axis, e.g. AxisX -> AxisY or AxisY -> AxisX
 
 @return the perpendicular axis
 */
#define perpendicularAxis(a) ((WCGenieAnimationAxis)(!(BOOL)a))

#pragma mark > Constants

// [Original Reference]
/* Antialiasing parameter
 *
 * While there is a visible difference between 0.0 and 1.0 values in kRenderMargin constant, larger values
 * do not seem to provide any significant improvement in edges quality and will decrease performance.
 * The default value works great and you should change it only if you manage to convince yourself
 * that it does bring quality improvement.
 */
#define kSnapshotMargin 2.0

// height of a single horizontal slice
// or width of a single vertical slice
#define kSliceSize 10.0

// assumed animation's FPS
#define kFPS 60.0

// [Original Reference]
/* Animation parameters
 *
 * Genie effect consists of two such subanimations: the curves subanimation and the slide subanimation.
 * There former one moves Bezier curves outlining the effect's shape, while the latter one slides
 * the subject view towards/from the destination/start rect.
 
 * These parameters describe the percentages of progress at which the subanimations should start/end.
 * These values must be in range [0, 1]!
 *
 * Example:
 * Assuming that duration of animation is set to 2 seconds then the curves subanimation will start
 * at 0.0 and will end at 0.8 seconds while the slide subanimation will start at 0.6 seconds and
 * will end at 2.0 seconds.
 */
#define kCurvesAnimationStart 0.0
#define kCurvesAnimationEnd   0.4
#define kSlideAnimationStart  0.3
#define kSlideAnimationEnd    1.0

#pragma mark - Utility Functions

static inline WCGenieAnimationPoint WCGenieAnimationPointMake(double x, double y)
{
    WCGenieAnimationPoint p; p.x = x; p.y = y; return p;
}

static inline WCGenieAnimationSegment WCGenieAnimationSegmentMake(WCGenieAnimationPoint p1, WCGenieAnimationPoint p2)
{
    WCGenieAnimationSegment s; s.p1 = p1; s.p2 = p2; return s;
}

/**
 Get segement for the specific edge, which used for transition
 
 @param edge the edge
 @param rect the rect
 @return the segment
 */
static WCGenieAnimationSegment segmentForTransition(WCGenieAnimationRectEdge edge, CGRect rect)
{
    // Note: segment direction follow the clockwise
    switch (edge) {
        case WCGenieAnimationRectEdgeTop:
        default:
            return WCGenieAnimationSegmentMake(WCGenieAnimationPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)), WCGenieAnimationPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)));
        case WCGenieAnimationRectEdgeRight:
            return WCGenieAnimationSegmentMake(WCGenieAnimationPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)), WCGenieAnimationPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)));
        case WCGenieAnimationRectEdgeBottom:
            return WCGenieAnimationSegmentMake(WCGenieAnimationPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)), WCGenieAnimationPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)));
        case WCGenieAnimationRectEdgeLeft:
            return WCGenieAnimationSegmentMake(WCGenieAnimationPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect)), WCGenieAnimationPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect)));
    }
}

static inline NSString * edgeDescription(WCGenieAnimationRectEdge edge)
{
    NSString *rectEdge[] = {
        [WCGenieAnimationRectEdgeBottom] = @"bottom",
        [WCGenieAnimationRectEdgeTop] = @"top",
        [WCGenieAnimationRectEdgeRight] = @"right",
        [WCGenieAnimationRectEdgeLeft] = @"left",
    };
    
    return rectEdge[edge];
}

#pragma mark -

@implementation WCGenieAnimation

+ (BOOL)genieInTransitionWithView:(UIView *)view duration:(NSTimeInterval)duration destinationRect:(CGRect)destinationRect destinationEdge:(WCGenieAnimationRectEdge)destEdge completion:(void (^)(void))completion {
    return [self genieTransitionWithView:view duration:duration destinationRect:destinationRect edge:destEdge reverse:NO completion:completion];
}

+ (BOOL)genieOutTransitionWithView:(UIView *)view duration:(NSTimeInterval)duration startRect:(CGRect)startRect startEdge:(WCGenieAnimationRectEdge)startEdge completion:(void (^)(void))completion {
    return [self genieTransitionWithView:view duration:duration destinationRect:startRect edge:startEdge reverse:YES completion:completion];
}

#pragma mark -

+ (BOOL)genieTransitionWithView:(UIView *)view duration:(NSTimeInterval)duration destinationRect:(CGRect)destinationRect edge:(WCGenieAnimationRectEdge)edge reverse:(BOOL)reverse completion:(void (^)(void))completion {
    
    if (![view isKindOfClass:[UIView class]] || CGRectIsNull(destinationRect)) {
        return NO;
    }
    
    WCGenieAnimationAxis movementAxis = movementAxisForEdge(edge);
    WCGenieAnimationAxis perpAxis = perpendicularAxis(movementAxis);
    
    view.transform = CGAffineTransformIdentity;
    
    UIImage *snapshot = [self snapshotImageWithView:view forMovementAxis:movementAxis];
    NSArray *slices = [self sliceLayersWithImage:snapshot alongAxis:movementAxis];
    
    CGFloat xInset = movementAxis == WCGenieAnimationAxisY ? -kSnapshotMargin : 0.0;
    CGFloat yInset = movementAxis == WCGenieAnimationAxisX ? -kSnapshotMargin : 0.0;
    
    CGRect marginedDestRect = CGRectInset(destinationRect, xInset * destinationRect.size.width / view.bounds.size.width, yInset * destinationRect.size.height / view.bounds.size.height);
    
    CGFloat endRectDepth = isEdgeMoveVertically(edge) ? marginedDestRect.size.height : marginedDestRect.size.width;
    WCGenieAnimationSegment fromSegment = segmentForTransition(edge, [view convertRect:CGRectInset(view.bounds, xInset, yInset) toView:view.superview]);
    WCGenieAnimationSegment toSegment = segmentForTransition(edge, marginedDestRect);
    
    WCGenieAnimationSegment fromSegment2 = fromSegment;
    fromSegment2.p1.v[movementAxis] = toSegment.p1.v[movementAxis];
    fromSegment2.p2.v[movementAxis] = toSegment.p2.v[movementAxis];
    
    WCGenieAnimationCurve first = { fromSegment.p1, fromSegment2.p1 };
    WCGenieAnimationCurve second = { fromSegment.p2, fromSegment2.p2 };
    
    // View hierarchy setup
    NSString *sumKeyPath = isEdgeMoveVertically(edge) ? @"@sum.bounds.size.height": @"@sum.bounds.size.width";
    CGFloat totalSize = [[slices valueForKeyPath:sumKeyPath] floatValue];
    
    CGFloat sign = isEdgeMoveNegative(edge) ? -1.0 : 1.0;
    if (sign * (fromSegment.p1.v[movementAxis] - toSegment.p1.v[movementAxis]) > 0.0) {
        NSLog(@"Genie Effect ERROR: The distance between %@ edge of animated view and %@ edge of %@ rect is incorrect. Animation will not be performed!", edgeDescription(edge), edgeDescription(edge), reverse ? @"start" : @"destination");
        return NO;
    }
    else if (sign * (fromSegment.p1.v[movementAxis] + sign * totalSize - toSegment.p1.v[movementAxis]) > 0.0) {
        NSLog(@"Genie Effect Warning: The %@ edge of animated view overlaps %@ edge of %@ rect. Glitches may occur.",edgeDescription((edge + 2) % 4), edgeDescription(edge), reverse ? @"start" : @"destination");
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:view.superview.bounds];
    containerView.clipsToBounds = view.superview.clipsToBounds;
    containerView.backgroundColor = [UIColor clearColor];
    [view.superview insertSubview:containerView belowSubview:view];
    
    NSMutableArray *transforms = [NSMutableArray arrayWithCapacity:slices.count];
    
    for (CALayer *layer in slices) {
        [containerView.layer addSublayer:layer];
        
        // With 'Renders with edge antialiasing' = YES in info.plist the slices are
        // rendered with a border, this disables this making the UIView appear as supposed
        layer.edgeAntialiasingMask = 0;
        
        [transforms addObject:[NSMutableArray array]];
    }
    
    BOOL previousHiddenState = view.hidden;
    view.hidden = YES; // hide self throught animation, slices will be shown instead
    
    // Animate frames
    
    NSInteger totalIter = duration * kFPS;
    double tSignShift = reverse ? -1.0 : 1.0;
    for (NSInteger i = 0; i < totalIter; ++i) {
        double progress = ((double)i) / ((double)totalIter - 1.0);
        double t = tSignShift * (progress - 0.5) + 0.5;
        
        
    }
    
    return YES;
}

#pragma mark - Utility Methods

+ (UIImage *)snapshotImageWithView:(UIView *)view forMovementAxis:(WCGenieAnimationAxis)movementAxis {
    CGSize contextSize = view.bounds.size;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;
    
    if (movementAxis == WCGenieAnimationAxisY) {
        xOffset = kSnapshotMargin;
        contextSize.width += 2.0 * kSnapshotMargin;
    }
    else {
        yOffset = kSnapshotMargin;
        contextSize.height += 2.0 * kSnapshotMargin;
    }
    
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Note: make margin vertically or horizontally
    CGContextTranslateCTM(context, xOffset, yOffset);
    
    [view.layer renderInContext:context];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}

+ (NSArray<CALayer *> *)sliceLayersWithImage:(UIImage *)image alongAxis:(WCGenieAnimationAxis)movementAxis {
    
    CGFloat totalSize = movementAxis == WCGenieAnimationAxisY ? image.size.height : image.size.width;
    
    WCGenieAnimationPoint origin = { 0.0, 0.0 };
    // Note: set y if movementAxis is AxisY; set x if movementAxis is AxisX
    origin.v[movementAxis] = kSliceSize;
    
    CGFloat scale = image.scale;
    CGSize sliceSize = movementAxis == WCGenieAnimationAxisY ? CGSizeMake(image.size.width, kSliceSize) : CGSizeMake(kSliceSize, image.size.height);
    
    NSInteger numberOfSlice = (NSInteger)ceil(totalSize / kSliceSize);
    NSMutableArray *slices = [NSMutableArray arrayWithCapacity:numberOfSlice];
    
    for (NSInteger i = 0; i < numberOfSlice; ++i) {
        CGRect sliceRect = {
            i * origin.x * scale,
            i * origin.y * scale,
            sliceSize.width * scale,
            sliceSize.height * scale
        };
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, sliceRect);
        UIImage *sliceImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        
        CALayer *layer = [CALayer layer];
        layer.anchorPoint = CGPointZero;
        layer.bounds = CGRectMake(0.0, 0.0, sliceImage.size.width, sliceImage.size.height);
        layer.contents = (__bridge id)(sliceImage.CGImage);
        layer.contentsScale = image.scale;
        
        [slices addObject:layer];
    }
    
    return slices;
}

@end
