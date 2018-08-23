//
//  BallViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/4.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "BallViewController.h"
#import "BallDelegate.h"
#import "JumpingText.h"

// Positive random number in this range
static CGFloat randomNumber(CGFloat min, CGFloat max) {
	return (((CGFloat)random()) / ((CGFloat)RAND_MAX)) * (max - min) + min;
}

#pragma mark -

@interface BallViewController ()
@property (nonatomic, strong) CAShapeLayer *ball;
@property (nonatomic, strong) BallDelegate *ballDelegate;
@property (nonatomic, strong) CATextLayer *oneLetterOfJumpingText;
@end

@implementation BallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - statusBarHeight - navBarHeight);
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _ballDelegate = [[BallDelegate alloc] init];
    _ballDelegate.parent = self;
    
    _ball = [CAShapeLayer layer];
    _ball.bounds = CGRectMake(0, 0, 60, 60);
    _ball.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(_ball.bounds));
    _ball.delegate = _ballDelegate; // Assign a delegate
    [_ball setNeedsDisplay]; // Ask its delegate to draw its content
    [self.view.layer addSublayer:_ball];
    
    _jumpingText = [[JumpingText alloc] init];
    [_jumpingText addTextLayersTo:self.view.layer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)dealloc {
    [_jumpingText removeTextLayers];
}

#pragma mark - Public methods

- (void)scatterLetters {
    CGFloat animationTime = 5;
    
    // Delayed frade
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @(1);
    fade.toValue = @(0);
    fade.duration = animationTime - 2;
    fade.beginTime = 2;
    
    for (CALayer *letter in _jumpingText) {
        CGFloat x = randomNumber(0, CGRectGetMaxX(self.view.bounds));
        CGFloat y = randomNumber(0, CGRectGetMaxY(self.view.bounds));
        
        CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
        move.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        move.duration = animationTime;

        CAAnimationGroup *moveAndVanish = [CAAnimationGroup animation];
        moveAndVanish.animations = @[fade, move];
        moveAndVanish.duration = animationTime;
        moveAndVanish.removedOnCompletion = NO;
        moveAndVanish.fillMode = kCAFillModeForwards;
        moveAndVanish.delegate = _ballDelegate;
        [letter addAnimation:moveAndVanish forKey:@"letterScatted"];
        
        // store last letter
        _oneLetterOfJumpingText = (CATextLayer *)letter;
    }
}

- (CAShapeLayer *)animatedBall {
    return _ball;
}

- (CATextLayer *)animatedLetter {
    return _oneLetterOfJumpingText;
}

#pragma mark - Actions

- (void)viewTapped:(UITapGestureRecognizer *)tapRecognizer {
	UIView *tappedView = tapRecognizer.view;
	if (tappedView == self.view) {
		CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position.y"];
		move.duration = 2;
		// Take the radius of the ball into account when computing the strike point
		move.toValue = @([_jumpingText topOfString] - CGRectGetHeight(_ball.bounds) / 2);
		move.delegate = _ballDelegate;
        move.removedOnCompletion = NO;
		[_ball addAnimation:move forKey:@"bowl"];
	}
}

@end
