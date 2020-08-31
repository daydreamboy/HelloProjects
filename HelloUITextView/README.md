# UITextView

[TOC]

## 1、介绍UITextView

​       在iOS 7+开始，UITextView换成TextKit实现，TextKit主要提供NSTextStorage、NSLayoutManager、NSTextContainer等[^1]，用于控制文本的布局。

UITextView和NSTextStorage、NSLayoutManager、NSTextContainer的关系[^2]，如下

<img src="images/UITextView_TextKit.png" style="zoom:50%;" />

UITextView包含一个NSTextContainer对象，而NSTextContainer对象包含NSLayoutManager对象，NSLayoutManager对象包含NSTextStorage对象。

说明

> 1. UITextView除了提供textContainer属性，为了方便，也提供layoutManager属性和textStorage属性，但是持有关系还是上面图中所示。
> 2. NSTextStorage实际是继承自NSMutableAttributedString



上面图中，每个类负责不同的职责

* UITextView，负责参与视图层级，以及和键盘输入的交互（实现UITextInput）
* NSTextContainer，定义文本布局的区域
* NSLayoutManager，负责调用CoreText处理布局
* NSTextStorage，负责操作文本模型





## References

[^1]:https://developer.apple.com/documentation/appkit/textkit?language=objc#
[^2]:https://www.objc.io/issues/5-ios7/getting-to-know-textkit/



