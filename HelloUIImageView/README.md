# UIImageView

[TOC]

## 1、iOS 13上的issue

UIImageView的frame没有设置或者CGRectZero，通过CALayer的frame来布局，则在iOS 13上image显示不出来。

> 示例代码见LayerFrameIssueOniOS13ViewController


