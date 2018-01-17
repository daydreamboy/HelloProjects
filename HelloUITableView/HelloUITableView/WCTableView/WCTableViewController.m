//
//  WCTableViewController.m
//  Finance360
//
//  Created by chenliang-xy on 15/7/21.
//  Copyright (c) 2015年 qihoo. All rights reserved.
//

#import "WCTableViewController.h"
#import "UITableView+Addition.h"

#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface UIView (ViewHierarchy)
- (BOOL)ancestralViewIsKindOfClass:(Class)cls;
@end

@implementation UIView (ViewHierarchy)

/*!
 *  Check it and itself all ancestor views `isKindOfClass`
 *
 *  @param cls the Class type wanted to search
 *
 *  @return YES, if found its first ancestor view belong to cls. <br/>NO, if all ancestor views not belong to cls
 */
- (BOOL)ancestralViewIsKindOfClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return YES;
    }
    else {
        UIView *view = self.superview;
        while (view && ![view isKindOfClass:cls]) {
            view = view.superview;
        }
        if ([view isKindOfClass:cls]) {
            return YES;
        }
        return NO;
    }
}

@end

@interface WCTableViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITextField *focusedTextField;
@end

@implementation WCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Note: subclass don't need to assgin delegate itself
    _delegate = self;
    _autoScrollToFocusedTextField = IOS7_OR_LATER ? NO : YES;
    _hideKeyboardWhenBackgroundTapped = YES;
    
    _tableView = [[WCTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerCellClass:nil];
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tap.delegate = self;
    [_tableView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow__:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide__:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditing__:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange__:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource (Default)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // Use CGFLOAT_MIN instead of 0 (0 will use default height)
    // http://stackoverflow.com/questions/17699831/how-to-change-height-of-grouped-uitableview-header
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Use CGFLOAT_MIN instead of 0 (0 will use default height)
    // http://stackoverflow.com/questions/17699831/how-to-change-height-of-grouped-uitableview-header
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [UIView new];
    
    return sectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *sectionHeaderView = [UIView new];
    
    return sectionHeaderView;
}

#pragma mark - Notification

- (void)keyboardWillShow__:(NSNotification *)notification {
    
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGSize size = self.view.frame.size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    _tableView.frame = CGRectMake(0, 0, size.width, size.height - keyboardHeight);
    
    if (_focusedTextField) {
        NSIndexPath *indexPath = [_tableView indexPathForRowContainsSubview:_focusedTextField];
        if (indexPath) {
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        else {
            CGRect visibleRect = [_tableView convertRect:_focusedTextField.bounds fromView:_focusedTextField];
            [_tableView scrollRectToVisible:visibleRect animated:YES];
        }
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide__:(NSNotification *)notification {
    CGSize size = self.view.frame.size;
    
    // http://stackoverflow.com/questions/18957476/ios-7-keyboard-animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];

    _tableView.frame = CGRectMake(0, 0, size.width, size.height);
    
    [UIView commitAnimations];
}

/*!
 *  Move to the focused UITextField visible
 *
 *  @param notification
 *  @warning iOS 6- available
 */
- (void)textFieldTextDidBeginEditing__:(NSNotification *)notification {
    
    if (_autoScrollToFocusedTextField) {
        // iOS 7+ has the feature that UITableView automatically scroll to the focused UITextField,
        // so iOS 6- add this feature here
        UITextField *textField = [notification object];
        [self scrollToVisibleWithTextField:textField];
    }
}

- (void)textFieldTextDidChange__:(NSNotification *)notification {
    UITextField *textField = [notification object];
    
    CGRect rectInTableView = [_tableView convertRect:textField.bounds fromView:textField];
    BOOL visibleInTableView = CGRectContainsRect(_tableView.bounds, rectInTableView);
    
    if (!visibleInTableView) {
        [self scrollToVisibleWithTextField:textField];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:_tableView] && _hideKeyboardWhenBackgroundTapped) {
        
        if ([_delegate respondsToSelector:@selector(tableViewShouldEndEditingWhenBeginTouchView:)]) {
            if (![_delegate tableViewShouldEndEditingWhenBeginTouchView:touch.view]) {
                return NO;
            }
        }
        
        // By default, touch in cell will not trigger gestureRecognizerShouldBegin: method,
        // but trigger tableView:didSelectRowAtIndexPath: method so call endEditing:/resignFirstResponder if need in tableView:didSelectRowAtIndexPath: method
        if ([touch.view ancestralViewIsKindOfClass:[UITableViewCell class]]) {
            return NO;
        }
        
        // By default, touch in UITextField won't hide keyboard
        if ([touch.view ancestralViewIsKindOfClass:[UITextField class]]) {
            return NO;
        }
        
        // By default, touch in UITextView won't hide keyboard
        if ([touch.view ancestralViewIsKindOfClass:[UITextView class]]) {
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [_tableView endEditing:YES];
    
    // Abort touch event forwarding, won't trigger tableView:didSelectRowAtIndexPath: method
    return YES;
}

#pragma mark - Private Methods

- (void)scrollToVisibleWithTextField:(UITextField *)textField {
    if ([textField isKindOfClass:[UITextField class]] && [textField isDescendantOfView:_tableView]) {
        
        NSIndexPath *indexPath = [_tableView indexPathForRowContainsSubview:textField];
        if (indexPath) {
            _focusedTextField = textField;
            // UITableViewScrollPositionNone same as UITableViewScrollPositionTop
            // UITableViewScrollPositionNone is not accurate, use UITableViewScrollPositionMiddle instead
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else {
            _focusedTextField = textField;
            CGRect visibleRect = [_tableView convertRect:textField.bounds fromView:textField];
            [_tableView scrollRectToVisible:visibleRect animated:YES];
        }
    }
}

@end
