//
//  CardViewControler.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/2.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "CardViewControler.h"

static CGPoint midPoint(CGRect r) {
    return CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
}

// Deprecated: Because can't move the position of the camera
/*
static CATransform3D CATransform3DMakePerspective(CGFloat z) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1. / z;
    return t;
}
*/

/*!
 *  Without restoration of the center
 *
 *  @warning Just for demo, and it's wrong
 */
static CATransform3D CATransform3DMakePerspectiveWithoutRestore(CGFloat offsetX, CGFloat offsetY, CGFloat disZ) {
    CATransform3D translationOfCenter = CATransform3DMakeTranslation(-offsetX, -offsetY, 0);
    CATransform3D translationOfZ = CATransform3DIdentity;
    translationOfZ.m34 = -1.0f / disZ;
    return CATransform3DConcat(translationOfCenter, translationOfZ);
}

/*!
 *  Coupled with CATransform3DMakePerspectiveWithoutRestore function
 *
 *  @warning Just for demo, and it's wrong
 */
static CATransform3D CATransform3DPerspectWithoutRestore(CATransform3D t, CGFloat offsetX, CGFloat offsetY, float disZ) {
    return CATransform3DConcat(t, CATransform3DMakePerspectiveWithoutRestore(offsetX, offsetY, disZ));
}

#pragma mark -

//#define kDisZ (900)
#define kDisZ (-900)

/*!
 *  Make perspective with placing the camera in 3D space
 *
 *  @param offsetX the offset x of the camera
 *  @param offsetY the offset y of the camera
 *  @param disZ    the distance of the camera from the screen. If negative, z axis pointed from the screen. If positive, z axis pointed to the screen.
 */
static CATransform3D CATransform3DMakePerspective(CGFloat offsetX, CGFloat offsetY, CGFloat disZ) {
	CATransform3D translationOfCenter = CATransform3DMakeTranslation(-offsetX, -offsetY, 0);
	CATransform3D restorationOfCenter = CATransform3DMakeTranslation(offsetX, offsetY, 0);
	CATransform3D translationOfZ = CATransform3DIdentity;
	translationOfZ.m34 = -1.0f / disZ;
	return CATransform3DConcat(CATransform3DConcat(translationOfCenter, translationOfZ), restorationOfCenter);
}

/*!
 *  Coupled with CATransform3DMakePerspective function
 *
 *  @see CATransform3DMakePerspective
 */
static CATransform3D CATransform3DPerspect(CATransform3D t, CGFloat offsetX, CGFloat offsetY, float disZ) {
	return CATransform3DConcat(t, CATransform3DMakePerspective(offsetX, offsetY, disZ));
}

#pragma mark -

@interface CardViewControler ()

@property (nonatomic, strong) CALayer *spadeAce;
@property (nonatomic, assign) BOOL flipped;
@property CATransform3D transform;

