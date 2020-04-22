//
//  HTMLCodePreviewWKViewController.h
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/4/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMLCodePreviewWKViewController : UIViewController
- (instancetype)initWithHTMLString:(NSString *)HTMLString fileName:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
