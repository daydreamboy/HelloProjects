# HelloNSInvocation

[TOC]

## 1、over release的内存错误

​        NSInvocation可以动态调用方法，并获取返回值，但是需要特别注意返回值是对象时，要考虑它的ownership，不然容易over release的内存错误。

​        over release的内存错误，极难通过crash的堆栈发现具体的地方，原因有下面几点

* Crash类型可能是多种，而且堆栈也不同。

  * 模拟器上Crash报错，例如`EXC_BAD_ACCESS (code=EXC_I386_GPFLT)` 或者`EXC_BAD_ACCESS (code=1, address=0x7830999c6180)`，其实是同一个Crash

  * 真机设备上报错和模拟器不同，是`EXC_BAD_ACCESS (SIGSEGV)`。而且真机上堆栈也不同，如下

    Crash日志1

    ```
    Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
    Exception Subtype: KERN_INVALID_ADDRESS at 0x0000000a294d19d0
    VM Region Info: 0xa294d19d0 is not in any region.  Bytes after previous region: 32368302545  
          REGION TYPE                      START - END             [ VSIZE] PRT/MAX SHRMOD  REGION DETAIL
          MALLOC_NANO            0000000280000000-00000002a0000000 [512.0M] rw-/rwx SM=PRV  
    --->  
          UNUSED SPACE AT END
    
    Termination Signal: Segmentation fault: 11
    Termination Reason: Namespace SIGNAL, Code 0xb
    Terminating Process: exc handler [16581]
    Triggered by Thread:  0
    
    Thread 0 name:  Dispatch queue: com.apple.main-thread
    Thread 0 Crashed:
    0   libobjc.A.dylib               	0x0000000188f27150 objc_release + 16
    1   libobjc.A.dylib               	0x0000000188f286e0 AutoreleasePoolPage::releaseUntil+ 136928 (objc_object**) + 180
    2   libobjc.A.dylib               	0x0000000188f285d8 objc_autoreleasePoolPop + 224
    3   QuartzCore                    	0x000000018fac2a60 CA::Context::commit_transaction+ 694880 (CA::Transaction*, double) + 416
    4   QuartzCore                    	0x000000018faec890 CA::Transaction::commit+ 866448 () + 676
    5   UIKitCore                     	0x000000018d21b5d4 _afterCACommitHandler + 140
    6   CoreFoundation                	0x0000000189161c48 __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__ + 32
    7   CoreFoundation                	0x000000018915cb34 __CFRunLoopDoObservers + 416
    8   CoreFoundation                	0x000000018915d100 __CFRunLoopRun + 1308
    9   CoreFoundation                	0x000000018915c8bc CFRunLoopRunSpecific + 464
    10  GraphicsServices              	0x0000000192fc8328 GSEventRunModal + 104
    11  UIKitCore                     	0x000000018d1f26d4 UIApplicationMain + 1936
    12  HelloNSInvocation             	0x0000000104e1b690 0x104e14000 + 30352
    13  libdyld.dylib                 	0x0000000188fe7460 start + 4
    ```

    Crash日志2

    ```
    Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
    Exception Subtype: KERN_INVALID_ADDRESS at 0x000000076b395340
    VM Region Info: 0x76b395340 is not in any region.  Bytes after previous region: 20589400897  
          REGION TYPE                      START - END             [ VSIZE] PRT/MAX SHRMOD  REGION DETAIL
          MALLOC_NANO            0000000280000000-00000002a0000000 [512.0M] rw-/rwx SM=PRV  
    --->  
          UNUSED SPACE AT END
    
    Termination Signal: Segmentation fault: 11
    Termination Reason: Namespace SIGNAL, Code 0xb
    Terminating Process: exc handler [16580]
    Triggered by Thread:  0
    
    Thread 0 name:  Dispatch queue: com.apple.main-thread
    Thread 0 Crashed:
    0   libobjc.A.dylib               	0x0000000188f27030 objc_retain + 16
    1   UIKitCore                     	0x000000018cc0d9d4 -[_UIViewControllerTransitionContext _enableInteractionForDisabledViews] + 72
    2   UIKitCore                     	0x000000018c90f2c4 -[UINavigationBar _reenableUserInteraction] + 56
    3   UIKitCore                     	0x000000018c90f33c -[UINavigationBar _reenableUserInteractionWhenReadyWithContext:] + 100
    4   UIKitCore                     	0x000000018cb4670c __49-[UINavigationController _startCustomTransition:]_block_invoke + 1300
    5   UIKitCore                     	0x000000018cc0d234 -[_UIViewControllerTransitionContext completeTransition:] + 100
    6   UIKitCore                     	0x000000018cc1c724 __53-[_UINavigationParallaxTransition animateTransition:]_block_invoke.113 + 736
    7   UIKitCore                     	0x000000018d670e84 -[UIViewAnimationBlockDelegate _didEndBlockAnimation:finished:context:] + 588
    8   UIKitCore                     	0x000000018d645148 -[UIViewAnimationState sendDelegateAnimationDidStop:finished:] + 244
    9   UIKitCore                     	0x000000018d645650 -[UIViewAnimationState animationDidStop:finished:] + 240
    10  UIKitCore                     	0x000000018d6457a0 -[UIViewAnimationState animationDidStop:finished:] + 576
    11  QuartzCore                    	0x000000018fb7a4c0 CA::Layer::run_animation_callbacks+ 1447104 (void*) + 276
    12  libdispatch.dylib             	0x0000000188eb2184 _dispatch_client_callout + 16
    13  libdispatch.dylib             	0x0000000188e9535c _dispatch_main_queue_callback_4CF$VARIANT$armv81 + 996
    14  CoreFoundation                	0x00000001891623c4 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 12
    15  CoreFoundation                	0x000000018915d3b8 __CFRunLoopRun + 2004
    16  CoreFoundation                	0x000000018915c8bc CFRunLoopRunSpecific + 464
    17  GraphicsServices              	0x0000000192fc8328 GSEventRunModal + 104
    18  UIKitCore                     	0x000000018d1f26d4 UIApplicationMain + 1936
    19  HelloNSInvocation             	0x0000000102bdf690 0x102bd8000 + 30352
    20  libdyld.dylib                 	0x0000000188fe7460 start + 4
    ```

    

    Crash日志3

    ```
    Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
    Exception Subtype: KERN_INVALID_ADDRESS at 0x0000000996c11a60
    VM Region Info: 0x996c11a60 is not in any region.  Bytes after previous region: 29909654113  
          REGION TYPE                      START - END             [ VSIZE] PRT/MAX SHRMOD  REGION DETAIL
          MALLOC_NANO            0000000280000000-00000002a0000000 [512.0M] rw-/rwx SM=PRV  
    --->  
          UNUSED SPACE AT END
    
    Termination Signal: Segmentation fault: 11
    Termination Reason: Namespace SIGNAL, Code 0xb
    Terminating Process: exc handler [16578]
    Triggered by Thread:  0
    
    Thread 0 name:  Dispatch queue: com.apple.main-thread
    Thread 0 Crashed:
    0   libobjc.A.dylib               	0x0000000188f27150 objc_release + 16
    1   UIKitCore                     	0x000000018c8dc630 -[_UIButtonBarButtonVisualProviderIOS _computeTextAttributesForBarButtonItem:] + 352
    2   UIKitCore                     	0x000000018c8dff94 -[_UIButtonBarButtonVisualProviderIOS configureButton:fromBarButtonItem:] + 168
    3   UIKitCore                     	0x000000018c8de058 -[_UIButtonBarButtonVisualProviderIOS configureButton:withAppearanceDelegate:fromBarItem:] + 124
    4   UIKitCore                     	0x000000018c8da3d4 -[_UIButtonBarButton _configureFromBarItem:appearanceDelegate:isBackButton:] + 88
    5   UIKitCore                     	0x000000018c8d9fe0 -[_UIButtonBarButton configureBackButtonFromBarItem:withAppearanceDelegate:] + 120
    6   UIKitCore                     	0x000000018c93ae1c -[_UINavigationBarContentView _setupBackButtonAnimated:] + 964
    7   UIKitCore                     	0x000000018c93eb58 -[_UINavigationBarContentView updateContentAnimated:] + 104
    8   UIKitCore                     	0x000000018c93ec34 -[_UINavigationBarContentView updateContent] + 32
    9   UIKitCore                     	0x000000018c93f148 -[_UINavigationBarContentView adoptLayout:] + 144
    10  UIKitCore                     	0x000000018c94c95c -[_UINavigationBarLayout finalizeStateFromTransition:] + 40
    11  UIKitCore                     	0x000000018c94e828 -[_UINavigationBarTransitionContext _resetContentAndLargeTitleViewCompleted:] + 48
    12  UIKitCore                     	0x000000018c94e874 -[_UINavigationBarTransitionContext complete] + 36
    13  UIKitCore                     	0x000000018c95341c -[_UINavigationBarTransitionContextPush complete] + 64
    14  UIKitCore                     	0x000000018c95e89c -[_UINavigationBarVisualProviderModernIOS _endTransitionCompleted:] + 316
    15  UIKitCore                     	0x000000018c960070 __96-[_UINavigationBarVisualProviderModernIOS _performAnimationWithTransitionCompletion:transition:]_block_invoke.699 + 52
    16  UIKitCore                     	0x000000018d670e84 -[UIViewAnimationBlockDelegate _didEndBlockAnimation:finished:context:] + 588
    17  UIKitCore                     	0x000000018d645148 -[UIViewAnimationState sendDelegateAnimationDidStop:finished:] + 244
    18  UIKitCore                     	0x000000018d645650 -[UIViewAnimationState animationDidStop:finished:] + 240
    19  QuartzCore                    	0x000000018fb7a4c0 CA::Layer::run_animation_callbacks+ 1447104 (void*) + 276
    20  libdispatch.dylib             	0x0000000188eb2184 _dispatch_client_callout + 16
    21  libdispatch.dylib             	0x0000000188e9535c _dispatch_main_queue_callback_4CF$VARIANT$armv81 + 996
    22  CoreFoundation                	0x00000001891623c4 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__ + 12
    23  CoreFoundation                	0x000000018915d3b8 __CFRunLoopRun + 2004
    24  CoreFoundation                	0x000000018915c8bc CFRunLoopRunSpecific + 464
    25  GraphicsServices              	0x0000000192fc8328 GSEventRunModal + 104
    26  UIKitCore                     	0x000000018d1f26d4 UIApplicationMain + 1936
    27  HelloNSInvocation             	0x0000000100817690 0x100810000 + 30352
    28  libdyld.dylib                 	0x0000000188fe7460 start + 4
    ```

