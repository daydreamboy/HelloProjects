//
//  UndefinedSymbols.h
//  LinkAllUndefinedSymbols
//
//  Created by wesley_chen on 2021/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern void foo(int);

FOUNDATION_EXPORT NSString *bar;

@interface UndefinedSymbols : NSObject

- (void)foo;
+ (void)bar;

@end

NS_ASSUME_NONNULL_END
