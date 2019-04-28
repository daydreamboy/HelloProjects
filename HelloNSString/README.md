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
| `-[NSString rangeOfString:options:]`                         | 搜索 | options参数需要指定NSRegularExpressionSearch |
| `-[NSString  stringByReplacingOccurrencesOfString:withString:options:range:]` | 替换 | options参数需要指定NSRegularExpressionSearch |



> NSRegularExpressionSearch的官方描述，"The search string is treated as an ICU-compatible regular expression. If set, no other options can apply except `NSCaseInsensitiveSearch` and `NSAnchoredSearch`. "。这里描述有误导性，实际上，pattern中指定`^`或`$`，不需要指定`NSAnchoredSearch`。而且`NSAnchoredSearch`含义是从前匹配，而对应的`NSBackwardsSearch`是从后匹配。
>
> 举个例子，当pattern中指定`$`，而options指定`NSAnchoredSearch`会导致匹配总是失败的。



## References

[^1]: https://www.objc.io/issues/9-strings/string-parsing/