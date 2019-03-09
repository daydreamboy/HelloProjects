//
//  WCMacroToolBackend.h
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/3/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCMacroToolBackend : NSObject

/**
 Get an array from va_list

 @param ap the va_list
 @return the NSArray
 @discussion If the va_list is nil, will return an empty array
 */
+ (NSArray *)arrayFromVaList:(va_list)ap;

@end

NS_ASSUME_NONNULL_END