* over release一般是延后执行的，因此Crash时的堆栈没有显示用户代码



### 使用Zombie Objects和Malloc Stack诊断调试over release内存问题[^1]



#### （1）开启Zombie Objects和Malloc Stack诊断

​        如果遇到上面Crash类型，并且是复现的，可以在Xcode的Edit Scheme > Diagnostics中，勾选Zombie Objects和Malloc Stack，并选择All Allocation and Free History。

<img src="images/开启Zombie Objects和Malloc Stack诊断.png" style="zoom:50%;" />

> 1. Zombie Objects用于检查deallocatd对象再次被访问，并在控制台中输出相关日志，例如
>
> ```shell
> *** -[CFString release]: message sent to deallocated instance 0x6000020ea2b0
> ```
>
> 2. Malloc Stack用于开启记录对象创建的日志，并写入到本地磁盘，开启后控制台有下面的提示
>
> ```
> malloc: stack logs being written into /tmp/stack-logs.9128.1218e0000.HelloNSInvocation.ijw6V1.index
> malloc: recording malloc and VM allocation stacks to disk using standard recorder
> ```



#### （2）在Crash时导入调试脚本获取malloc_info命令

在Crash时，在lldb中执行下面命令

```shell
(lldb) command script import lldb.macosx.heap
"malloc_info", "ptr_refs", "cstr_refs", "find_variable", and "objc_refs" commands have been installed, use the "--help" options on these commands for detailed help.
```

