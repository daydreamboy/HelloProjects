//
//  NSString+Addition.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 17/11/2017.
//  Copyright © 2017 chenliang-xy. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

- (NSArray *)rangesOfSubstring:(NSString *)substring {
    NSRange searchRange = NSMakeRange(0, self.length);
    NSRange foundRange;
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    while (searchRange.location < self.length) {
        searchRange.length = self.length - searchRange.location;
        foundRange = [self rangeOfString:substring options:kNilOptions range:searchRange];
        
        if (foundRange.location != NSNotFound) {
            // found an occurrence of the substring, and add its range to NSArray
            [arrM addObject:[NSValue valueWithRange:foundRange]];
            
            // move forward
            searchRange.location = foundRange.location + foundRange.length;
        }
        else {
            // no more substring to find
            break;
        }
    }
    
    return arrM;
}

/**
 Calculte text size

 @param width the fixed width
 @param attributes the attributes for the string
 @return the text size
 */
- (CGSize)textSizeForMultipleLineWithWidth:(CGFloat)width attributes:(NSDictionary *)attributes {
    if (width > 0) {
        return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes:attributes
                                  context:nil].size;
    }
    else {
        return CGSizeZero;
    }
}

@end
