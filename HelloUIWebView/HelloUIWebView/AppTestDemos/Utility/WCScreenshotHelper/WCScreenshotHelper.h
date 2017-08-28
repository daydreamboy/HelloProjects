//
//  WCScreenshotHelper.h
//  HelloCaptureUIView
//
//  Created by chenliang-xy on 15/3/13.
//  Copyright (c) 2015年 chenliang-xy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCScreenshotHelper : NSObject

+ (UIImage *)snapshotView:(UIView *)capturedView savedToPhotosAlbum:(BOOL)savedToPhotosAlbum;
+ (UIImage *)snapshotWindow:(UIWindow *)capturedWindow savedToPhotosAlbum:(BOOL)savedToPhotosAlbum;
+ (UIImage *)snapshotScrollView:(UIScrollView *)capturedScrollView withFullContent:(BOOL)withFullContent savedToPhotosAlbum:(BOOL)savedToPhotosAlbum;

+ (UIImage *)snapshotScreenSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum;
+ (UIImage *)snapshotScreenAfterAlertShownSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum;
+ (UIImage *)snapshotScreenAfterActionSheetShownSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum;

@end
