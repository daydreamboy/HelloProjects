# NSData

[TOC]



## 1、File Mapping

​       File Mapping指的是将磁盘上文件直接映射到进程的虚拟内存中。如果映射成功，则进程可以读写这段虚拟内存，系统会将这段虚拟内存同步到磁盘文件上。

Apple对FileMapping描述[^1]，如下

> File mapping is the process of mapping the disk sectors of a file into the virtual memory space of a process. Once mapped, your app accesses the file as if it were entirely resident in memory. As you read data from the mapped file pointer, the kernel pages in the appropriate data and returns it to your app.



实现File Mapping主要是通过mmap函数，和常见的读写文件可以对比下

* 读写文件: `open` + `read/write` + `fsync`方式
* File Mapping: `open` + `mmap` + `memcpy` + `msync`方式

使用mmap函数的优势是，减少一次数据拷贝过程，即**常规文件操作需要从磁盘到页缓存，再到用户主存的两次数据拷贝，而mmap映射文件，只需要从磁盘到用户主存的一次数据拷贝过程**[^2]。

这篇文章[^3]从机器指令的角度，比较了mmap和系统调用，分析了mmap的性能好的具体原因。



### (1) File Mapping使用场景

不是所有文件和应用场景，适合把文件映射到虚拟内存中。

适合使用File Mapping

* 有较大的文件，需要随机访问多次以上
* 有较小的文件，需要一次性读到内存，并频繁访问。因此cache比较适合使用File Mapping
* 需要把文件的部分内容读到内存中



不适合使用File Mapping

* 读文件从开始到结束，仅执行一次
* 文件有几百MB以上。映射大文件到内存，导致页缓存不够，页换出
* 文件大于剩余可用的连续虚拟内存地址。64位应用比较少出现此情况，但是32位应用可能会出现
* 文件位于可移动的磁盘上
* 文件位于网络磁盘上

说明

> NSData的`initWithContentsOfFile:options:error:`方法，options参数推荐使用DataReadingMappedIfSafe，能保证安全映射一个文件



### (2) 介绍mmap函数

mmap函数的声明位于`sys/mman.h`中，如下

```c
void * mmap(void *, size_t, int, int, int, off_t) __DARWIN_ALIAS(mmap);
```

可以在terminal中使用man命令查看mmap更详细的签名，如下

```c
void * mmap(void *addr, size_t len, int prot, int flags, int fd, off_t offset);
```

mmap的参数有一些限制，必须小心设置参数，才能保证mmap创建虚拟内存成功。

mmap的参数的含义，如下

* addr，指定映射后虚拟内存起始地址，一般指定为NULL，让系统随机分配返回一个起始地址

* len，指定虚拟内存的长度。如果不满足页大小的整数倍，系统会自动将未用完的虚拟地址，扩展到页大小的整数倍，并填充为0。

* prot，指定虚拟内存的保护模式。一共有4种模式，如下。一般指定`PROT_READ`、`PROT_WRITE`或`PROT_READ | PROT_WRITE`。

  * PROT_NONE
  * PROT_READ
  * PROT_WRITE
  * PROT_EXEC

  注意

  > prot指定值后，并不代表系统一定遵守这个约定。例如指定`PROT_EXEC`，在iOS系统上实际不能创建可执行的虚拟内存地址。

* flags，指定映射虚拟内存的选项。如下表

  | 选项          | 作用                                                         |
  | ------------- | ------------------------------------------------------------ |
  | MAP_ANONYMOUS | 和MAP_ANON同义                                               |
  | MAP_ANON      | 映射一块匿名的虚拟内存，并且不和指定文件关联。该选项会忽略offset参数。 |
  | MAP_FILE      | 从文件映射到虚拟内存。默认是该选项，不需要指定该选项         |
  | MAP_FIXED     | 不允许系统自动分配虚拟内存。强制使用addr参数的起始地址，而且要求该地址必须是页大小的整数倍。如果分配成功，则虚拟内存从addr到addr+len。如果分配失败，则mmap返回MAP_FAILED。注意：使用MAP_FIXED，会强制清除addr到addr+len之间已经在使用的内存地址。一般是不推荐使用该选项。 |
  | MAP_PRIVATE   | 指定虚拟内存是私有的。如果修改，则执行copy-on-write          |
  | MAP_SHARED    | 指定虚拟内存是共享的，多个进程可以同时访问                   |
  | MAP_NOCACHE   | 指定虚拟内存，在系统内存不足，优先考虑回收该虚拟内存         |
  | MAP_JIT       | MacOS上，使用该选项，以及配合`PROT_WRITE | PROT_EXEC`，可以创建可执行的虚拟内存 |
  | MAP_32BIT     | 强制系统分配虚拟内存在32位地址空间内。如果虚拟内存地址不够，则分配失败。 |

* offset，指的是文件开始映射的偏移量。为了性能的考虑，offset必须是页大小的整数倍[^4]









## References

[^1]:https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemAdvancedPT/MappingFilesIntoMemory/MappingFilesIntoMemory.html#//apple_ref/doc/uid/TP40010765-CH2-SW1
[^2]:https://www.cnblogs.com/huxiao-tee/p/4660352.html
[^3]:https://sasha-f.medium.com/why-mmap-is-faster-than-system-calls-24718e75ab37

[^4]:https://stackoverflow.com/questions/20093473/why-file-starting-offset-in-mmap-must-be-multiple-of-the-page-size



https://unix.stackexchange.com/questions/475956/why-can-the-kernel-not-use-sse-avx-registers-and-instructions

https://gist.github.com/cuiwm/45dc660d875af20d756e01e000a4fbd7

https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/mmap.2.html#//apple_ref/doc/man/2/mmap

https://stackoverflow.com/questions/13425558/why-does-mmap-fail-on-ios



http://blog.jcix.top/2018-10-26/mmap_tests/#28221mmap8221_SIGBUS



