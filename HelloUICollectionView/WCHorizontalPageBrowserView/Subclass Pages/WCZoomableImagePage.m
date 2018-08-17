//
//  WCZoomableImagePage.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCZoomableImagePage.h"

@interface WDKImageZoomView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;

/**
 If scale to fit the screen size when image original size is smaller than the screen size
 
 Default is NO
 */
@property (nonatomic, assign) BOOL scaleToFit;

- (void)displayImage:(UIImage *)image;
- (void)resetImageZoomView;

@end


@implementation WDKImageZoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInset = UIEdgeInsetsZero;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTapped:)];
        _doubleTapGesture.numberOfTapsRequired = 2;
    }
    return self;
}

- (void)displayImage:(UIImage *)image {
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    self.zoomScale = 1.0;
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:self.doubleTapGesture];
    [self addSubview:self.imageView];
    
    [self configureForImageSize:image.size];
    [self centerImageView];
}

- (void)resetImageZoomView {
    [self setZoomScale:self.minimumZoomScale animated:NO];
}

#pragma mark -

- (void)configureForImageSize:(CGSize)imageSize {
    CGSize boundSize = self.bounds.size;
    
    // set up our content size and min/max zoomscale
    CGFloat xScale = boundSize.width / imageSize.width;     // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundSize.height / imageSize.height;   // the scale needed to perfectly fit the image height-wise
    
    CGFloat minScale = MIN(xScale, yScale); // use minimum of these to allow the image to become fully visible
    CGFloat maxScale = MAX(MAX(xScale, yScale), 1.0);
    
    // don't let minScale exceed maxScale.
    self.contentSize = imageSize;
    
    // if the image is smaller than the screen, we don't want to force it to be zoomed.
    if (!self.scaleToFit && (imageSize.width < boundSize.width && imageSize.height < boundSize.height)) {
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = MAX(minScale, 1.0);
        self.zoomScale = 1.0;
    }
    else {
        if (minScale > maxScale) {
            minScale = maxScale;
        }
        
        self.maximumZoomScale = maxScale;
        self.minimumZoomScale = minScale;
        self.zoomScale = minScale; // start out with the content fully visible
    }
}

- (void)centerImageView {
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2.0;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2.0;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    
    self.imageView.frame = frameToCenter;
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the WDKImageZoomView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width = self.frame.size.width / scale;
    
    // set origin by moving the touching point (`center`) to left cornert point
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // scrollViewDidZoom: method behaviors as scrollViewDidScroll: method
    
    // when zooming in, the width/height of contentSize exceed the width/height of fixed bounds, the offsetX/offsetY is 0.0,
    // so self.imageView is always centered in scrollView
    
    // when zooming out, offsetX/offsetY is positive, refresh the center of imageView which maybe not centered in scrollView
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - Actions

- (void)imageViewDoubleTapped:(UITapGestureRecognizer *)recognizer {
    UIView *zoomView = recognizer.view;
    
    // toggle zooming to maximum scale or minimum scale
    CGFloat newScale = (self.maximumZoomScale - self.zoomScale < 0.000001 ? self.minimumZoomScale : self.maximumZoomScale);
    
    // calculate the rect to zoom
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[recognizer locationInView:zoomView]];
    [self zoomToRect:zoomRect animated:YES];
}

@end

@interface WCZoomableImagePage ()
@property (nonatomic, strong) WDKImageZoomView *imageZoomView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@end

@implementation WCZoomableImagePage

#pragma mark - Public Methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageZoomView = [[WDKImageZoomView alloc] initWithFrame:self.pageContentView.bounds];
        [self.pageContentView addSubview:_imageZoomView];
        
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewLongPressed:)];
        [_imageZoomView addGestureRecognizer:_longPressGesture];
    }
    return self;
}

- (void)displayImage:(UIImage *)image {
    _imageZoomView.scaleToFit = self.scaleToFit;
    [_imageZoomView displayImage:image];
}

- (void)resetZoomableImagePage {
    [_imageZoomView resetImageZoomView];
}

- (UITapGestureRecognizer *)doubleTapGesture {
    return _imageZoomView.doubleTapGesture;
}

- (void)imageViewLongPressed:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
//        if ([self.delegate respondsToSelector:@selector(MPMZoomableImagePage:imageViewDidLongPressed:)]) {
//
//            WDKImageZoomView *view = (WDKImageZoomView *)recognizer.view;
//            [self.delegate MPMZoomableImagePage:self imageViewDidLongPressed:view.imageView];
//        }
    }
}

@end
