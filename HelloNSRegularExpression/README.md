## HelloNSRegularExpression

[TOC]

---

### 1、正则表达式（Regular Expression）

​          正则表达式定义一个pattern，按照这个pattern去搜索需要匹配的字符串。这个pattern的描述，是按照Regular Expression规则来定义的，所以pattern也称为正则表达式。

​          正则表达式的内容，实际是一个字符串，包含几个部分：字面字符（literal characters）、保留字符（reserved characters）以及保留字符构成的语法结构，例如捕获括号（Capturing parentheses）、字符集合（Character classes）等。



#### （1）常用保留字符[^1]

| 常用保留字符 |
| ------------ |
| [            |
| ( and )      |
| \            |
| *            |
| +            |
| ?            |
| { and }      |
| ^            |
| $            |
| .            |
| \|(pipe)     |
| /            |



* 如果需要使用上面的字符，需要使用`\`进行转义，例如匹配单个字符串`@"."`则需要`@"\\."`；如果匹配字符串`@"\\."`则需要`@"\\\\\\."`。

* `-`不是保留字符，但是在`[pattern]`匹配时，如果`-`左右两边不能取范围，则需要将`-`转义。例如`[a-z_-]`是合法的pattern，而`[a-Z_-\\.]`则不是合法的pattern，正确的pattern是`[a-z_\\-\\.]`。



示例代码，如下

```objective-c
pattern = @"\\$!?(?:\\{([a-zA-Z0-9_-\\.]+)\\}|([a-zA-Z0-9_-]+))";
valid = [WCRegularExpressionTool checkPatternWithString:pattern error:nil];
XCTAssertFalse(valid);
```





#### （2）常用语法结构

| 语法结构 | 含义                                          | 示例                                               |
| -------- | --------------------------------------------- | -------------------------------------------------- |
| `.`      | 匹配任意一个字符（有且仅有一个字符）          | 例如"p.p"匹配"pop"、"pup"、"p@p"等等，但不包括"pp" |
| `\w`     | 匹配任意一个word-like字符（有且仅有一个字符） |                                                    |



### 2、使用NSRegularExpression







## References

[^1]: https://www.raywenderlich.com/2725-nsregularexpression-tutorial-and-cheat-sheet 