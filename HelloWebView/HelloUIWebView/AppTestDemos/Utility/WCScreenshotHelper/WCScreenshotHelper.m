//
//  WCScreenshotHelper.m
//  HelloCaptureUIView
//
//  Created by chenliang-xy on 15/3/13.
//  Copyright (c) 2015年 chenliang-xy. All rights reserved.
//

#import "WCScreenshotHelper.h"
#import "UIView+StatusBar.h"

#define DEBUG_LOG 1

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation WCScreenshotHelper

#pragma mark - Public Methods

+ (UIImage *)snapshotView:(UIView *)capturedView savedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
	// If capturedView is invalid, return nil
	if (capturedView == nil || capturedView.bounds.size.height == 0 || capturedView.bounds.size.width == 0) {
		return nil;
	}

    UIImage *image = nil;
	if ([capturedView isKindOfClass:[UIWindow class]]) {
		image = [self snapshotUIWindow:(UIWindow *)capturedView withStatusBar:NO];
	}
	else if ([capturedView isKindOfClass:[UIScrollView class]]) {
		image = [self snapshotScrollView:(UIScrollView *)capturedView withFullContent:NO savedToPhotosAlbum:savedToPhotosAlbum];
	}
	else {
        image = [self snapshotUIView:capturedView];
	}
    
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    return image;
}

// Snapshot for window
+ (UIImage *)snapshotWindow:(UIWindow *)capturedWindow savedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [self snapshotUIWindow:capturedWindow withStatusBar:NO];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

// Snapshot full screen
+ (UIImage *)snapshotScreenSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [self snapshotScreenWithStatusBar:YES];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

// Snapshot scroll view with full content or with visible content
+ (UIImage *)snapshotScrollView:(UIScrollView *)capturedScrollView withFullContent:(BOOL)withFullContent savedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [self snapshotUIScrollView:capturedScrollView withFullContent:withFullContent];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

// Snapshot full screen with alert view
+ (UIImage *)snapshotScreenAfterAlertShownSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [self snapshotScreenAfterOtherWindowsShown];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

// Snapshot full screen with action sheet
+ (UIImage *)snapshotScreenAfterActionSheetShownSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [self snapshotScreenAfterOtherWindowsShown];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

#pragma mark - Private Methods

/*!
 *  Only snapshot a UIView
 */