@property (nonatomic, strong) UISegmentedControl *selectionForAxis;
@property (nonatomic, strong) UISegmentedControl *selectionForPosOfCamera;

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CardViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Add perspective for the rotation, so the near thing is bigger and the far thing is smaller
    // Make all sublayers using this transform
    /*
    self.view.layer.sublayerTransform = CATransform3DMakePerspective(0, 0, -300);
    */
    
    _spadeAce = [CALayer layer];
    _spadeAce.bounds = CGRectMake(0, 0, 190, 280);
    _spadeAce.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGFloat components[4] = {0.4, 0.8, 1, 0.6};
    CGColorRef cardBackColor = CGColorCreate(space, components);
    _spadeAce.backgroundColor = cardBackColor;
    CGColorRelease(cardBackColor);
    _spadeAce.opaque = NO;
    _spadeAce.borderWidth = 5;
    _spadeAce.borderColor = [UIColor darkGrayColor].CGColor;
    _spadeAce.cornerRadius = 5.0;
    [self.view.layer addSublayer:_spadeAce];
    
    // Add middle pip
    CAShapeLayer *centerPip = [self spadePip];
    centerPip.position = midPoint(_spadeAce.bounds);
    [_spadeAce addSublayer:centerPip];
    
    CGFloat components2[4] = {0.1, 0.1, 0.1, 0.98};
    CGColorRef almostBlack = CGColorCreate(space, components2);
    CGColorSpaceRelease(space);
    
    // Add top pip
    CATextLayer *A = [CATextLayer layer];
    A.string = @"A";
    A.bounds = CGRectMake(0, 0, 30, 24);
    A.foregroundColor = almostBlack;
    A.position = CGPointMake(26, 20);
    A.fontSize = 26;
    [_spadeAce addSublayer:A];
    CGColorRelease(almostBlack);
    
    CAShapeLayer *indexTop = [self spadePip];
    indexTop.position = CGPointMake(20, 44);
    indexTop.transform = CATransform3DMakeScale(0.5, 0.5, 1);
    [_spadeAce addSublayer:indexTop];
    
    // Add bottom pip
    A = [[CATextLayer alloc] init];
    A.string = @"A";
    A.bounds = CGRectMake(0, 0, 30, 24);
    A.foregroundColor = almostBlack;
    A.position = CGPointMake(CGRectGetMaxX(_spadeAce.bounds) - 26, CGRectGetMaxY(_spadeAce.bounds) - 20);
    A.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    A.fontSize = 26;
    [_spadeAce addSublayer:A];
    
    // Combine two tranforms
    CATransform3D tranform = CATransform3DMakeScale(0.5, 0.5, 1);
    tranform = CATransform3DRotate(tranform, M_PI, 0, 0, 1);
    
    CAShapeLayer *indexBottom = [self spadePip];
    indexBottom.position = CGPointMake(CGRectGetMaxX(_spadeAce.bounds) - 20, CGRectGetMaxY(_spadeAce.bounds) - 44);
    indexBottom.transform = tranform;
    [_spadeAce addSublayer:indexBottom];
    
    // Add actions
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    // Add label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, screenSize.width - 20, 30)];
    label.text = @"Rotate 60° clockwise by";
    [self.view addSubview:label];
    
    CGFloat spacing = 5;
    CGFloat spacing2 = 10;
    
    // Add segmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"x axis", @"y axis", @"z axis", @"x & y axis"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.frame = CGRectMake(20, CGRectGetMaxY(label.frame) + spacing, screenSize.width - 2 * 20, 30);
    [segmentedControl addTarget:self action:@selector(indexDidChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    _selectionForAxis = segmentedControl;
    
    // Add label
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(segmentedControl.frame) + spacing2, screenSize.width - 20, 30)];
    label2.text = @"Choose position of the camera:";
    [self.view addSubview:label2];
    
    // Add segmentedControl
    UISegmentedControl *segmentedControl2 = [[UISegmentedControl alloc] initWithItems:@[@"None", @"Default", @"Top-Left", @"No restore"]];
    segmentedControl2.selectedSegmentIndex = 0;
    segmentedControl2.frame = CGRectMake(20, CGRectGetMaxY(label2.frame) + spacing, screenSize.width - 2 * 20, 30);
    [segmentedControl2 addTarget:self action:@selector(indexDidChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl2];
    _selectionForPosOfCamera = segmentedControl2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, CGRectGetMaxY(_spadeAce.frame) + 80, screenSize.width - 2 * 20, 30);
    [button setTitle:@"Rotate card by y axis" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self indexDidChanged:_selectionForAxis]; // init _transform
    [self indexDidChanged:_selectionForPosOfCamera]; // make initial perspective
}

