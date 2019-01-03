//
//  NSString+Exp.h
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Exp)

- (NSString *)exp_characterStringAtIndex:(NSNumber *)index;
- (NSString *)exp_concatString:(NSString *)anotherString;
- (NSString *)exp_uppercase;
- (NSNumber *)exp_length;

@end
