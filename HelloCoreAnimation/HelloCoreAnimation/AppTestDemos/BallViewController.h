//
//  BallViewController.h
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/4.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JumpingText.h"

@interface BallViewController : UIViewController

@property (nonatomic, strong) JumpingText *jumpingText;

- (void)scatterLetters;
- (CAShapeLayer *)animatedBall;
- (CATextLayer *)animatedLetter;

@end
