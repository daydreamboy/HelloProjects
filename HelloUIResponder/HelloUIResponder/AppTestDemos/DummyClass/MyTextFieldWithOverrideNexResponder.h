//
//  MyTextField.h
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTextFieldWithOverrideNexResponder : UITextField
@property (nonatomic, weak) UIResponder *overrideNextResponder;
@end

NS_ASSUME_NONNULL_END
