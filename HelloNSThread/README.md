# Thread
[TOC]

## 1、POSIX Thread



* pthread_main_np，返回非0表示当前线程是主线程

> /* returns non-zero if the current thread is the main thread */
>
> __API_AVAILABLE(macos(10.4), ios(2.0))
>
> int	pthread_main_np(void);



## 2、常用技巧

### （1）判断当前线程是否是主线程

| 方式                        | 说明                                                      |
| --------------------------- | --------------------------------------------------------- |
| `+[NSThread isMainThread]`  | 返回YES，表示当前线程是主线程，否则返回NO                 |
| `int pthread_main_np(void)` | 返回非0表示当前线程是主线程。头文件`#include <pthread.h>` |



