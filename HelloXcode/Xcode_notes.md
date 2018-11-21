## 使用Xcode相关技巧

[TOC]

---

### 1、Xcode环境变量[^1]

| Environment variable | 作用 | 说明 |
|----------------------|-----|------|
| DYLD\_PRINT\_LIBRARIES | 输出image加载日志 | |
| DYLD\_PRINT\_ENV | 输出环境变量 | 通过C函数getenv也可以获取环境变量 |



### 2、Code Diagnostics[^2]

#### （1）Address Sanitizer

Xcode打开Address Sanitizer（简称ASan）设置，如下

![](images/Turn On Address Sanitizer.png)



Address Sanitizer支持检查的类型，如下

* Use of Deallocated Memory
  * Detects when memory is used after being deallocated. （销毁后的内存被使用）
* Deallocation of Deallocated Memory
  * Detects when memory is freed after being deallocated.（销毁后的内存被销毁）

* Deallocation of Nonallocated Memory
  * Detects when nonallocated memory is freed.（销毁不能被释放的内存，一般是栈上的内存）

* Use of Stack Memory After Function Return
  * Detects when stack variable memory is accessed after its declaring function returns.
  * 开启这个功能，需要单独打开下面这个Detect use of stack after return设置

![](images/Turn On Detect use of stack after return.png)

* Use of Out-of-Scope Stack Memory
  * Detects when variables are accessed outside of their declared scope.（访问栈上作用域之外的变量）

* Overflow and Underflow of Buffers
  * Detects when memory is accessed outside of a buffer’s boundaries.（缓冲区上溢或下溢，一般是数组越界的情况）

* Overflow of C++ Containers
  * Detects when a C++ container is accessed outside its bounds.（C++容器的越界情况，例如vector）
  * 开启这个功能，需要单独打开下面这个编译设置

![](images/Enable C++ Container Overflow Checks for Address Sanitizer.png)



#### （2）Thread Sanitizer

Xcode打开Thread Sanitizer（简称TSan）设置，如下

![](images/Turn On Thread Sanitizer.png)

目前TSan仅支持模拟器，不支持设备。

> TSan is supported only for 64-bit macOS and 64-bit iOS and tvOS simulators (watchOS is not supported). You cannot use TSan when running apps on a device.



Thread Sanitizer支持检查的情况，如下

* Data Races
  * Detects unsynchronized access to mutable state across multiple threads.（一般指存在多线程访问可读写的变量）

* Swift Access Races
  * Detects when multiple threads call a mutating method on the same structure, or pass a shared variable as `inout` without synchronization.

* Races on Collections and Other APIs
  * Detects when a thread accesses a mutable object while another thread writes to that object, causing a data race.（容器类mutable版本，存在多线程访问的问题）

> 上面三种情况，都可以归纳为Data Races。文档定义Data Races的行为是，multiple threads access the same memory without synchronization and at least one access is a write，即存在多个线程读访问相同的内存，并且至少有一个线程是写访问。



* Uninitialized Mutexes
  * Detects when a mutex is used before it's initialized.（一般指mutex使用前没有初始化）

* Thread Leaks
  * Detects when threads aren't closed after use.

> 经测试，Xcode 9.4.1 (9F2000)，没有检测到上面两种情况。



#### （3）Main Thread Checker

Xcode默认打开Main Thread Checker设置，如下

![](images/Turn On Main Thread Checker.png)

​        文档上描述，Main Thread Checker设置，用于检测非主线程中更新UI的操作，同时指出非主线程中更新UI，会导致视图错误、数据损坏以及crash等问题。

> Updating UI on a thread other than the main thread is a common mistake that can result in missed UI updates, visual defects, data corruptions, and crashes.

​        注意：这里只是禁止非主线程更新UI，但是非主线程绘图还是可以的。异步刷新方式，就是采用非主线程绘图，然后主线程更新UI。

​       `libMainThreadChecker.dylib`提供Main Thread Checker功能，由于是动态库，不要重新编译，就可以使用Main Thread Checker功能。`libMainThreadChecker.dylib`位于**/Applications/Xcode.app/Contents/Developer/usr/lib/libMainThreadChecker.dylib**

> lipo -info libMainThreadChecker.dylib，检查发现libMainThreadChecker.dylib只有模拟器架构的。



### Reference

[^1]: https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/LoggingDynamicLoaderEvents.html
[^2]: https://developer.apple.com/documentation/code_diagnostics 

