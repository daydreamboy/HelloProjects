//
//  ALPHACircleMenuView.m
//
//  Created by Christian Klaproth on 31.08.14.
//  Copyright © 2014 Christian Klaproth. All rights reserved.
//

#import "WCCircularMenuView.h"

@implementation WCCircularMenuViewSetting

+ (instancetype)preset {
    WCCircularMenuViewSetting *setting = [[WCCircularMenuViewSetting alloc] init];
    
    setting.menuButtonNormalColor = [UIColor colorWithRed:0.0 green:0.25 blue:0.5 alpha:1.0];
    setting.menuButtonActiveColor = [UIColor colorWithRed:0.25 green:0.5 blue:0.75 alpha:1.0];
    setting.menuButtonBorderColor = [UIColor whiteColor];
    setting.menuButtonBorderWidth = 2.0;
    setting.menuButtonRadius = 40;
    setting.menuRadius = 65;
    setting.menuMaxAngle = 180.0;
    
    return setting;
}

@end

@interface WCCircularMenuView ()

@property (nonatomic) NSMutableArray<ALPHARoundView *> *buttons;
@property (weak, nonatomic) UIGestureRecognizer* recognizer;
@property (nonatomic) int hoverTag;

@property (nonatomic) UIColor* innerViewColor;
@property (nonatomic) UIColor* innerViewActiveColor;
@property (nonatomic) UIColor* borderViewColor;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat maxAngle;
@property (nonatomic) CGFloat animationDelay;
@property (nonatomic) CGFloat startingAngle;
@property (nonatomic) BOOL depth;
@property (nonatomic) CGFloat buttonRadius;
@property (nonatomic) CGFloat buttonBorderWidth;

@property (nonatomic, weak) UIView* clippingView;

@end

// each button is made up of two views (button image, and background view)
// the buttons get tagged, starting at 1
// components are identified by adding the corresponding offset to the button's logical tag
static int TAG_BUTTON_OFFSET = 100;
static int TAG_INNER_VIEW_OFFSET = 1000;

@implementation WCCircularMenuView

- (id)initWithOptions:(WCCircularMenuViewSetting *)setting {
    self = [super init];
    if (self) {
        self.buttons = [NSMutableArray new];
        if (!setting) {
            setting = [WCCircularMenuViewSetting preset];
        }
        [self updateWithOptions:setting];
    }
    return self;
}

- (id)initWithSetting:(WCCircularMenuViewSetting *)setting atCenter:(CGPoint)center menuButtonImages:(NSArray *)menuButtonImages {
    self = [self initWithOptions:setting];
    if (self) {
        self.frame = CGRectMake(center.x - self.radius - self.buttonRadius, center.y - self.radius - self.buttonRadius, self.radius * 2 + self.buttonRadius * 2, self.radius * 2 + self.buttonRadius * 2);
        int tTag = 1;
        for (UIImage *image in menuButtonImages) {
            ALPHARoundView *tView = [self createButtonViewWithImage:image andTag:tTag];
            [self.buttons addObject:tView];
            tTag++;
        }
    }
    return self;
}

/*
- (id)initWithSettings:(CGPoint)aPoint atOrigin:(NSDictionary *)anOptionsDictionary withImages:(UIImage *)anImage, ...
{
    self = [self initWithOptions:anOptionsDictionary];
    if (self) {
        self.frame = CGRectMake(aPoint.x - self.radius - self.buttonRadius, aPoint.y - self.radius - self.buttonRadius, self.radius * 2 + self.buttonRadius * 2, self.radius * 2 + self.buttonRadius * 2);
        int tTag = 1;
        va_list args;
        va_start(args, anImage);
        for (UIImage* img = anImage; img != nil; img = va_arg(args, UIImage*)) {
            ALPHARoundView *tView = [self createButtonViewWithImage:img andTag:tTag];
            [self.buttons addObject:tView];
            tTag++;
        }
        va_end(args);
    }
    return self;
}
 */

