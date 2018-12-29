//
//  WCExpression+Testing.h
//  HelloNSScanner
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCExpression.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCExpression ()
- (NSArray<NSString *> *)tokenizeWithFormatString:(NSString *)string;
- (nullable id)evaluateWithTokens:(NSArray<NSString *> *)tokens variables:(id)variables;
@end

NS_ASSUME_NONNULL_END
