//
//  WCStringTool.h
//  HelloUIImage
//
//  Created by wesley_chen on 2020/6/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCStringTool : NSObject

+ (NSString *)prettySizeWithMemoryBytes:(unsigned long long)memoryBytes;

@end

NS_ASSUME_NONNULL_END
