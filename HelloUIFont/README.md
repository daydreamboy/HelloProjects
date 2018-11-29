## iOS Font

[TOC]

---



### 1、字体名规则

​       每个字体所属一个font family，font family类似一个字体系列，然后在系列下面有具体的字体名（font name）。UIFont提供`+[UIFont familyNames]`方法用于查询系统支持的所有font family，然后通过`+[UIFont fontNamesForFamilyName:]`方法获取某个字体系列下面的字体名。

​      每个字体名有特定的规则，一般是`familyName-style`或者直接是`familyName`。

以Georgia为例，Georgia是font family，而它下面的有4种字体名，分别是

```
Georgia
Georgia-Bold
Georgia-BoldItalic
Georgia-Italic
```



示例代码，见GetAllFontNamesViewController。



需要注意下面几点：

* 不是每个字体系列下面，都有字体名，例如`Bangla Sangam MN`下面没有字体名（环境：iOS Simulator 11.4）
* 系统字体系列是San Francisco (SF)[^1]，但不在`+[UIFont familyNames]`方法中。通过下面几种方法可以获取系统字体。（Apple官方提供San Francisco下载地址，点[这里](https://developer.apple.com/fonts/ )）

![](images/System Font.png)

* UIFont提供实例方法，`-[UIFont familyName]`和`-[UIFont fontName]`来查询每个字体对象所属的字体系列和字体名

* UIFont提供特定的方法，查询某些控件的字体大小，如下

![](images/Get System Font Info.png)

* `+[UIFont fontWithName:size:]`的name参数传入nil，得到不是系统字体，而是Helvetica字体。

```
(lldb) po [UIFont fontWithName:nil size:18]
<UICTFont: 0x7fda85a26090> font-family: "Helvetica"; font-weight: normal; font-style: normal; font-size: 18.00pt
```



## 附录

### 1、各个iOS系统版本支持的字体

http://iosfonts.com/





## Reference

[^1]: https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/





