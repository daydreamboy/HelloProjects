//
//  WCPopoverView.h
//  
//
//  Created by wesley chen on 2017/6/14.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCPopoverViewDescriptor : NSObject
@property (nonatomic, assign) float boxPadding;
@property (nonatomic, assign) BOOL autoDismissWhenTapOutside;
@property (nonatomic, assign) float autoDismissAfterSeconds; // <=0 for never auto dismiss
@property (nonatomic, assign) float arrowWidth;
@property (nonatomic, assign) float arrowHeight;
@property (nonatomic, assign) float showDuration;
@property (nonatomic, assign) float dismissDuration;
@end

@interface WCPopoverView : UIView

+ (WCPopoverView *)showAlwaysAbovePopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView;
+ (WCPopoverView *)showAlwaysAbovePopoverAtPoint:(CGPoint)point inView:(UIView *)view withContentView:(UIView *)cView withDescriptor:(WCPopoverViewDescriptor *)descriptor;

- (void)dismiss:(BOOL)animated;

@end
