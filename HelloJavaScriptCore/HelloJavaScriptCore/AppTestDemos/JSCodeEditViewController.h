//
//  JSCodeEditViewController.h
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSCodeEditViewController : UIViewController
@property (nonatomic, strong) NSString *JSCodeString;
@property (nonatomic, copy) void (^runBlock)(NSString *JSCode);
@end

NS_ASSUME_NONNULL_END
