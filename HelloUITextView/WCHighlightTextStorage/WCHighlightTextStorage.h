//
//  WCHighlightTextStorage.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCHighlightTextStorage : NSTextStorage

- (instancetype)initWithPattern:(NSString *)pattern highlightAttributes:(NSDictionary *)highlightAttributes;

@end

NS_ASSUME_NONNULL_END
