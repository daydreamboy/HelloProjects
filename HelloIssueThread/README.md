# Thread Issues

[TOC]

## 1、非主线程操作UI



非主线程操作UI相关的API，已知影响，如下

| API                                       | 已知影响                                                     |
| ----------------------------------------- | ------------------------------------------------------------ |
| dismissViewControllerAnimated:completion: | 不同iOS版本，表现不一样。iOS 14+上会crash，iOS 12上仅console出现警告 |







