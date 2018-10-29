//
//  WCURLTool+Internal.h
//  HelloNSURL
//
//  Created by wesley_chen on 2018/10/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCURLTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCURLTool ()
+ (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string pattern:(NSString *)pattern;
+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range;
@end

NS_ASSUME_NONNULL_END
