//
//  BorderedTextView.h
//  HelloCoreText
//
//  Created by wesley_chen on 14/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSTextBorder : NSObject
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) UIEdgeInsets paddings;
@end

UIKIT_EXTERN const NSAttributedStringKey NSBorderAttributeName;

@interface BorderedTextView : UIView
@property (nonatomic, strong) NSAttributedString *attrString;
@end
