//
//  WCPinYinTable+Testing.h
//  HelloNSString
//
//  Created by wesley_chen on 2020/8/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCPinYinTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCPinYinTable (Testing)
+ (NSString *)createMarkedVowelPinYinWithPinYin:(NSString *)pinYin tone:(NSInteger)tone;
@end

NS_ASSUME_NONNULL_END
