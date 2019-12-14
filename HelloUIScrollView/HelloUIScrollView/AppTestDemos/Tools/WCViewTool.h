//
//  WCViewTool.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/12/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCViewTool : NSObject

@end

@interface WCViewTool ()

/**
 Adjust the frame of the view to fit its all subviews

 @param superView the super view whose frame should fit its all subviews and it expect to has at less one subview
 @return YES if the operation is success. NO if the view has no subviews.
 @see https://stackoverflow.com/a/21107340
 */
+ (BOOL)makeViewFrameToFitAllSubviewsWithSuperView:(UIView *)superView;

@end



NS_ASSUME_NONNULL_END
