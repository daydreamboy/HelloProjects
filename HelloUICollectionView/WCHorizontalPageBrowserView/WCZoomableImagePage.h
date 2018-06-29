//
//  WCZoomableImagePage.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCBaseHorizontalPage.h"

@interface WCZoomableImagePage : WCBaseHorizontalPage
- (instancetype)initWithFrame:(CGRect)frame;
- (void)displayImage:(UIImage *)image;
@end
