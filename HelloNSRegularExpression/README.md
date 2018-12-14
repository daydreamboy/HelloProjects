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

| 语法结构     | 含义                                                         | 示例                                                         |
| ------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `.`          | 匹配任意一个字符（有且仅有一个字符）                         | 例如`p.p`匹配"pop"、"pup"、"p@p"等等，但不包括"pp"           |
| `\w`         | 匹配任意一个word-like字符，包括数字、字母、下划线，但不包括标点及其他符号。（有且仅有一个字符） | 例如`hello\w`匹配"hello_9"和"helloo"，但不匹配"hello!"       |
| `[pattern]`  | 字符类（Character Classes），匹配pattern中枚举的任意一个字符（有且仅有一个字符） | 例如`t[aeiou]`匹配 "ta", "te", "ti", "to", 或者 "tu"         |
| `[^pattern]` | 取反字符类（Negated Character Classes），匹配除pattern中枚举之外的任意一个字符（有且仅有一个字符） | 例如`t[^o]`配t开头的，跟着除o之外的任意一个字符的组合        |
| `\d`         | 匹配一个数字（有且仅有一个字符）。可以认为等价于`[0-9]`      | 例如`\d\d?:\d\d`匹配"9:30",  "12:45"                         |
| `\b`         | 匹配单词边界符（Word Boundary Characters），比如空格、标点符号等。一般`\b`用于匹配单词。 | 例如`to\b`匹配"to the moon"和"to!"中的"to"，但不匹配"tomorrow"中的"to"。（注意：匹配完成后的to没有包括空格。） |
| `\s`         | 匹配空白符（Whitespace Characters），比如空格、tab符、换行符等。 | 例如`hello\s`匹配"Well, hello there!"中的"hello "            |
| `^`          | 总是匹配一行的起始处。这里的`^`作用不同于`[^pattern]`中的`^` | 例如`^Hello`匹配"Hello there"中的"Hello"，但不匹配"He said Hello"中的"Hello" |
| `$`          | 总是匹配一行的结束处。                                       | 例如`the end$`匹配"It was the end"的"the end"，但不匹配"the end was near"的"the end" |
| `*`          | 匹配该符号之前的一个字符，0次或者1次以上                     | 例如`12*3`匹配"13", "123", "1223", "122223", 和"1222222223"  |
| `+`          | 匹配该符号之前的一个字符，至少1次及以上                      | 例如`12+3`匹配"123", "1223", "122223", "1222222223"，但不匹配"13" |
| `{n}`        | 匹配该符号之前的一个字符，仅n次                              | 例如`He[Ll]{2}o`仅匹配"HeLLo", "Hello", "HelLo"和"HeLlo"     |
| `{n,}`       | 匹配该符号之前的一个字符，至少n次及以上                      | 例如`He[Ll]{2,}o`匹配"HeLLo"和 "HellLLLllo"，但不匹配"Helo"和"Heo" |
| `{n,m}`      | 匹配该符号之前的一个字符，仅n到m次，包括n和m次               | 例如`10{1,2}1`匹配"101"和"1001"，但不匹配"10001"             |






### 2、使用NSRegularExpression







## References

[^1]: https://www.raywenderlich.com/2725-nsregularexpression-tutorial-and-cheat-sheet 