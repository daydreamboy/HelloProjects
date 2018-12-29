## HelloNSScanner

[TOC]

### 1、NSScanner的工作原理

​        NSScanner内部有一个游标（`sourceLocation`属性），从字符串起止到结束，扫描字符序列。游标总是指向将要扫描的第一个字符位置，初始化值是0。

​       NSScanner提供一系列扫描方法，例如scanXXX:，当游标指向的字符符合匹配规则，则游标向后移动，如果不匹配，则游标不变。或者游标指向的字符属于`charactersToBeSkipped`，则游标向后移动并跳过匹配的过程。



### 2、NSScanner的用法[^1]

NSScanner的用法大概分三个步骤，如下

#### （1）初始化Scanner

一般使用下面方法初始化

```objective-c
+[NSScanner scannerWithString:];
-[NSScanner initWithString:]
```



#### （2）配置Scanner

| 属性                    | 说明                                                         |
| ----------------------- | ------------------------------------------------------------ |
| `scanLocation`          | 下个将要扫描的字符位置                                       |
| `caseSensitive`         | 是否区分大小写。默认是NO。                                   |
| `charactersToBeSkipped` | 扫描过程需要跳过匹配的字符。默认是`whitespaceAndNewlineCharacterSet`。 |
| `locale`                | 本地化设置。影响如何匹配数值。默认是nil。                    |
| `isAtEnd`               | 用于查询scanner是否扫描到末尾                                |



说明

> 在扫描字符序列中，可以修改`scanLocation`值，用于重新定位游标。也可以修改`charactersToBeSkipped`。



#### （3）扫描字符序列

​        NSScanner提供两种不同模式的扫描方式，一种是总是匹配当前游标指向的字符并移动游标（后面称为**匹配模式，ScanXXX**），另一种是当前游标指向的字符不满足匹配，移动游标直至到当前游标指向的字符满足匹配则停止移动游标（后面称为**匹配到模式，ScanUpToXXX**）。



##### 匹配模式，ScanXXX

| 方法                                  | 说明 |
| ------------------------------------- | ---- |
| `-[NSScanner scanString:intoString:]` |      |
| ...                                   |      |



ScanXXX系列方法，函数签名有下面几个共性：

* 都有BOOL类型返回值，用于指示匹配是否成功。若匹配成功，则游标移动到不满足匹配字符的位置。若匹配失败，则游标不变。
* 都有一个out参数，用于输出满足匹配以及匹配类型的结果。



##### 匹配到模式，ScanUpToXXX

| 方法                                                 | 说明 |
| ---------------------------------------------------- | ---- |
| `-[NSScanner scanUpToString:intoString:]`            |      |
| `-[NSScanner scanUpToCharactersFromSet:intoString:]` |      |



ScanUpToXXX系列方法，函数签名的共性和上面的ScanXXX系列方法一样。



## References

[^1]: https://developer.apple.com/documentation/foundation/nsscanner?language=objc 