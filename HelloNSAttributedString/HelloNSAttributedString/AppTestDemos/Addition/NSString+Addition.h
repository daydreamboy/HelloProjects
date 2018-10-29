//
//  NSString+Addition.h
//  HelloNSAttributedString
//
//  Created by wesley_chen on 17/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Addition)
- (NSArray *)rangesOfSubstring:(NSString *)substring;
- (CGSize)textSizeForMultipleLineWithWidth:(CGFloat)width attributes:(NSDictionary *)attributes NS_AVAILABLE_IOS(7_0);
@end
