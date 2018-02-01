//
//  AttachedBubbleBaseViewController.h
//  HelloCoreGraphics
//
//  Created by wesley_chen on 12/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCAttachedBubbleView.h"

@interface AttachedBubbleBaseViewController : UIViewController
@property (nonatomic, strong) WCAttachedBubbleView *bubbleView1PlacedByFrame;
@property (nonatomic, strong) WCAttachedBubbleView *bubbleView2PlacedByArrowPosition;
@property (nonatomic, strong) WCAttachedBubbleView *bubbleView3WithShadow;
@property (nonatomic, strong) WCAttachedBubbleView *bubbleView4WithconstrainedRectInMainScreen;

- (WCAttachedBubbleView *)bubbleView1WithArrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection;
- (WCAttachedBubbleView *)bubbleView2WithArrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection;
- (WCAttachedBubbleView *)bubbleView3WithArrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection;
- (WCAttachedBubbleView *)bubbleView4WithArrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection;

@end