- (void)updateWithOptions:(WCCircularMenuViewSetting *)setting {
    self.innerViewColor = setting.menuButtonNormalColor;
    self.innerViewActiveColor = setting.menuButtonActiveColor;
    self.borderViewColor = setting.menuButtonBorderColor;
    self.depth = setting.menuButtonShowShadow;
    self.buttonRadius = setting.menuButtonRadius;
    self.buttonBorderWidth = setting.menuButtonBorderWidth;
    
    self.animationDelay = setting.menuOpenDuration;
    self.radius = setting.menuRadius;
    self.maxAngle = setting.menuMaxAngle;
    
    switch (setting.menuDirection) {
        case ALPHACircleMenuDirectionUp:
            self.startingAngle = 0.0;
            break;
        case ALPHACircleMenuDirectionRight:
            self.startingAngle = 90.0;
            break;
        case ALPHACircleMenuDirectionDown:
            self.startingAngle = 180.0;
            break;
        case ALPHACircleMenuDirectionLeft:
            self.startingAngle = 270.0;
            break;
    }
    
    if (self.superview) {
        [self calculateButtonPositions];
    }
}

/*!
 * Convenience method that creates a circle button, consisting of
 * the image, a background and a border.
 * @param anImage image to be used as button's icon
 * @param aTag unique identifier (should be index + 1)
 * @return UIView to be used as button
 */
- (ALPHARoundView*)createButtonViewWithImage:(UIImage*)anImage andTag:(int)aTag
{
    UIImage *tintedImage = [anImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIButton* tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tButton.userInteractionEnabled = NO;
    CGFloat width = self.buttonRadius * 0.8;
    CGFloat height = self.buttonRadius * 0.8;
    tButton.frame = CGRectMake( ((self.buttonRadius * 2.0) - width) / 2.0, ((self.buttonRadius * 2.0) - height) / 2.0, width, height);
    [tButton setImage:tintedImage forState:UIControlStateNormal];
    tButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    tButton.tag = aTag + TAG_BUTTON_OFFSET;
    tButton.tintColor = self.borderViewColor;
    
    ALPHARoundView* tInnerView = [[ALPHARoundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.buttonRadius * 2, self.buttonRadius * 2)];
    tInnerView.backgroundColor = self.innerViewColor;
    tInnerView.opaque = YES;
    tInnerView.clipsToBounds = NO;
    tInnerView.layer.cornerRadius = self.buttonRadius;
    tInnerView.layer.borderColor = [self.borderViewColor CGColor];
    tInnerView.layer.borderWidth = self.buttonBorderWidth;

    if (self.depth) {
        [self applyInactiveDepthToButtonView:tInnerView];
    }

    tInnerView.tag = aTag + TAG_INNER_VIEW_OFFSET;
    
    [tInnerView addSubview:tButton];
    
    return tInnerView;
}

/*!
 * Does the math to put buttons on a circle.
 */
- (void)calculateButtonPositions
{
    if (!self.clippingView) {
        // climb view hierarchy up, until first view with clipToBounds = YES
        self.clippingView = [self clippingViewOfChild:self];
    }
    CGFloat tMaxX = self.frame.size.width - self.buttonRadius;
    CGFloat tMinX = self.buttonRadius;
    CGFloat tMaxY = self.frame.size.height - self.buttonRadius;
    CGFloat tMinY = self.buttonRadius;
    if (self.clippingView) {
        CGRect tClippingFrame = [self.clippingView convertRect:self.clippingView.bounds toView:self];
        tMaxX = tClippingFrame.size.width + tClippingFrame.origin.x - self.buttonRadius * 2;
        tMinX = tClippingFrame.origin.x;
        tMaxY = tClippingFrame.size.height + tClippingFrame.origin.y - self.buttonRadius * 2;
        tMinY = tClippingFrame.origin.y;
    }

    int tButtonCount = (int)self.buttons.count;
    CGPoint tOrigin = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat tRadius = self.radius;
    int tCounter = 0;
    for (UIView* tView in self.buttons) {
        CGFloat tCurrentWinkel;
        if (tCounter == 0) {
            tCurrentWinkel = self.startingAngle + 0.0;
        } else if (tCounter > 0 && tCounter < tButtonCount) {
            tCurrentWinkel = self.startingAngle + (self.maxAngle / (tButtonCount)) * tCounter;
        } else {
            tCurrentWinkel = self.startingAngle + self.maxAngle;
        }
        CGSize tSize = tView.frame.size;
        CGFloat tX = tOrigin.x - (tRadius * cosf(tCurrentWinkel / 180.0 * M_PI)) - (tSize.width / 2);
        CGFloat tY = tOrigin.y - (tRadius * sinf(tCurrentWinkel / 180.0 * M_PI)) - (tSize.width / 2);
        
        if (tX > tMaxX) tX = tMaxX;
        if (tX < tMinX) tX = tMinX;
        if (tY > tMaxY) tY = tMaxY;
        if (tY < tMinY) tY = tMinY;
        
        CGRect tRect = CGRectMake(tX, tY, tSize.width, tSize.height);
        tView.frame = tRect;
        tCounter++;
    }
}

/*!
 * Climbs up the view hierarchy to find the first which has clipToBounds = YES.
 * Returns the topmost view if no view has clipsToBound set to YES.
 * @return UIView with clipToBounds = YES
 */
- (UIView*)clippingViewOfChild:(UIView*)aView
{
    UIView* tView = [aView superview];
    if (tView) {
        if (tView.clipsToBounds) {
            return tView;
        } else {
            return [self clippingViewOfChild:tView];
        }
    } else {
        return aView;
    }
}

- (void)openMenuWithTapGesture:(UIGestureRecognizer *)tapGesture {
    self.recognizer = tapGesture;
    // use target action to get notified upon gesture changes
    [tapGesture addTarget:self action:@selector(handleTapGesture:)];
 
    CGPoint tOrigin = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self calculateButtonPositions];
    for (UIView* tButtonView in self.buttons) {
        [self addSubview:tButtonView];
        tButtonView.alpha = 0.0;
        CGFloat tDiffX = tOrigin.x - tButtonView.frame.origin.x - self.buttonRadius;
        CGFloat tDiffY = tOrigin.y - tButtonView.frame.origin.y - self.buttonRadius;
        tButtonView.transform = CGAffineTransformMakeTranslation(tDiffX, tDiffY);
    }

    CGFloat tDelay = 0.0;
    for (UIView* tButtonView in self.buttons) {
        tDelay = tDelay + self.animationDelay;
        [UIView animateWithDuration:0.6 delay:tDelay usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            tButtonView.alpha = 1.0;
            tButtonView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(circleMenuDidOpened:)]) {
                [self.delegate circleMenuDidOpened:self];
            }
        }];
    }
}

