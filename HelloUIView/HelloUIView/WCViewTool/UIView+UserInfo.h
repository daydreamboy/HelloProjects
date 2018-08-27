//
//  UIView+UserInfo.h
//  HelloUIView
//
//  Created by wesley_chen on 2018/8/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UserInfo)
/**
 Attatch an associated user object to the view. Usually used for UIAlertView or UIActionSheet
 */
@property (nonatomic, strong) id associatedUserObject;

/**
 Set a pair of key-value in associatedUserInfo which is attached to the view.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *associatedUserInfo;

/**
 Set a pair of key-value in associatedWeakUserInfo which is attached to the view. And the value is weakly hold
 */
@property (nonatomic, strong, readonly) NSMapTable *associatedWeakUserInfo;
@end
