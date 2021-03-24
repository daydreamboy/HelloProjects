# UIAlertController

[TOC]

## 1、UIAlertController

UIAlertController在iOS 8+引入，用于替代UIAlertView。



## 2、UIAlertController私有API

UIAlertController存在私有属性，可以通过KVC方式，进行一些定义的样式。

| 属性                      | 作用                                                  |
| ------------------------- | ----------------------------------------------------- |
| contentViewController[^1] | 设置一个content view controller，值是UIViewController |
| attributedMessage[^2]     | 设置message为attributed，值是NSAttributedString       |



> 示例代码，见TabledAlertController和AlertWithAttributedMessageViewController









# References

[^1]:https://stackoverflow.com/questions/37428337/customised-uiactionsheet/37428360#37428360
[^2]:https://medium.com/@chauyan/change-text-alignment-of-the-uialertviewcontroller-af25bce05af1







