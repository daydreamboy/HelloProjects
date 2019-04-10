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

@property (nonatomic, strong, readonly) NSDate *date;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger weekOfYear;
@property (nonatomic, assign) NSInteger weekOfMonth;

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) WCWeekday weekday;

@property (nonatomic, assign) NSInteger nearestHour;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;

@property (nonatomic, assign) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
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

#pragma mark - Date Comparison

+ (BOOL)sameDateComponentWithDate:(NSDate *)date anotherDate:(NSDate *)anotherDate dateComponentType:(WCDateComponentType)dateComponentType;

@end

NS_ASSUME_NONNULL_END
