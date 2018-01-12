//
//  AttachedBubbleWithUpArrowViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 12/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AttachedBubbleWithUpArrowViewController.h"

@interface AttachedBubbleWithUpArrowViewController ()
@end

@implementation AttachedBubbleWithUpArrowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bubbleView1PlacedByFrame = [super bubbleView1WithArrowDirection:WCAttachedBubbleArrowDirectionUp];
    [self.view addSubview:self.bubbleView1PlacedByFrame];
    
    self.bubbleView2PlacedByArrowPosition = [super bubbleView2WithArrowDirection:WCAttachedBubbleArrowDirectionUp];
    [self.view addSubview:self.bubbleView2PlacedByArrowPosition];
    
    self.bubbleView3WithShadow = [super bubbleView3WithArrowDirection:WCAttachedBubbleArrowDirectionUp];
    [self.view addSubview:self.bubbleView3WithShadow];
}

@end