执行完上面脚本，可以使用malloc_info命令

> 1. malloc_info命令，默认不在lldb中，必须导入lldb.macosx.heap脚本才可以使用
> 2. malloc_info --help，可以查看帮助信息



#### （3）调试zombie object的地址

针对上面的zombie对象地址0x6000020ea2b0，可以使用malloc_info (address) -s来查malloc时的调用栈

```shell
(lldb) malloc_info 0x6000020ea2b0 -s
0x00006000020ea2b0: malloc(    48) -> 0x6000020ea2b0 _NSZombie_CFString
stack[0]: addr = 0x6000020ea2b0, type=malloc, frames:
     [0] 0x000000010b175b50 libsystem_malloc.dylib`malloc_zone_malloc + 139
     [1] 0x00000001095ccc63 CoreFoundation`_CFRuntimeCreateInstance + 275
     [2] 0x00000001095ed575 CoreFoundation`CFStringCreateMutable + 69
     [3] 0x00000001086dbd1f Foundation`+[NSString string] + 36
     [4] 0x00000001083298b6 HelloNSInvocation`-[OverReleaseViewController concatStringWithStringA:stringB:] + 102 at OverReleaseViewController.m:44:32
     [5] 0x000000010966b6ac CoreFoundation`__invoking___ + 140
     [6] 0x0000000109668c25 CoreFoundation`-[NSInvocation invoke] + 325
     [7] 0x00000001083297f6 HelloNSInvocation`-[OverReleaseViewController test_over_release] + 342 at OverReleaseViewController.m:39:10
     [8] 0x0000000108329698 HelloNSInvocation`-[OverReleaseViewController viewDidLoad] + 200 at OverReleaseViewController.m:22:1
     [9] 0x000000010bde60f7 UIKitCore`-[UIViewController loadViewIfRequired] + 1183
     [10] 0x000000010bde6524 UIKitCore`-[UIViewController view] + 27
     [11] 0x000000010bd35084 UIKitCore`-[UINavigationController _startCustomTransition:] + 929
     [12] 0x000000010bd4b006 UIKitCore`-[UINavigationController _startDeferredTransitionIfNeeded:] + 741
     [13] 0x000000010bd4c393 UIKitCore`-[UINavigationController __viewWillLayoutSubviews] + 150
     [14] 0x000000010bd2d041 UIKitCore`-[UILayoutContainerView layoutSubviews] + 217
     [15] 0x000000010c8c7e69 UIKitCore`-[UIView(CALayerDelegate) layoutSublayersOfLayer:] + 1417
     [16] 0x000000010de4ad22 QuartzCore`-[CALayer layoutSublayers] + 173
     [17] 0x000000010de4f9fc QuartzCore`CA::Layer::layout_if_needed(CA::Transaction*) + 396
     [18] 0x000000010de5bd58 QuartzCore`CA::Layer::layout_and_display_if_needed(CA::Transaction*) + 72
     [19] 0x000000010ddcb24a QuartzCore`CA::Context::commit_transaction(CA::Transaction*) + 328
     [20] 0x000000010de02606 QuartzCore`CA::Transaction::commit() + 610
     [21] 0x000000010c41099c UIKitCore`_afterCACommitHandler + 245
     [22] 0x00000001095cb2c7 CoreFoundation`__CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__ + 23
     [23] 0x00000001095c578e CoreFoundation`__CFRunLoopDoObservers + 430
     [24] 0x00000001095c5e01 CoreFoundation`__CFRunLoopRun + 1505
     [25] 0x00000001095c54d2 CoreFoundation`CFRunLoopRunSpecific + 626
     [26] 0x0000000111c162fe GraphicsServices`GSEventRunModal + 65
     [27] 0x000000010c3e8fc2 UIKitCore`UIApplicationMain + 140
     [28] 0x00000001083299bd HelloNSInvocation`main + 125 at main.m:18:12
     [29] 0x000000010af4a541 libdyld.dylib`start + 1
     [30] 0x00000001123bfdc1 dyld`_main_thread + 1
