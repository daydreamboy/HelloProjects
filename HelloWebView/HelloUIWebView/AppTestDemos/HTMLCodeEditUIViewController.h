//
//  HTMLCodeEditUIViewController.h
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMLCodeEditUIViewController : UIViewController
@property (nonatomic, strong) NSString *HTMLCodeString;
@property (nonatomic, copy) void (^runBlock)(NSString *JSCode);
@end

NS_ASSUME_NONNULL_END
