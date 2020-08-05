//
//  WCPinYinTable.h
//  HelloNSString
//
//  Created by wesley_chen on 2020/8/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCPinYinTable : NSObject

@property (nonatomic, strong, readonly) NSDictionary<NSNumber *, NSArray<NSString *> *> *unicode2PinYin;

+ (instancetype)sharedInstance;
+ (void)cleanup;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
