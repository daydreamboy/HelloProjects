//
//  WCZoomableImagePage.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCBaseHorizontalPage.h"

@interface WCZoomableImagePage : WCBaseHorizontalPage

/**
 If scale to fit the screen size when image original size is smaller than the screen size
 
 Default is NO
 */
@property (nonatomic, assign) BOOL scaleToFit;

/**
 The gesture for double tapping to zoom in
 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGesture;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)displayImage:(UIImage *)image;
- (void)resetZoomableImagePage;
@end
