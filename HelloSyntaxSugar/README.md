## HelloSyntaxSugar

TOC

## 1. char字面常量，存放多个字符

char字面常量，存放多个字符。例如'abc'、'abcd'、'abcde'等。

根据[SO](https://stackoverflow.com/questions/6944730/multiple-characters-in-a-character-constant)上面的说法，这种情况根据系统和编译器，情况会不一样。

在MacOS用Xcode编译，得出如下规则：

总是从后到前取最后4个字节的数据，如果不满足4个字节，填充0x00。

举个例子

```
unsigned value;
char* ptr = (char*)&value;

value = 'ABCD';
printf("'ABCD' = %02x%02x%02x%02x = %08x\n", ptr[0], ptr[1], ptr[2], ptr[3], value);
    
value = 'ABC';
printf("'ABC'  = %02x%02x%02x%02x = %08x\n", ptr[0], ptr[1], ptr[2], ptr[3], value);
```

输出是

'ABCD' = 44434241 = 41424344    
'ABC'  = 43424100 = 00414243

由于是little endian，低地址的字节放在word（4个字节）的低位。


## 2. C++ 11支持Raw String

C++ 11支持Raw String，在.mm文件中可以使用R"\<LANG\>(raw string)\<LANG\>"语法，用于直接写非转义的C字符串。如下

```
static NSString *jsonString = @R"JSON(
{
    "glossary": {
        "title": "example glossary",
        "GlossDiv": {
            "title": "S",
            "GlossList": {
                "GlossEntry": {
                    "ID": "SGML",
                    "SortAs": "SGML",
                    "GlossTerm": "Standard Generalized Markup Language",
                    "Acronym": "SGML",
                    "Abbrev": "ISO 8879:1986",
                    "GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
                        "GlossSeeAlso": ["GML", "XML"]
                    },
                    "GlossSee": "markup"
                }
            }
        }
    }
}
)JSON";
```

上面的@符号将C字符串转成NSString类型。


