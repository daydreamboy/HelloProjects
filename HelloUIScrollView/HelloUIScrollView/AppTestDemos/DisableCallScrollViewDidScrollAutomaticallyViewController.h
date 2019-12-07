//
//  DisableCallScrollViewDidScrollAutomaticallyViewController.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/12/7.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IViewControllerInitOption.h"

// NSNumber(BOOL)
#define kOptionDisableAutoCallScrollViewDidScroll @"kOptionDisableAutoCallScrollViewDidScroll"

NS_ASSUME_NONNULL_BEGIN

@interface DisableCallScrollViewDidScrollAutomaticallyViewController : UIViewController <IViewControllerInitOption>

- (instancetype)initWithOptions:(NSDictionary *)options;

@end

NS_ASSUME_NONNULL_END
