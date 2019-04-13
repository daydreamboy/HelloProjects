# HelloNSDate

[TOC]

## 1、关于NSDate

### （1）NSDate的概念

官方文档指出，NSDate代表独立于任意日历或时区的一个特定时间点

> A representation of a specific point in time, independent of any calendar or time zone.



NSDate可以结合**NSDateFormatter**做时间的格式化，或者结合**NSCalendar**做日期的计算。

说明

> 1. NSDate对象是immutable



### （2）NSDate获取时间偏移量

NSDate提供下面的三个方法，获取时间偏移量

* timeIntervalSinceNow，基于当前时间的时间偏移量
* timeIntervalSinceReferenceDate，基于00:00:00 UTC on 1 January 2001的时间偏移量
* timeIntervalSince1970，基于Unix时间戳（00:00:00 UTC on 1 January 1970）的时间偏移量



