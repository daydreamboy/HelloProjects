//
//  WCCircularMenuController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/7/26.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "WCCircularMenuController.h"
#import "WCPannedView.h"
#import "WCCircularMenuView.h"

@interface WCCircularMenuController () <WCPannedViewDelegate, ALPHACircleMenuDelegate>
@property (nonatomic, strong) WCPannedView *pannedView;
@property (nonatomic, strong) WCCircularMenuView *menuView;
@property (nonatomic, assign) CGPoint startCenter;

@property (nonatomic) CGFloat angle;
@property (nonatomic) CGFloat delay;
@property (nonatomic) int shadow;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat buttonRadius;
@property (nonatomic) int direction;

@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) UIColor *buttonSelectedBackgroundColor;
@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, assign) BOOL menuOpened;

@end

@implementation WCCircularMenuController

- (instancetype)init {
    self = [super init];
    if (self) {
        _menuEntrySide = 50.0;
        
        self.delay = 0.6;
        self.buttonRadius = 26.0;
        self.shadow = 0;
        self.radius = 80.0;
        self.angle = 90.0;
        self.buttonBackgroundColor = [UIColor blackColor];
        self.buttonSelectedBackgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        self.tintColor = [UIColor yellowColor];
    }
    return self;
}

- (BOOL)addCircleMenuToView:(UIView *)view atPoint:(CGPoint)center {
    if (![view isKindOfClass:[UIView class]]) {
        return NO;
    }
    
    _startCenter = center;

    [self.pannedView addToView:view];
    
    return YES;
}

#pragma mark - Getter