+ (UIImage *)snapshotUIView:(UIView *)capturedView {
    
    UIImage *image = nil;
    CGSize outputSize = capturedView.bounds.size;

    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if ([capturedView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [capturedView drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize} afterScreenUpdates:NO];
        }
        else {
            [capturedView.layer renderInContext:context];
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

/*!
 *  Only snapshot a UIWindow, may not include keyboard, alert view, action sheet and so on
 *
 *  @param capturedWindow   a UIWindow
 *  @param withStatusBar    If YES, the snapshot includes status bar
 */
+ (UIImage *)snapshotUIWindow:(UIWindow *)capturedWindow withStatusBar:(BOOL)withStatusBar {
    
    UIImage *image = nil;
    CGSize outputSize = [UIScreen mainScreen].bounds.size;
    UIView *statusBar = [UIView statusBarInstance];
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if ([capturedWindow respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [capturedWindow drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize} afterScreenUpdates:NO];
        }
        else {
            [capturedWindow.layer renderInContext:context];
        }
        
        if (withStatusBar) {
            [statusBar.layer renderInContext:context];
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

/*!
 *  Only snapshot a UIScrollView
 *
 *  @param capturedScrollView
 *  @param withFullContent    If YES, take snapshot of full content
 */
+ (UIImage *)snapshotUIScrollView:(UIScrollView *)capturedScrollView withFullContent:(BOOL)withFullContent {
	UIImage *image = nil;
    CGSize outputSize = withFullContent ? capturedScrollView.contentSize : capturedScrollView.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (withFullContent) {
            // Saved
            CGPoint savedContentOffset = capturedScrollView.contentOffset;
            CGRect savedFrame = capturedScrollView.frame;
            BOOL savedShowsHorizontalScrollIndicator = capturedScrollView.showsHorizontalScrollIndicator;
            BOOL savedShowsVerticalScrollIndicator = capturedScrollView.showsVerticalScrollIndicator;
            BOOL savedUserInteractionEnabled = capturedScrollView.userInteractionEnabled;
            
            // Adjust frame, contentOffset, hide indicators, and disable user interaction
            capturedScrollView.contentOffset = CGPointZero;
            capturedScrollView.frame = CGRectMake(0, 0, capturedScrollView.contentSize.width, capturedScrollView.contentSize.height);
            capturedScrollView.showsHorizontalScrollIndicator = NO;
            capturedScrollView.showsVerticalScrollIndicator = NO;
            capturedScrollView.userInteractionEnabled = NO;
            
            // Note: not use drawViewHierarchyInRect:afterScreenUpdates: method, because
            // it only draws visible part of UIScrollView even after adjust its size, contentOffset and so on.
            
            [capturedScrollView.layer renderInContext:context];
        
            // Restore
            capturedScrollView.contentOffset = savedContentOffset;
            capturedScrollView.frame = savedFrame;
            capturedScrollView.showsHorizontalScrollIndicator = savedShowsHorizontalScrollIndicator;
            capturedScrollView.showsVerticalScrollIndicator = savedShowsVerticalScrollIndicator;
            capturedScrollView.userInteractionEnabled = savedUserInteractionEnabled;
        }
		else {
			// Saved
			CGPoint savedContentOffset = capturedScrollView.contentOffset;
			BOOL savedShowsHorizontalScrollIndicator = capturedScrollView.showsHorizontalScrollIndicator;
			BOOL savedShowsVerticalScrollIndicator = capturedScrollView.showsVerticalScrollIndicator;
			BOOL savedUserInteractionEnabled = capturedScrollView.userInteractionEnabled;

			// Hide indicators, and disable user interaction
			capturedScrollView.showsHorizontalScrollIndicator = NO;
			capturedScrollView.showsVerticalScrollIndicator = NO;
			capturedScrollView.userInteractionEnabled = NO;

            // Note: not use drawViewHierarchyInRect:afterScreenUpdates: method, because
            // it will draw indicators of UIScrollView even after set indicators hidden.
            
			CGContextTranslateCTM(context, -savedContentOffset.x, -savedContentOffset.y);
			[capturedScrollView.layer renderInContext:context];

			// Restore
			capturedScrollView.showsHorizontalScrollIndicator = savedShowsHorizontalScrollIndicator;
			capturedScrollView.showsVerticalScrollIndicator = savedShowsVerticalScrollIndicator;
			capturedScrollView.userInteractionEnabled = savedUserInteractionEnabled;
		}
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

	return image;
}

/*!
 *  Only snapshot full screen
 *
 *  @param withStatusBar    If YES, the snapshot includes status bar
 */
+ (UIImage *)snapshotScreenWithStatusBar:(BOOL)withStatusBar {
    
    UIImage *image = nil;
    CGSize outputSize = [UIScreen mainScreen].bounds.size;
    UIView *statusBar = [UIView statusBarInstance];
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
                [window drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize} afterScreenUpdates:NO];
            }
            else {
                [window.layer renderInContext:context];
            }
        }
        
        if (withStatusBar) {
            [statusBar.layer renderInContext:context];
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

/*!
 *  Snapshot other windows, such as alert view, action sheet and so on
 */
+ (UIImage *)snapshotScreenAfterOtherWindowsShown {
    UIImage *image = nil;
    CGSize outputSize = [UIScreen mainScreen].bounds.size;
    UIView *statusBar = [UIView statusBarInstance];
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        BOOL hasTakeSnapshot = NO;
        
		for (UIWindow *window in windows) {
#if DEBUG_LOG
			NSLog(@"level: %f", window.windowLevel);
#endif
			if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
				[window drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize }afterScreenUpdates:NO];
			}
			else {
				[window.layer renderInContext:context];
			}

			if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
				NSUInteger indexOfCurrentWindow = [windows indexOfObject:window];
				if (indexOfCurrentWindow + 1 < [windows count]) {
					UIWindow *nextWindow = windows[indexOfCurrentWindow + 1];
					if (!hasTakeSnapshot && nextWindow.windowLevel > UIWindowLevelStatusBar) {
						[statusBar.layer renderInContext:context];
						hasTakeSnapshot = YES;
					}
				}
			}
		}
        
        // Note: alert view and action sheet are NOT added to [UIApplication sharedApplication].windows any more in iOS 7+,
        // and become a solo window which is a keyWindow when shown
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [statusBar.layer renderInContext:context];
            
            if ([[[UIApplication sharedApplication] keyWindow] respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
                [[[UIApplication sharedApplication] keyWindow] drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize } afterScreenUpdates:NO];
            }
            else {
                [[[UIApplication sharedApplication] keyWindow].layer renderInContext:context];
            }
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -

/*!
 *  Place captured image to Documents/test.png. Just for debug and output file
 */
+ (void)debugImageFile:(UIImage *)image {
#if DEBUG_LOG
    if (image != nil) {
        NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        BOOL result = [UIImagePNGRepresentation(image) writeToFile:[documentDirectory stringByAppendingString:@"/test.png"] atomically: YES];
        NSLog(@"result: %@", result ? @"YES" : @"NO");
    }
#endif
}

@end
