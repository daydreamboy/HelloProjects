//
//  WCNavigationBar.h
//  HelloUINavigationBar
//
//  Created by wesley_chen on 2018/12/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCNavigationBar : UINavigationBar

/**
 Allow UIBarButtonSystemItemFixedSpace has negative width.
 Default is NO.
 @discussion This property works only on iOS 11+. On iOS 10-, system allows UIBarButtonSystemItemFixedSpace has negative width.
 */
@property (nonatomic, assign) BOOL allowBarButtonSystemItemFixedSpaceNegativeWidth;
@end

NS_ASSUME_NONNULL_END