```

​        通过上面的调用栈，基本可以定位到OverReleaseViewController.m:44这一行，有创建一个NSString对象，然后这个对象被over release。

​        检查下面代码，发现returnObject的类型是id，在ARC下，returnObject持有的对象确实会被释放两次。一次是在concatStringWithStringA:stringB:方法中，该对象本身是autorelease，当被赋值给returnObject，该对象也会调用release。

```objective-c
- (void)test_over_release {
    id returnObject = nil;
    SEL selector = @selector(concatStringWithStringA:stringB:);
    id arg1 = @"A";
    id arg2 = @"B";
    
    if ([self respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
        invocation.target = self;
        invocation.selector = selector;
        
        [invocation setArgument:&arg1 atIndex:2];
        [invocation setArgument:&arg2 atIndex:3];
        
        [invocation invoke];
        [invocation getReturnValue:&returnObject];
    }
}

- (NSString *)concatStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB {
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:stringA];
    [stringM appendString:stringB];
    
    return stringM;
}
```

上面的代码，只是over release的一个case，并代表所有over release都是这样的代码。



> 1. 示例代码见OverReleaseViewController
> 2. 在test_over_release方法加上@autorelease{}，用于加快对象释放，这样更早触发over release，而且crash处不再是UIApplicationMain函数。







## References

[^1]:https://medium.com/mindorks/zombies-coders-dad22679b93a

