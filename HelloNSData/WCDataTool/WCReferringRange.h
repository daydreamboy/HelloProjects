//
//  WCReferringRange.h
//  HelloNSData
//
//  Created by wesley_chen on 2020/6/4.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCRangeLocationRelative) {
    WCRangeLocationRelativeUnknown,
    WCRangeLocationRelativeAtStart,
    WCRangeLocationRelativeAtEnd,
};

typedef NS_ENUM(NSUInteger, WCReferringRangeReferMode) {
    WCReferringRangeReferModeValue,
    WCReferringRangeReferModeRelative,
};

@class WCReferringRange;

@interface WCRangeLocationRefer : NSObject
@property (nonatomic, strong) WCReferringRange *referringRange;
@property (nonatomic, assign) WCReferringRangeReferMode referMode;
// Relative Mode
@property (nonatomic, assign) WCRangeLocationRelative relative;
@property (nonatomic, assign) NSInteger offset;

+ (instancetype)locationReferWithReferringRange:(WCReferringRange *)referringRange referMode:(WCReferringRangeReferMode)referMode relative:(WCRangeLocationRelative)relative offset:(NSInteger)offset;

#define LocationRelativeRefer(_range, _relative, _offset) ([WCRangeLocationRefer locationReferWithReferringRange:(_range) referMode:WCReferringRangeReferModeRelative relative:(_relative) offset:(_offset)])

#define LocationValueRefer(_range) ([WCRangeLocationRefer locationReferWithReferringRange:(_range) referMode:WCReferringRangeReferModeValue relative:WCRangeLocationRelativeUnknown offset:0])

@end

@interface WCRangeLengthRefer : NSObject
@property (nonatomic, strong) WCReferringRange *referringRange;
@property (nonatomic, assign) NSUInteger expectedSize; // 1/2/4/8

+ (instancetype)lengthReferWithReferringRange:(WCReferringRange *)referringRange expectedSize:(NSUInteger)expectedSize;

#define LengthRefer(_range, _expectedSize) ([WCRangeLengthRefer lengthReferWithReferringRange:(_range) expectedSize:(_expectedSize)])

@end

@interface WCReferringRange : NSObject
@property (nonatomic, readonly) NSUInteger location;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly, nullable) WCRangeLocationRefer *locationRefer;
@property (nonatomic, readonly, nullable) WCRangeLengthRefer *lengthRefer;
@property (nonatomic, strong) id userInfoObject;

+ (instancetype)referringRangeWithLocationNumber:(nullable NSNumber *)locationNumber lengthNumber:(nullable NSNumber *)lengthNumber locationRefer:(nullable WCRangeLocationRefer *)locationRefer lengthRefer:(nullable WCRangeLengthRefer *)lengthRefer;

- (void)updateLocationNumber:(nullable NSNumber *)locationNumber lengthNumber:(nullable NSNumber *)lengthNumber;

#define ReferringRangeValue(loc, len, locRef, lenRef) ([WCReferringRange referringRangeWithLocationNumber:(loc) lengthNumber:(len) locationRefer:(locRef) lengthRefer:(lenRef)])

@end

NS_ASSUME_NONNULL_END
