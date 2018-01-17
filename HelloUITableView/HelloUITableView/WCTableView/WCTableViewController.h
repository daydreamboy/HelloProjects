//
//  WCTableViewController.h
//  Finance360
//
//  Created by chenliang-xy on 15/7/21.
//  Copyright (c) 2015年 qihoo. All rights reserved.
//

//#import "BaseViewController.h"
#import "WCTableView.h"

@protocol WCTableViewControllerDelegate <NSObject>

@optional
/*!
 *  Should let WCTableViewController automatically end editing session
 *
 *  @param touchView The view in which the touch initially occurred, maybe need to check its super view
 *
 *  @return YES, if let WCTableViewController automatically end editing session. <br/>NO, handle editing session in this delegate method
 */
- (BOOL)tableViewShouldEndEditingWhenBeginTouchView:(UIView *)touchView;

@end

@interface WCTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WCTableViewControllerDelegate>
@property (nonatomic, strong) WCTableView *tableView;
/*!
 *  If subclass not assigns delegate, the delegate is itself by default
 */
@property (nonatomic, weak) id<WCTableViewControllerDelegate> delegate;
/*!
 *  Available iOS 6-
 *
 *  Default is YES
 */
@property (nonatomic, assign) BOOL autoScrollToFocusedTextField;
/*!
 *  Hide keyboard by tapping background view of `tableView` if YES
 *
 *  Default is YES
 *  @warning If YES, by default click cells will not hide keyboard
 */
@property (nonatomic, assign) BOOL hideKeyboardWhenBackgroundTapped;

@end
