//
//  WCReferringRange.h
//  HelloNSData
//
//  Created by wesley_chen on 2020/6/4.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCReferringRange : NSObject
@property (nonatomic, readonly) NSUInteger location;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSNumber *locationNumber;
@property (nonatomic, readonly) NSNumber *lengthNumber;
@property (nonatomic, readonly) NSNumber *locationReferToIndexNumber;
@property (nonatomic, readonly) NSNumber *lengthReferToIndexNumber;
@property (nonatomic, readonly) NSNumber *referValueExpectedSize;

+ (instancetype)referringRangeWithLocationNumber:(nullable NSNumber *)locationNumber lengthNumber:(nullable NSNumber *)lengthNumber locationReferToIndexNumber:(nullable NSNumber *)locationReferToIndex lengthReferToIndexNumber:(nullable NSNumber *)lengthReferToIndex referValueExpectedSize:(nullable NSNumber *)referValueExpectedSize;

@end

#define ReferringRangeValue(loc, len, locRef, lenRef, refValueSize) ([WCReferringRange referringRangeWithLocationNumber:(loc) lengthNumber:(len) locationReferToIndexNumber:(locRef) lengthReferToIndexNumber:(lenRef) referValueExpectedSize:(refValueSize)])

NS_ASSUME_NONNULL_END