- (WCPannedView *)pannedView {
    if (!_pannedView) {
        CGFloat side = _menuEntrySide;
        WCPannedView *view = [[WCPannedView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        view.center = self.startCenter;
        view.delegate = self;
        
        view.backgroundView.layer.cornerRadius = side / 2.0;
        view.backgroundView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        
        _pannedView = view;
    }
    
    return _pannedView;
}

#pragma mark - WCPannedViewDelegate

- (void)pannedViewTapped:(WCPannedView *)pannedView {
    if (pannedView == self.pannedView) {
        
        if (!self.menuOpened) {
            self.menuOpened = YES;
            CGPoint center = CGPointMake(pannedView.bounds.size.width / 2.0, pannedView.bounds.size.height / 2.0);

            self.menuView = [[WCCircularMenuView alloc] initWithSetting:[self menuSetting] atCenter:center menuButtonImages:self.images];
            self.menuView.delegate = self;
            self.menuView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
            
            pannedView.touchThroughSubview = self.menuView;
            [pannedView addSubview:self.menuView];
            
            [self updateContextPosition];
            [self.menuView openMenuWithTapGesture:pannedView.tapGesture];
        }
        else {
            self.menuOpened = NO;
            [self.menuView closeMenu];
        }
    }
}

- (void)pannedViewDragBegin:(WCPannedView *)pannedView {
    [self updateContextPosition];
}

- (void)pannedViewDragMoving:(WCPannedView *)pannedView {
    [self updateContextPosition];
}

- (void)pannedViewDragEnd:(WCPannedView *)pannedView {
    [self updateContextPosition];
}

- (void)pannedViewDragCanelled:(WCPannedView *)pannedView {
    [self updateContextPosition];
}

#pragma mark - ALPHACircleMenuDelegate

- (void)circleMenuDidOpened:(WCCircularMenuView *)circleMenuView {
    
}
/*!
 * Informs the delegate that the menu is going to be closed with
 * the button specified by the index being activated.
 */
- (void)circleMenuActivatedButtonWithIndex:(int)anIndex {
    
}

/*!
 *  Informs the delegate that the menu hovered on button with index.
 *
 *  @param anIndex index of button
 */
- (void)circleMenuHoverOnButtonWithIndex:(int)anIndex {
    
}
/*!
 * Gets called when the CircleMenu has been closed. This is usually
 * sent immediately after circleMenuActivatedButtonWithIndex:.
 */
- (void)circleMenuDidClosed:(WCCircularMenuView *)circleMenuView {
    
}

#pragma mark - Update menu angle

- (void)updateContextPosition
{
    CGFloat radius = self.radius + self.buttonRadius;
    
    CGFloat cx = self.pannedView.center.x;
    CGFloat cy = self.pannedView.center.y;
    CGFloat restrictedWidth = self.pannedView.superview.bounds.size.width;
    CGFloat restrictedHeight = self.pannedView.superview.bounds.size.height;
    
    WCCircularMenuViewDirection axisXClosestBorder = WCCircularMenuViewDirectionLeft;
    CGFloat axisXDistance = cx;
    
    if (restrictedWidth / 2.0 < cx) {
        axisXClosestBorder = WCCircularMenuViewDirectionRight;
        axisXDistance = restrictedWidth - cx;
    }
    
    WCCircularMenuViewDirection axisYClosestBorder = WCCircularMenuViewDirectionUp;
    CGFloat axisYDistance = cy;
    
    if (restrictedHeight / 2.0 < cy) {
        axisYClosestBorder = WCCircularMenuViewDirectionDown;
        axisYDistance = restrictedHeight - cy;
    }
    
    CGPoint topRight = CGPointMake(restrictedWidth, 0.0);
    CGPoint bottomRight = CGPointMake(restrictedWidth, restrictedHeight);
    CGPoint topLeft = CGPointZero;
    CGPoint bottomLeft = CGPointMake(0.0, restrictedHeight);
    
    CGPoint menuCenter = self.pannedView.center;
    
    NSArray *pointsLeft = [self pointsAtIntersectWithLineFromOrigin:topLeft toTarget:bottomLeft withCenter:menuCenter withRadius:radius];
    NSArray *pointsRight = [self pointsAtIntersectWithLineFromOrigin:topRight toTarget:bottomRight withCenter:menuCenter withRadius:radius];
    
    NSArray* pointsTop = [self pointsAtIntersectWithLineFromOrigin:topLeft toTarget:topRight withCenter:menuCenter withRadius:radius];
    
    NSArray* pointsBottom = [self pointsAtIntersectWithLineFromOrigin:bottomLeft toTarget:bottomRight withCenter:menuCenter withRadius:radius];
    
    CGFloat leftAngle = [self checkAndCalculateAngleBetweenPoints:pointsLeft center:menuCenter];
    CGFloat rightAngle = [self checkAndCalculateAngleBetweenPoints:pointsRight center:menuCenter];
    CGFloat topAngle = [self checkAndCalculateAngleBetweenPoints:pointsTop center:menuCenter];
    CGFloat bottomAngle = [self checkAndCalculateAngleBetweenPoints:pointsBottom center:menuCenter];
    
    //NSLog(@"Left: %f", leftAngle);
    //NSLog(@"Right: %f", rightAngle);
    //NSLog(@"Top: %f", topAngle);
    //NSLog(@"Bottom: %f", bottomAngle);
    
    //
    // Calculate available angle
    //
    
    CGFloat totalAngle = 90.0;
    
    /*
    totalAngle -= ( (90.0 - leftAngle) * 2.0);
    totalAngle -= ( (90.0 - rightAngle) * 2.0);
    totalAngle -= ( (90.0 - topAngle) * 2.0);
    totalAngle -= ( (90.0 - bottomAngle) * 2.0);
     */
    
    //
    // Factorizes angle because of menu buttons extending.
    //
    CGFloat angleModifier = 1.0;
    
    //
    // Set menu to open in correct way
    //
    
    if (leftAngle < 90.0 && topAngle < 90.0)
    {
        self.direction = WCCircularMenuViewDirectionDown;
        
        totalAngle += leftAngle + topAngle;
        
        angleModifier = 0.85;
    }
    else if (leftAngle < 90.0 && bottomAngle < 90.0)
    {
        self.direction = WCCircularMenuViewDirectionRight;
        
        totalAngle += leftAngle + bottomAngle;
        
        angleModifier = 0.85;
    }
    else if (rightAngle < 90.0 && topAngle < 90.0)
    {
        self.direction = WCCircularMenuViewDirectionLeft;
        
        totalAngle += rightAngle + topAngle;
        
        angleModifier = 0.85;
    }
    else if (rightAngle < 90.0 && bottomAngle < 90.0)
    {
        self.direction = WCCircularMenuViewDirectionUp;
        
        totalAngle += rightAngle + bottomAngle;
        
        angleModifier = 0.85;
    }
    else if (rightAngle < 90.0)
    {
        self.direction = WCCircularMenuViewDirectionLeft;
        
        totalAngle = 360.0 - (2 * (90.0 - rightAngle));
        
        //angleModifier = 0.95;
    }
    else if (leftAngle < 90.0)
    {
        self.direction = WCCircularMenuViewDirectionRight;
        
        totalAngle = 360.0 - (2 * (90.0 - leftAngle));
        
        //angleModifier = 0.95;
    }
    else if (topAngle < 90.0)
    {
        self.direction = WCCircularMenuViewDirectionDown;
        
        totalAngle = 360.0 - (2 * (90.0 - topAngle));
        
        //angleModifier = 0.95;
    }
    else if (bottomAngle < 90.0)
    {
        totalAngle = 360.0 - (2 * (90.0 - bottomAngle));
        
        //angleModifier = 0.95;
        
        self.direction = WCCircularMenuViewDirectionUp;
    }
    else
    {
        totalAngle = 360.0;
        
        //self.direction = WCCircularMenuViewDirectionUp;
    }
    
    totalAngle *= angleModifier;
    
    self.angle = totalAngle;
    
    //NSLog(@"Total: %f", totalAngle);
    
//    [self bringSubviewToFront:self.centerView];
//
//    [UIView animateWithDuration:0.2 animations:^{
//        [self.circleMenuView updateWithOptions:[self optionsDictionary]];
//    }];
    
    [self.menuView updateWithSetting:[self menuSetting]];
}

- (WCCircularMenuViewSetting *)menuSetting {
    WCCircularMenuViewSetting *setting = [WCCircularMenuViewSetting preset];
    
    setting.menuOpenDuration = self.delay;
    setting.menuMaxAngle = self.angle;
    setting.menuRadius = self.radius;
    setting.menuDirection = self.direction;
    setting.menuButtonShowShadow = self.shadow;
    setting.menuButtonRadius = self.buttonRadius;
    setting.menuButtonBorderWidth = 2.5;
    setting.menuButtonNormalColor = self.buttonBackgroundColor;
    setting.menuButtonActiveColor = self.buttonSelectedBackgroundColor;
    setting.menuButtonBorderColor = self.tintColor;
    
    return setting;
}

- (NSArray<UIImage *> *)images {
    NSMutableArray *images = [NSMutableArray array];
    
    [images addObject:[UIImage imageNamed:@"Touch"]];
    [images addObject:[UIImage imageNamed:@"Snapshot"]];
    [images addObject:[UIImage imageNamed:@"Network"]];
    [images addObject:[UIImage imageNamed:@"Inspect"]];
    [images addObject:[UIImage imageNamed:@"Menu"]];
    [images addObject:[UIImage imageNamed:@"Close"]];
    
    return images;
}

#pragma mark - Math (refactor to Haystack later on)

- (CGFloat)checkAndCalculateAngleBetweenPoints:(NSArray *)points center:(CGPoint)center
{
    if (points.count == 2)
    {
        NSArray *angles = [self anglesBetweenPointA:[points[0] CGPointValue] pointB:[points[1] CGPointValue] pointC:center];
        
        return [[angles firstObject] doubleValue];
    }
    
    return 90.0;
}

- (NSArray *)pointsAtIntersectWithLineFromOrigin:(CGPoint)origin toTarget:(CGPoint)target withCenter:(CGPoint)center withRadius:(double)radius
{
    CGFloat euclideanAtoB = sqrt(pow(target.x - origin.x, 2.0) + pow(target.y - origin.y, 2.0));
    
    CGVector d = CGVectorMake( (target.x - origin.x) / euclideanAtoB, (target.y - origin.y) / euclideanAtoB);
    
    CGFloat t = (d.dx * (center.x - origin.x)) + (d.dy * (center.y - origin.y));
    
    CGPoint e = CGPointZero;
    
    e.x = (t * d.dx) + origin.x;
    e.y = (t * d.dy) + origin.y;
    
    CGFloat euclideanCtoE = sqrt(pow(e.x - center.x, 2.0) + pow(e.y - center.y, 2.0));
    
    if (euclideanCtoE < radius)
    {
        CGFloat dt = sqrt (pow(radius, 2.0) - pow(euclideanCtoE, 2.0));
        
        CGPoint f = CGPointZero;
        f.x = ((t - dt) * d.dx) + origin.x;
        f.y = ((t - dt) * d.dy) + origin.y;
        
        CGPoint g = CGPointZero;
        g.x = ((t + dt) * d.dx) + origin.x;
        g.y = ((t + dt) * d.dy) + origin.y;

        NSMutableArray *points = [NSMutableArray array];
        
        [points addObject:[NSValue valueWithCGPoint:f]];
        [points addObject:[NSValue valueWithCGPoint:g]];
        
        if (![self point:f isOnLineFromPointA:origin toPointB:target])
        {
           
        }
        
        if (![self point:g isOnLineFromPointA:origin toPointB:target])
        {
            
        }
        
        return [points copy];
    }
    else if (fabs(euclideanCtoE - radius) < DBL_EPSILON)
    {
        return @[];
    }
    
    return nil;
}
    
- (CGFloat)distanceFromPoint:(CGPoint)a toPointB:(CGPoint)b
{
    return sqrt(pow(a.x - b.x, 2.0) + pow(a.y - b.y, 2.0));
}

- (BOOL)point:(CGPoint)c isOnLineFromPointA:(CGPoint)a toPointB:(CGPoint)b
{
    return [self distanceFromPoint:a toPointB:c] + [self distanceFromPoint:c toPointB:b] == [self distanceFromPoint:a toPointB:b];
}

- (NSArray *)anglesBetweenPointA:(CGPoint)a pointB:(CGPoint)b pointC:(CGPoint)c
{
    CGFloat angleAB = atan2(b.y - a.y, b.x - a.x);
    CGFloat angleAC = atan2(c.y - a.y, c.x - a.x);
    CGFloat angleBC = atan2(b.y - c.y, b.x - c.x);
    
    CGFloat angleA = fabs((angleAB - angleAC) * (180 / M_PI));
    CGFloat angleB = fabs((angleAB - angleBC) * (180 / M_PI));
    
    return @[ @(angleA), @(angleB) ];
}

@end
