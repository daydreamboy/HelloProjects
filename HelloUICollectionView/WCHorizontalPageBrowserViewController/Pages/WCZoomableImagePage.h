//
//  WCZoomableImagePage.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCBaseHorizontalPage.h"

@class WCZoomableImagePage;

@protocol WCZoomableImagePageDelegate <NSObject>
- (void)WCZoomableImagePage:(WCZoomableImagePage *)page imageViewDidLongPressed:(UIImageView *)imageView;;
@end

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
@property (nonatomic, weak) id<WCZoomableImagePageDelegate> delegate;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)displayImage:(UIImage *)image;
- (void)resetZoomableImagePage;
- (void)startActivityIndicatorView;
- (void)stopActivityIndicatorView;
- (void)resetPage;

@end
