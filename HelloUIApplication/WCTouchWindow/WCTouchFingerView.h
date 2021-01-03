//
//  WCTouchFingerView.h
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/1/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCTouchFingerView : UIView

- (instancetype)initWithPoint:(CGPoint)point;
- (void)updateWithTouch:(UITouch *)touch;

@end

NS_ASSUME_NONNULL_END
