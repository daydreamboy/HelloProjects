# CoreMedia

[TOC]

## 1、关于CoreMedia

CoreMedia framework，定义了媒体定义类型和格式，AVFoundation基于该framework提供媒体操作。



### （1）CMTime

​       CMTime数据结构，根据有理数（rational）[^1]来表示时间长度，即CMTime的value字段代表分子，timescale字段代表分母。

举个例子[^2]，如下

```objective-c
CMTime t1 = CMTimeMake(1, 10); // 1/10 second = 0.1 second
CMTime t2 = CMTimeMake(2, 1);  // 2 seconds
CMTime t3 = CMTimeMake(3, 4);  // 3/4 second = 0.75 second
CMTime t4 = CMTimeMake(6, 8);  // 6/8 second = 0.75 second
```

​        用CMTime来表示时间长度，而不是常用的浮点数（double、float），是因为浮点数本身不是精确的，存在一定的累计误差[^3]。

实际上，CMTime结构体定义，如下

```objective-c
/*!
	@typedef	CMTime
	@abstract	Rational time value represented as int64/int32.
*/
typedef struct
{
	CMTimeValue	value;
	CMTimeScale	timescale;
	CMTimeFlags	flags;
	CMTimeEpoch	epoch;
} CMTime;
```

​        value是int64值，timescale是int32值，flags用于表示正负数、无穷大、无穷小等。

​        timescale代表1秒分成多少的单位，例如1000，则代表毫秒单位，而value/timescale的结构代表时间长度。例如value=1，timescale=1000，则value/timescale代表1毫秒。





## Reference

[^1]:https://www.mathsisfun.com/definitions/rational-number.html
[^2]:https://stackoverflow.com/questions/12902410/trying-to-understand-cmtime
[^3]:https://warrenmoore.net/understanding-cmtime



