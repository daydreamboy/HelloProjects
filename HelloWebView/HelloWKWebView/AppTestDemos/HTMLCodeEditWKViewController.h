//
//  HTMLCodeEditWKViewController.h
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMLCodeEditWKViewController : UIViewController
@property (nonatomic, strong) NSString *HTMLCodeString;
@property (nonatomic, copy) void (^runBlock)(NSString *JSCode);
@end

NS_ASSUME_NONNULL_END
