//
//  AttachedBubbleWithRightArrowViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 12/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AttachedBubbleWithRightArrowViewController.h"

@interface AttachedBubbleWithRightArrowViewController ()

@end

@implementation AttachedBubbleWithRightArrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bubbleView1PlacedByFrame = [super bubbleView1WithArrowDirection:WCAttachedBubbleArrowDirectionRight];
    [self.view addSubview:self.bubbleView1PlacedByFrame];
    
    self.bubbleView2PlacedByArrowPosition = [super bubbleView2WithArrowDirection:WCAttachedBubbleArrowDirectionRight];
    [self.view addSubview:self.bubbleView2PlacedByArrowPosition];
    
    self.bubbleView3WithShadow = [super bubbleView3WithArrowDirection:WCAttachedBubbleArrowDirectionRight];
    [self.view addSubview:self.bubbleView3WithShadow];
}

@end
