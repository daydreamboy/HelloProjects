//
//  WCToolbarTool.h
//  HelloUIToolbar
//
//  Created by wesley_chen on 2020/6/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCToolbarTool : NSObject

/**
 Get the frame of UIBarButtonItem of the tool bar
 
 @param toolbar toolbar
 @param barButtonItem barButtonItem
 
 @return Return CGRectZero, if not found the barButtonItem
 @discussion In iOS 6 and 5, the height of frame (UIButton) is NOT equal to the height of UIToolbar
            <br/> In iOS 7+, the height of frame (UIToolbarButton) is equal to the height of UIToolbar, so its origin.y is always 0.
 @see http://stackoverflow.com/questions/8231737/how-to-determine-position-of-uibarbuttonitem-in-uitoolbar
 @see http://stackoverflow.com/questions/14163099/how-can-i-get-the-frame-of-a-uibarbuttonitem
 */
+ (CGRect)frameForBarButtonItemWithToolbar:(UIToolbar *)toolbar barButtonItem:(UIBarButtonItem *)barButtonItem;

@end

NS_ASSUME_NONNULL_END
