//
//  WCReferringRange.m
//  HelloNSData
//
//  Created by wesley_chen on 2020/6/4.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCReferringRange.h"

@interface WCReferringRange ()
@property (nonatomic, readwrite) NSNumber *locationNumber;
@property (nonatomic, readwrite) NSNumber *lengthNumber;
@property (nonatomic, readwrite) NSNumber *locationReferToIndexNumber;
@property (nonatomic, readwrite) NSNumber *lengthReferToIndexNumber;
@property (nonatomic, readwrite) NSNumber *referValueExpectedSize;
@end

@implementation WCReferringRange

+ (instancetype)referringRangeWithLocationNumber:(nullable NSNumber *)locationNumber lengthNumber:(nullable NSNumber *)lengthNumber locationReferToIndexNumber:(nullable NSNumber *)locationReferToIndexNumber lengthReferToIndexNumber:(nullable NSNumber *)lengthReferToIndexNumber referValueExpectedSize:(nullable NSNumber *)referValueExpectedSize {
    WCReferringRange *range = [[WCReferringRange alloc] init];
    range.locationNumber = locationNumber;
    range.lengthNumber = lengthNumber;
    range.locationReferToIndexNumber = locationReferToIndexNumber;
    range.lengthReferToIndexNumber = lengthReferToIndexNumber;
    range.referValueExpectedSize = referValueExpectedSize;
    
    return range;
}

#pragma mark - Getter

- (NSUInteger)location {
    return [self.locationNumber unsignedIntegerValue];
}

- (NSUInteger)length {
    return [self.lengthNumber unsignedIntegerValue];
}

@end