- (CAShapeLayer *)spadePip {
    CAShapeLayer *spade = [[CAShapeLayer alloc] init];
    spade.bounds = CGRectMake(0, 0, 48, 64);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint p1, p2, p3;
    p1 = CGPointMake(24, 15);
    p2 = CGPointMake(4, 10);
    p3 = CGPointMake(4, 30);
    CGPathMoveToPoint(path, NULL, 24, 4);
    CGPathAddCurveToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    
    p1 = CGPointMake(4, 40);
    p2 = CGPointMake(14, 50);
    p3 = CGPointMake(22, 40);
    CGPathAddCurveToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    
	p3 = CGPointMake(9, 60);
	CGPathAddLineToPoint(path, NULL, p3.x, p3.y);
    
	p3 = CGPointMake(39, 60);
	CGPathAddLineToPoint(path, NULL, p3.x, p3.y);
	
    p3 = CGPointMake(26, 40);
	CGPathAddLineToPoint(path, NULL, p3.x, p3.y);
    
    // Now reverse the two curves above
    p2 = CGPointMake(44, 40);
    p1 = CGPointMake(34, 50);
    p3 = CGPointMake(44, 30);
    CGPathAddCurveToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    
    p2 = CGPointMake(24, 15);
    p1 = CGPointMake(44, 10);
    p3 = CGPointMake(24, 2);
    CGPathAddCurveToPoint(path, NULL, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    
    CGPathCloseSubpath(path);
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGFloat components[4] = {0.1, 0.1, 0.1, 0.98};
    CGColorRef almostBlack = CGColorCreate(space, components);
    
    spade.fillColor = almostBlack;
    spade.path = path;
    CGPathRelease(path);
    CGColorSpaceRelease(space);
    CGColorRelease(almostBlack);
    
    return spade;
}

#pragma mark - Actions

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    
    if (_animating) {
        return;
    }
    
    if (_flipped) {
        [CATransaction setAnimationDuration:1];
        _spadeAce.transform = CATransform3DIdentity;
    }
    else {
        [CATransaction setAnimationDuration:3];
        _spadeAce.transform = _transform;
    }
    _flipped = !_flipped;
}

- (void)indexDidChanged:(UISegmentedControl *)segmentedControl {
    
    if (_animating) {
        return;
    }
    
    // Always init _transform
    switch (_selectionForAxis.selectedSegmentIndex) {
        case 0: {
            // positive for clockwise
            _transform = CATransform3DMakeRotation(M_PI / 3, 1, 0, 0);
            break;
        }
        case 1: {
            _transform = CATransform3DMakeRotation(M_PI / 3, 0, 1, 0);
            break;
        }
        case 2: {
            _transform = CATransform3DMakeRotation(M_PI / 3, 0, 0, 1);
            break;
        }
        case 3: {
            // negative for counterclockwise
            _transform = CATransform3DMakeRotation(1.2, -1, -1, 0);
            break;
        }
        default:
            break;
    }
    
    // Modify _transform by choice
    switch (_selectionForPosOfCamera.selectedSegmentIndex) {
        case 0:
            // Do nothing for perspective
            break;
        case 1:
            _transform = CATransform3DPerspect(_transform, 0, 0, kDisZ);
            break;
        case 2:
            _transform = CATransform3DPerspect(_transform, -CGRectGetWidth(_spadeAce.bounds) / 2.0, -CGRectGetHeight(_spadeAce.bounds) / 2.0, kDisZ);
            break;
        case 3:
            _transform = CATransform3DPerspectWithoutRestore(_transform, -CGRectGetWidth(_spadeAce.bounds) / 2.0, -CGRectGetHeight(_spadeAce.bounds) / 2.0, kDisZ);
            break;
        default:
            break;
    }
}

- (void)buttonClicked:(UIButton *)sender {
    
    if (_animating) {
        _spadeAce.transform = CATransform3DIdentity;
        [_timer invalidate];
        _timer = nil;
    }
    else {
        
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateRotation:) userInfo:nil repeats:YES];
        }
    }
    _animating = !_animating;
}

- (void)updateRotation:(NSTimer *)timer {
    static float angle = 0;
    angle += 0.05f;
    
    CATransform3D translationOfZ = CATransform3DMakeTranslation(0, 0, 200); // place at z axis
    CATransform3D rotation = CATransform3DMakeRotation(angle, 0, 1, 0); // rotate by y axis clockwise
    CATransform3D t = CATransform3DConcat(rotation, translationOfZ);
    _spadeAce.transform = CATransform3DPerspect(t, 0, 0, kDisZ);
}

@end

