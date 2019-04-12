//
//  WCDateTool.h
//  HelloNSDate
//
//  Created by wesley_chen on 2019/4/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCDateComponentType) {
    WCDateComponentTypeYear,
    WCDateComponentTypeMonth,
    WCDateComponentTypeDay,
    WCDateComponentTypeHour,
    WCDateComponentTypeMinute,
    WCDateComponentTypeSecond,
    /*! The nth day in the week */
    WCDateComponentTypeWeekday,
    /*! The nth week in the month */
    WCDateComponentTypeWeekOfMonth,
    /*! The nth week in the year */
    WCDateComponentTypeWeekOfYear,
};

typedef NS_ENUM(NSUInteger, WCWeekday) {
    WCWeekdaySunday = 1,
    WCWeekdayMonday = 2,
    WCWeekdayTuesday = 3,
    WCWeekdayWednesday = 4,
    WCWeekdayThursday = 5,
    WCWeekdayFriday = 6,
    WCWeekdaySaturday = 7,
};

NS_AVAILABLE_IOS(8_0)
@interface WCDateComponents : NSObject

/**
 The date
 */
@property (nonatomic, strong, readonly) NSDate *date;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

/**
 The ordinal week in the year
 */
@property (nonatomic, assign) NSInteger weekOfYear;

/**
 The ordinal week in the month
 */
@property (nonatomic, assign) NSInteger weekOfMonth;

/**
 The nearst hour, e.g 12:54:03's nearst hour is 1
 */
@property (nonatomic, assign) NSInteger nearestHour;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;

@property (nonatomic, assign) WCWeekday weekday;
/**
 The nth weekday in the month, e.g. nthWeekday == 2 and weekday == WCWeekdayFriday is for the second Friday of the month.
 */
@property (nonatomic, assign) NSInteger nthWeekday;
@end

NS_AVAILABLE_IOS(8_0)
@interface WCDateTool : NSObject

#pragma mark - Get Date String

/**
 Get the string of current date with system timezone, and custom format, e.g. 2015-10-29 00:19:46 +0000

 @param format the format string. If nil, use `yyyy-MM-dd HH:mm:ss ZZ` by default
 @return the string of local date
 */
+ (nullable NSString *)stringFromCurrentDateWithFormat:(nullable NSString *)format;

/**
 Convert date into string with system timezone

 @param date the date to convert
 @param format the format string. If nil, use `yyyy-MM-dd HH:mm:ss ZZ` by default
 @return the date string
 */
+ (nullable NSString *)stringFromDate:(NSDate *)date format:(nullable NSString *)format;

#pragma mark - Components of Date (without time zone)

#pragma mark > Get component of date

+ (nullable WCDateComponents *)dateComponentsWithDate:(nullable NSDate *)date;

#pragma mark - Date Component Comparison

+ (BOOL)sameDateComponentWithDate:(NSDate *)date anotherDate:(NSDate *)anotherDate dateComponentType:(WCDateComponentType)dateComponentType;

#pragma mark - Adjust Date

+ (nullable NSDate *)dateWithDate:(NSDate *)date offset:(NSInteger)offset dateComponentType:(WCDateComponentType)dateComponentType;

@end

NS_ASSUME_NONNULL_END
