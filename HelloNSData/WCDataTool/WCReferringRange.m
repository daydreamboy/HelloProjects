//
//  WCReferringRange.m
//  HelloNSData
//
//  Created by wesley_chen on 2020/6/4.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCReferringRange.h"

@implementation WCRangeLocationRefer

+ (instancetype)locationReferWithReferringRange:(WCReferringRange *)referringRange referMode:(WCReferringRangeReferMode)referMode relative:(WCRangeLocationRelative)relative offset:(NSInteger)offset {
    WCRangeLocationRefer *object = [[WCRangeLocationRefer alloc] init];
    object.referringRange = referringRange;
    object.referMode = referMode;
    object.relative = relative;
    object.offset = offset;
    
    return object;
}

@end

@implementation WCRangeLengthRefer

+ (instancetype)lengthReferWithReferringRange:(WCReferringRange *)referringRange expectedSize:(NSUInteger)expectedSize {
    WCRangeLengthRefer *object = [[WCRangeLengthRefer alloc] init];
    object.referringRange = referringRange;
    object.expectedSize = expectedSize;
    
    return object;
}

@end

@interface WCReferringRange ()
@property (nonatomic, readwrite) NSNumber *locationNumber;
@property (nonatomic, readwrite) NSNumber *lengthNumber;
@property (nonatomic, readwrite, nullable) WCRangeLocationRefer *locationRefer;
@property (nonatomic, readwrite, nullable) WCRangeLengthRefer *lengthRefer;
@end

@implementation WCReferringRange

+ (instancetype)referringRangeWithLocationNumber:(nullable NSNumber *)locationNumber lengthNumber:(nullable NSNumber *)lengthNumber locationRefer:(nullable WCRangeLocationRefer *)locationRefer lengthRefer:(nullable WCRangeLengthRefer *)lengthRefer {
    WCReferringRange *range = [[WCReferringRange alloc] init];
    range.locationNumber = locationNumber;
    range.lengthNumber = lengthNumber;
    range.locationRefer = locationRefer;
    range.lengthRefer = lengthRefer;
    
    return range;
}

- (void)updateLocationNumber:(nullable NSNumber *)locationNumber lengthNumber:(nullable NSNumber *)lengthNumber {
    _locationNumber = locationNumber;
    _lengthNumber = lengthNumber;
}

#pragma mark - Getter

- (NSUInteger)location {
    return [self.locationNumber unsignedIntegerValue];
}

- (NSUInteger)length {
    return [self.lengthNumber unsignedIntegerValue];
}

@end
