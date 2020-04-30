//
//  WCMirroringTapGestureRecognizer.h
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/4/29.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCMirroringTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, weak, readonly) UITapGestureRecognizer *mirroredTapGestureRecognizer;

- (instancetype)initWithTarget:(id)target action:(SEL)action mirroredTapGestureRecognizer:(UITapGestureRecognizer *)mirroredTapGestureRecognizer;

@end

NS_ASSUME_NONNULL_END