/*!
 * Performs the closing animation.
 */
- (void)closeMenu {
    [self.recognizer removeTarget:self action:@selector(handleTapGesture:)];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        for (UIView* tButtonView in self.buttons) {
            if (self.hoverTag > 0 && self.hoverTag == [self bareTagOfView:tButtonView]) {
                tButtonView.transform = CGAffineTransformMakeScale(1.8, 1.8);
            }
            tButtonView.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(circleMenuDidClosed:)]) {
            [self.delegate circleMenuDidClosed:self];
        }
    }];
}

- (void)gestureMovedToPoint:(CGPoint)aPoint
{
    UIView* tView = [self hitTest:aPoint withEvent:nil];
    int tTag = [self bareTagOfView:tView];
    if (tTag > 0) {
        if (tTag == self.hoverTag) {
            // this button is already the active one
            return;
        }
        else
        {
            // Animate previous button back to identity
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView animateWithDuration:0.1 animations:^
            {
                UIView* tInnerView = [self viewWithTag:self.hoverTag];
                tInnerView.transform = CGAffineTransformIdentity;
                
                [self sendSubviewToBack:tInnerView];
            }];
        }
        
        self.hoverTag = tTag;
        
        // display all (other) buttons in normal state
        [self resetButtonState];
        
        // display this button in active color
        tTag = tTag + TAG_INNER_VIEW_OFFSET;
        UIView* tInnerView = [self viewWithTag:tTag];
        tInnerView.backgroundColor = self.innerViewActiveColor;
        
        
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.1 animations:^
        {
            [self bringSubviewToFront:tInnerView];
            tInnerView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        
        if (self.depth) {
            [self applyActiveDepthToButtonView:tInnerView];
        }
    } else {
        // the view "hit" is none of the buttons -> display all in normal state
        [self resetButtonState];        
        self.hoverTag = 0;
    }
    
    if ([self.delegate respondsToSelector:@selector(circleMenuHoverOnButtonWithIndex:)])
    {
        [self.delegate circleMenuHoverOnButtonWithIndex:tTag - 1 - TAG_INNER_VIEW_OFFSET];
    }
}

