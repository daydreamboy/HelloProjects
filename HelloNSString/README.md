# String Notes

[TOC]

## 1、字符串解析[^1]

通常有这样的需求：字符串按照特定的语法，即一组规则，进行解释，称为**字符串解析**（String Parsing）。

一般有三种通用技术，完成这个任务。

* 正则表达式（Regular Expression）



## 2、常见String API



### （1）正则表达式搜索和替换

| 函数签名                                                     | 作用 | 说明                                         |
| ------------------------------------------------------------ | ---- | -------------------------------------------- |
| -rangeOfString:options:                                      | 搜索 | options参数需要指定NSRegularExpressionSearch |
| -stringByReplacingOccurrencesOfString:withString:options:range: | 替换 | options参数需要指定NSRegularExpressionSearch |



> NSRegularExpressionSearch的官方描述，"The search string is treated as an ICU-compatible regular expression. If set, no other options can apply except `NSCaseInsensitiveSearch` and `NSAnchoredSearch`. "。这里描述有误导性，实际上，pattern中指定`^`或`$`，不需要指定`NSAnchoredSearch`。而且`NSAnchoredSearch`含义是从前匹配，而对应的`NSBackwardsSearch`是从后匹配。
>
> 举个例子，当pattern中指定`$`，而options指定`NSAnchoredSearch`会导致匹配总是失败的。



### （2）Range查询

| 函数签名                 | 说明                                                         |
| ------------------------ | ------------------------------------------------------------ |
| -paragraphRangeForRange: | 指定range，查询包含该range的paragraph range。paragraph是由a carriage return (`U+000D`), newline (`U+000A`), or paragraph separator (`U+2029`)分隔的文本段 |









## 3、关于字符串字面常量

在Objective-C中，字符串字面常量可以用三种方式来表示

* 普通字符串，例如@"ABC"、@""、@"🌍🌞"
* UTF-8字符串，例如@"\uF8FF"

* Unicode字符串，例如@"\U0000F8FF"



说明

> 1. Emoji表情也是普通字符串
> 2. UTF-8字符和Unicode字符，分别用小写u和大写U来区分，当Unicode字符只占一个UTF-8字符时，它们的值是一样的，例如@"\uF8FF"和@"\U0000F8FF"是等价的，多余位补零即可
> 3. 控制字符，是不能使用UTF-8字符和Unicode字符，例如@"\U0000000A"和@"\u000A"（实际是@"\n"）会编译报错“Universal character name refers to a control character”



## 4、汉字转拼音

### （1）Unicode拼音映射表

TODO

### （2）拼音加声调[^2]

TODO

### （3）拼音匹配[^3]

TODO



## 5、常用特殊字符的Unicode编码



| 字符                | Unicode编码 |
| ------------------- | ----------- |
| ↑                   | \u2191      |
| carriage return     | \u000d      |
| newline             | \u000a      |
| paragraph separator | \u2029      |



## 6、NSString常见问题

### （1）Emoji字符被截断的问题



https://stackoverflow.com/questions/47130742/whats-an-example-of-an-nsstring-for-which-utf8string-returns-null





## References

[^1]: https://www.objc.io/issues/9-strings/string-parsing/
[^2]:http://www.hwjyw.com/resource/content/2010/06/04/8183.shtml
[^3]:https://www.jianshu.com/p/33f29eb598d9

