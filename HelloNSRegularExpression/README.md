# HelloNSRegularExpression

[TOC]



## 1、关于正则表达式（Regular Expression）

​          正则表达式定义一个pattern，按照这个pattern去搜索需要匹配的字符串。这个pattern的描述，是按照Regular Expression规则来定义的，所以pattern也称为正则表达式。

​          正则表达式的内容，实际是一个字符串，包含几个部分：字面字符（literal characters）、保留字符（reserved characters）以及保留字符构成的语法结构，例如捕获括号（Capturing parentheses）、字符集合（Character classes）等。



说明

iOS的正则表达式，实际上采用的是ICU正则表达式。

>  The ICU regular expressions supported by `NSRegularExpression` are described at http://userguide.icu-project.org/strings/regexp.

http://userguide.icu-project.org/strings/regexp，已经迁移到新的网址，https://unicode-org.github.io/icu/



Wikipedia对ICU的描述[^3]，如下

> **International Components for Unicode** (**ICU**) is an [open-source](https://en.wikipedia.org/wiki/Open-source_software) project of mature [C](https://en.wikipedia.org/wiki/C_(programming_language))/[C++](https://en.wikipedia.org/wiki/C%2B%2B) and [Java](https://en.wikipedia.org/wiki/Java_(programming_language)) libraries for [Unicode](https://en.wikipedia.org/wiki/Unicode) support, software [internationalization](https://en.wikipedia.org/wiki/Internationalization_and_localization), and software globalization. ICU is widely portable to many operating systems and environments. It gives applications the same results on all platforms and between C, C++, and Java software. The ICU project is a technical committee of the [Unicode Consortium](https://en.wikipedia.org/wiki/Unicode_Consortium) and sponsored, supported, and used by [IBM](https://en.wikipedia.org/wiki/IBM) and many other companies.
>
> ICU provides the following services: [Unicode](https://en.wikipedia.org/wiki/Unicode) text handling, full character properties, and [character set](https://en.wikipedia.org/wiki/Character_set) conversions; Unicode [regular expressions](https://en.wikipedia.org/wiki/Regular_expression); full Unicode sets; character, word, and line boundaries; language-sensitive [collation](https://en.wikipedia.org/wiki/Collation) and searching; [normalization](https://en.wikipedia.org/wiki/Unicode_normalization), upper and lowercase conversion, and script [transliterations](https://en.wikipedia.org/wiki/Transliteration); comprehensive [locale](https://en.wikipedia.org/wiki/Locale_(computer_software)) data and resource bundle architecture via the [Common Locale Data Repository](https://en.wikipedia.org/wiki/Common_Locale_Data_Repository) (CLDR); multi-[calendar](https://en.wikipedia.org/wiki/Calendar) and [time zones](https://en.wikipedia.org/wiki/Time_zone); and rule-based formatting and parsing of dates, times, numbers, currencies, and messages. ICU provided [complex text layout](https://en.wikipedia.org/wiki/Complex_text_layout) service for Arabic, Hebrew, Indic, and Thai historically, but that was deprecated in version 54, and was completely removed in version 58 in favor of [HarfBuzz](https://en.wikipedia.org/wiki/HarfBuzz).

简单来说，ICU是一个开源项目，提供C/C++和Java类库，主要处理Unicode相关的任务，比如Unicode字符集的定义、Unicode正则表达式定义等。



### （1）元字符[^1]（Regular Expression Metacharacters）

​       有些字符是正则表达式语法中的特殊字符，或称为**元字符**。当这些元字符需要当成普通字符使用时，则需要进行转义。

​        常见需要转义的元字符，如下

| 元字符（Regular Expression Metacharacters） |
| ------------------------------------------- |
| `[`                                         |
| `(` and` )`                                 |
| `\`                                         |
| `*`                                         |
| `+`                                         |
| `?`                                         |
| `{` and `}`                                 |
| `^`                                         |
| `$`                                         |
| `.`                                         |
| `|`(pipe)                                   |
| `/`                                         |



* 如果需要使用上面的字符，需要使用`\`进行转义，例如匹配单个字符串`@"."`则需要`@"\\."`；如果匹配字符串`@"\\."`则需要`@"\\\\\\."`。

* `-`不是保留字符，但是在`[pattern]`匹配时，如果`-`左右两边不能取范围，则需要将`-`转义。例如`[a-z_-]`是合法的pattern，而`[a-Z_-\\.]`则不是合法的pattern，正确的pattern是`[a-z_\\-\\.]`。



示例代码，如下

```objective-c
pattern = @"\\$!?(?:\\{([a-zA-Z0-9_-\\.]+)\\}|([a-zA-Z0-9_-]+))";
valid = [WCRegularExpressionTool checkPatternWithString:pattern error:nil];
XCTAssertFalse(valid);
```



除了上面字面需要转义的元字符，还有一些可以用于匹配的元字符，如下

| 元字符（Regular Expression Metacharacters） | 含义                                                         | 示例                                                         |
| ------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `\p{UNICODE PROPERTY NAME}`                 | 匹配特定Unicode Property中的任意字符                         | `\p{Hex_Digit}{6}`，匹配十六进制字符，而且长度为6。Hex_Digit是一个Unicode Property。 |
| `\P{UNICODE PROPERTY NAME}`                 | 匹配除Unicode Property之外的任意字符                         |                                                              |
| `.`                                         | 匹配任意一个字符（有且仅有一个字符）                         | 例如`p.p`匹配"pop"、"pup"、"p@p"等等，但不包括"pp"           |
| `\w`                                        | 匹配任意一个word-like字符，包括数字、字母、下划线，但不包括标点及其他符号。（有且仅有一个字符） | 例如`hello\w`匹配"hello_9"和"helloo"，但不匹配"hello!"       |
| `[pattern]`                                 | 字符类（Character Classes），匹配pattern中枚举的任意一个字符（有且仅有一个字符） | 例如`t[aeiou]`匹配 "ta", "te", "ti", "to", 或者 "tu"         |
| `[^pattern]`                                | 取反字符类（Negated Character Classes），匹配除pattern中枚举之外的任意一个字符（有且仅有一个字符） | 例如`t[^o]`配t开头的，跟着除o之外的任意一个字符的组合        |
| `\d`                                        | 匹配一个数字（有且仅有一个字符）。可以认为等价于`[0-9]`      | 例如`\d\d?:\d\d`匹配"9:30",  "12:45"                         |
| `\b`                                        | 匹配单词边界符（Word Boundary Characters），比如空格、标点符号等。一般`\b`用于匹配单词。 | 例如`to\b`匹配"to the moon"和"to!"中的"to"，但不匹配"tomorrow"中的"to"。（注意：匹配完成后的to没有包括空格。） |
| `\s`                                        | 匹配空白符（Whitespace Characters），比如空格、tab符、换行符等。 | 例如`hello\s`匹配"Well, hello there!"中的"hello "            |
| `^`                                         | 总是匹配一行的起始处。这里的`^`作用不同于`[^pattern]`中的`^` | 例如`^Hello`匹配"Hello there"中的"Hello"，但不匹配"He said Hello"中的"Hello" |
| `$`                                         | 总是匹配一行的结束处。                                       | 例如`the end$`匹配"It was the end"的"the end"，但不匹配"the end was near"的"the end" |
|                                             |                                                              |                                                              |
|                                             |                                                              |                                                              |
|                                             |                                                              |                                                              |



### （2）常用操作符（Regular Expression Operators）

操作符用于标记对元字符或普通字符的操作，操作符可以是单个字符，也可以多个字符的特定组合。



#### 普通的操作符

| 操作符  | 含义                                                         | 示例                                                         |
| ------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `*`     | 匹配该符号之前的一个字符，0次或者1次以上（Match as many times as possible.） | 例如`12*3`匹配"13", "123", "1223", "122223", 和"1222222223"  |
| `+`     | 匹配该符号之前的一个元素，至少1次及以上（Match as many times as possible.） | 例如`12+3`匹配"123", "1223", "122223", "1222222223"，但不匹配"13" |
| `?`     | 匹配该符号之前的一个元素，0次或者1次。优先1次。              | 例如`12?3`匹配"13", "123"，但不匹配"1223"                    |
| `{n}`   | 匹配该符号之前的一个元素，仅n次（Match as many times as possible.） | 例如`He[Ll]{2}o`仅匹配"HeLLo", "Hello", "HelLo"和"HeLlo"     |
| `{n,}`  | 匹配该符号之前的一个元素，至少n次及以上（Match as many times as possible.） | 例如`He[Ll]{2,}o`匹配"HeLLo"和 "HellLLLllo"，但不匹配"Helo"和"Heo" |
| `{n,m}` | 匹配该符号之前的一个元素，仅n到m次，包括n和m次（Match as many times as possible.） | 例如`10{1,2}1`匹配"101"和"1001"，但不匹配"10001"             |



#### 应用`?`（reluctant quantifier）的操作符

| 操作符   | 含义                                                         | 示例 |
| -------- | ------------------------------------------------------------ | ---- |
| `*?`     | 匹配该符号之前的一个元素，0次或者1次以上（Match as few times as possible.） |      |
| `+?`     | 匹配该符号之前的一个元素，至少1次及以上（Match as few times as possible.） |      |
| `??`     | 匹配该符号之前的一个元素，0次或者1次。优先0次。              |      |
| `{n}?`   | 匹配该符号之前的一个元素，仅n次（Match as few times as possible.） |      |
| `{n,}?`  | Match at least n times, but no more than required for an overall pattern match. |      |
| `{n,m}?` | Match between n and m times. Match as few times as possible, but not less than n. |      |



#### 应用`+`（possessive quantifier）的操作符

| 操作符   | 含义                                                         | 示例 |
| -------- | ------------------------------------------------------------ | ---- |
| `*+`     | Match 0 or more times. Match as many times as possible when first encountered, do not retry with fewer even if overall match fails (Possessive Match). |      |
| `++`     | Match 1 or more times. Possessive match.                     |      |
| `?+`     | Match zero or one times. Possessive match.                   |      |
| `{n}+`   | Match exactly *n* times.                                     |      |
| `{n,}+`  | Match at least *n* times. Possessive Match.                  |      |
| `{n,m}+` | Match between *n* and *m* times. Possessive Match.           |      |



### （3）Greedy、Reluctant和Possessive模式[^2]

​           正则表达式操作符中，可以应用不同quantifier，`*`（greedy quantifier）、`?`（reluctant quantifier）或者`+`（possessive quantifier）来执行不同匹配模式，得到匹配结果也是不一样的。



| quantifier符号               | 含义                                                         | 示例                                         |
| ---------------------------- | ------------------------------------------------------------ | -------------------------------------------- |
| `*`（greedy quantifier）     | 每一次匹配都尽可能多的匹配（Match as many times as possible.） | `.*foo`匹配xfooxxxxxxfoo中的xfooxxxxxxfoo    |
| `?`（reluctant quantifier）  | 每一次匹配都尽可能少的匹配（Match as few times as possible.） | `.*?foo`匹配xfooxxxxxxfoo中的xfoo和xxxxxxfoo |
| `+`（possessive quantifier） | 每一次匹配都尽可能多的匹配，但不回溯（backtrack）（Possessive Match.） | `.*+foo`不匹配xfooxxxxxxfoo                  |



关于上面三种方式匹配xfooxxxxxxfoo，以及如何backtrack，可以参考下面示意图。

![](images/Greedy、Reluctant和Possessive模式.png)



注意：

> 有些操作符已经默认是greedy，不需再加`*`，如`*`、`+`、`{n}`、`{n,}`、`{n,m}`。





### 2、使用NSRegularExpression







## References

[^1]: https://www.raywenderlich.com/2725-nsregularexpression-tutorial-and-cheat-sheet 
[^2]: https://stackoverflow.com/questions/5319840/greedy-vs-reluctant-vs-possessive-quantifiers 
[^3]:https://en.wikipedia.org/wiki/International_Components_for_Unicode