- (void)resetButtonState
{
    if (self.hoverTag > 0)
    {
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.1 animations:^
        {
            UIView* tInnerView = [self viewWithTag:self.hoverTag];
            tInnerView.transform = CGAffineTransformIdentity;
            [self sendSubviewToBack:tInnerView];
        }];
    }
    
    for (int i = 1; i <= self.buttons.count; i++) {
        UIView* tView = [self viewWithTag:i + TAG_INNER_VIEW_OFFSET];
        tView.backgroundColor = self.innerViewColor;
        if (self.depth) {
            [self applyInactiveDepthToButtonView:tView];
        }
        
        tView.transform = CGAffineTransformIdentity;
        
        [self bringSubviewToFront:tView];
    }
}

- (void)applyInactiveDepthToButtonView:(UIView*)aView
{
    aView.layer.shadowColor = [[UIColor blackColor] CGColor];
    aView.layer.shadowOffset = CGSizeMake(4,2);
    aView.layer.shadowRadius = 8;
    aView.layer.shadowOpacity = 0.35;
    aView.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (void)applyActiveDepthToButtonView:(UIView*)aView
{
    aView.layer.shadowColor = [[UIColor blackColor] CGColor];
    aView.layer.shadowOffset = CGSizeMake(2,1);
    aView.layer.shadowRadius = 5;
    aView.layer.shadowOpacity = 0.42;
    aView.layer.affineTransform = CGAffineTransformMakeScale(0.985, 0.985);
}

/*!
 * Target action method that gets called when the gesture used to open
 * the ALPHACircleMenuView changes.
 */
- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
//    if (sender.state == UIGestureRecognizerStateChanged) {
//        CGPoint tPoint = [sender locationInView:self];
//        [self gestureMovedToPoint:tPoint];
//    } else if (sender.state == UIGestureRecognizerStateEnded) {
//
//        //[self closeMenu];
//    }
    
    // determine wether a button was hit when the gesture ended
    CGPoint tPoint = [sender locationInView:self];
    UIView* tView = [self hitTest:tPoint withEvent:nil];
    int tTag = [self bareTagOfView:tView];
    if (tTag > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(circleMenuActivatedButtonWithIndex:)]) {
            [self.delegate circleMenuActivatedButtonWithIndex:tTag-1];
        }
    }
}

/*!
 * Return the 'virtual' tag of the button, no matter which of its components
 * (image, background, border) is passed as argument.
 * @param aView view to be examined
 * @return 'virtual' tag without offsets
 */
- (int)bareTagOfView:(UIView*)aView
{
    int tTag = (int)aView.tag;
    if (tTag > 0) {
        if (tTag >= TAG_INNER_VIEW_OFFSET) {
            tTag = tTag - TAG_INNER_VIEW_OFFSET;
        }
        if (tTag >= TAG_BUTTON_OFFSET) {
            tTag = tTag - TAG_BUTTON_OFFSET;
        }
    }
    return tTag;
}

#pragma mark -

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *buttonView in self.buttons) {
        CGPoint pointForTargetView = [buttonView convertPoint:point fromView:self];
        UIView *hitView = [buttonView hitTest:pointForTargetView withEvent:event];
        
        if (hitView) {
            return hitView;
        }
    }

    return nil;
}

@end

@implementation ALPHARoundView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    // Pythagoras a^2 + b^2 = c^2
    CGFloat tRadius = self.bounds.size.width / 2;
    CGFloat tDiffX = tRadius - point.x;
    CGFloat tDiffY = tRadius - point.y;
    CGFloat tDistanceSquared = tDiffX * tDiffX + tDiffY * tDiffY;
    CGFloat tRadiusSquared = tRadius * tRadius;
    return tDistanceSquared < tRadiusSquared;
}

@end
