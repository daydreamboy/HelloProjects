## HelloLLDB

1. lldb手册
2. lldbinit配置
3. lldb快捷键
4. Call Convention

## lldb手册

1. print
2. po（print object）
3. print/<fmt>
4. expression
5. continue
6. thread
7. type（TODO）
8. finish
9. frame
10. command
	 * command alias
	 * command regex
11. TODO
12. breakpoint
	 * breakpoint set
	 * breakpoint list
	 * breakpoint enable/disable
	 * breakpoint delete
	 * breakpoint command add/delete/list
	 * breakpoint modify
13. 执行简单的代码片段
14. 设置UIView的frame
15. register
16. lldb attach进程
17. lldb target
18. lldb查看命令帮助
19. lldb启动可执行文件
20. lldb常用快捷键
21. image
22. run

----------------------


### 1、print

格式：print <expression>    
简写：p     
说明：print是expression --的别名，后面不能加选项    
例子：    

```
(lldb) p @[@"foo", @"bar"]
(__NSArrayI *) $4 = 0x00000001028010f0 @"2 elements"
```

### 2、po（print object）

格式：po <expression>    
简写：po    
说明：po是expression -O --的别名，用于调用对象的debugDescription方法    
例子：

```
(lldb) e -O -- $4
<__NSArrayI 0x1028010f0>(
foo,
bar
)
```

### 3、print/\<fmt\>

格式：    

* p/x，以十六进制打印
* p/t，以二进制打印，t代表two
* p/d，以十进制打印
* 其他的有p/c，p/s等

例子：

```
(lldb) p 16
(int) $5 = 16
(lldb) p/x 16
(int) $6 = 0x00000010
(lldb) p/t 16
(int) $7 = 0b00000000000000000000000000010000
(lldb) p/t (char)16
(char) $8 = 0b00010000
```

### 4、expression
格式：expression <expression>    
简写：e    
说明：expression是比较复杂的命令，后面可以加选项。     
例子：

* 执行表达式

```
(lldb) e int $a = 2
(lldb) e $a
(int) $a = 2
(lldb) e $a * 19
(int) $0 = 38
(lldb) e NSArray *$array = @[ @"Saturday", @"Sunday", @"Monday" ]
(lldb) e $array
(__NSArrayI *) $array = 0x0000000100700ee0 @"3 elements"
(lldb) p $array
(__NSArrayI *) $array = 0x0000000100700ee0 @"3 elements"
(lldb) po $array
<__NSArrayI 0x100700ee0>(
Saturday,
Sunday,
Monday
)
```

* expression对方法的返回值严格检查，需要加上返回值类型

```
(lldb) e [[$array objectAtIndex:0] uppercaseString]
error: no known method '-uppercaseString'; cast the message send to the method's return type
(lldb) e (NSString *)[[$array objectAtIndex:0] uppercaseString]
(NSTaggedPointerString *) $1 = 0x005325e6621cbe85 @"SATURDAY"
```

* 执行简单的代码片段

```
(lldb) e char *$str = (char *)malloc(8)
(lldb) e $str
(char *) $str = 0x0000000100100020 <no value available>
(lldb) e (void)strcpy($str, "munkeys")
(lldb) e $str
(char *) $str = 0x0000000100100020 "munkeys"
(lldb) e $str[1] = 'o'
(char) $0 = 'o'
(lldb) e $str
(char *) $str = 0x0000000100100020 "monkeys"
(lldb) x/4c $str
error: reading memory as characters of size 4 is not supported
(lldb) x/c $str
0x100100020: monk
(lldb) x/1w `$str + 3`
0x100100023: keys
(lldb) e (void)free($str)
(lldb) e $str
(char *) $str = 0x0000000100100020 "monkeys"
```

* 设置UIView的frame

```
e [v setFrame:(CGRect){0, 0, 100, 100}] 
```

参考：   
https://stackoverflow.com/questions/27533709/how-to-set-the-frame-of-a-uiview-at-runtime-using-lldb-expr-debugging-console

* 执行方法，触发breakpoint

格式：expr -i 0 -- \<objC code\>    
说明：    
调试时lldb默认不会触发Xcode设置的breakpoint。

```
expr -i 0 -- [self areaNbr]
```

参考：    
https://stackoverflow.com/questions/35861198/xcode-not-stopping-on-breakpoint-in-method-called-from-lldb

### 5、continue

格式：continue    
简写：c     
continue不带参数，是process continue的别名。debug时，代表当前进程恢复执行

### 6、thread

##### (1) 当前线程单步执行

格式：thread step-over    
简写：n，next    
n不带参数。debug时，代表单步执行

##### (2) 当前线程单步进入函数

格式：thread step-in    
简写：s，step    
s不带参数。debug时，代表单步进入    
补充：   
1) 和thread step-in相反的操作，跳出函数，则是finish命令     
2) step -a0，忽略lldb设置，总是单步进入

##### (3) 当前线程中止后面的执行，提前返回到函数入口

格式：thread return <optional retVal>    
thread return带一个可选的返回值，如果执行，当前函数立即返回，剩下的代码不会执行。     
注意：和finish不一样，finish是执行完当前函数才返回。由于提前返回，有可能ARC相关内存问题

##### (4) 列出当前所有线程

格式：thread list

```
(lldb) thread list
Process 15767 stopped
* thread #1: tid = 0x5bf9ba, 0x000000010ff0cf10 Commons`__34+[UnixSignalHandler sharedHandler]_block_invoke((null)=0x0000000113cc8470) at UnixSignalHandler.m:68, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
  thread #2: tid = 0x5bfa09, 0x0000000115fa5562 libsystem_kernel.dylib`__workq_kernreturn + 10
  thread #3: tid = 0x5bfa0a, 0x0000000115fa5562 libsystem_kernel.dylib`__workq_kernreturn + 10
  thread #4: tid = 0x5bfa0b, 0x0000000115fdac40 libsystem_pthread.dylib`start_wqthread
  thread #5: tid = 0x5bfa0c, 0x0000000115fa5562 libsystem_kernel.dylib`__workq_kernreturn + 10
  thread #6: tid = 0x5bfa13, 0x0000000115f9b7c2 libsystem_kernel.dylib`mach_msg_trap + 10, name = 'com.apple.uikit.eventfetch-thread'
  thread #8: tid = 0x5bfa15, 0x0000000115fa5562 libsystem_kernel.dylib`__workq_kernreturn + 10
```

### 7、TODO

### 8、finish

格式：finish    
说明：debug时，代表执行完当前函数或者方法，然后跳到调用处，这时可以查看RAX寄存器    
参考资料：    
https://www.objc.io/issues/19-debugging/lldb-debugging/

### 9、frame

##### (1) 显示当前执行点的信息，例如对应源文件的行号等

格式：frame info    

```
(lldb) frame info
frame #0: 0x0000000100000ecf flow_control`main(argc=1, argv=0x00007fff5fbff7e0) + 63 at main.m:25
```

##### (2) 查看特定的frame。 

格式：frame select <frame No.>    
说明：frame info只显示第0个frame。这里的序号，对应thread backtrace输出的frame序号。

```
(lldb) frame select 1
frame #1: 0x0000000115b1533d libdispatch.dylib`_dispatch_client_callout + 8
libdispatch.dylib`_dispatch_client_callout:
    0x115b1533d <+8>:  addq   $0x8, %rsp
    0x115b15341 <+12>: popq   %rbx
    0x115b15342 <+13>: popq   %rbp
    0x115b15343 <+14>: retq 
```

##### (3) 查看当前frame的所有变量

格式：frame variable

```
(lldb) frame variable
(__block_literal_1 *)  = 0x0000000113cc8470
```

##### (4) 查看特定变量

格式：frame variable -F self

### 10、command

####（1）command alias

格式：command alias \<alias name\> \<command\>/\<expr\>    
说明：command alias的作用是，定义命令或者表达式的别名，用于简化输入的命令

定义别名Yay_Autolayout

```
command alias -- Yay_Autolayout expression -l objc -O --
[[[[[UIApplication sharedApplication] keyWindow] rootViewController]
view] recursiveDescription]
```
>
`--`的作用是不让后面-l -O等当成command alias命令的选项

定义别名Yay\_Autolayout，同时提供help信息。-H对应help Yay\_Autolayout的输出；-h对应直接help的输出

```
command alias -H "Yay_Autolayout will get the root view and recursively
dump all the subviews and their frames" -h "Recursively dump views" --
Yay_Autolayout expression -l objc -O -- [[[[[UIApplication
sharedApplication] keyWindow] rootViewController] view]
recursiveDescription]
```

定义别名cpo，并接收一个参数。注意：使用command alias只能支持一个参数，而且在末尾拼接。如果动态参数在命令中间，需要使用command regex命令。

```
command alias cpo expression -l objc -O --
```

定义别名cpx，接收一个参数

```
command alias -H "Print value in ObjC context in hexadecimal" -h "Print
in hex" -- cpx expression -f x -l objc --
```

####（2）command regex

格式：command regex \<alias name\> 's/<regex>/<subst>/'
说明：command regex命令，根据regex抽取参数，同时替换到subst中。这样构成接收动态参数的命令subst。

定义别名rlook，它接收一个按照(.+)匹配的参数%1，构成命令image lookup -rn \<%1\>

```
command regex rlook 's/(.+)/image lookup -rn %1/'

// rlook FOO => image lookup -rn FOO
```

定义别名tv，它接收一个参数，执行一段代码

```
command regex -- tv 's/(.+)/expression -l objc -O -- @import
QuartzCore; [%1 setHidden:!(BOOL)[%1 isHidden]]; (void)[CATransaction
flush];/'
```

定义别名getcls，它接收以0-9或者@或者[开头的字符串，构成命令cpo [%1 class]，cpo是另一个命令或者别名

```
command regex getcls 's/(([0-9]|\$|\@|\[).*)/cpo [%1 class]/'
```

定义别名getcls，定义两个regex，执行两个命令cpo [%1 class]和expression -l swift -O -- type(of: %1)

```
command regex getcls 's/(([0-9]|\$|\@|\[).*)/cpo [%1 class]/' 's/
(.+)/expression -l swift -O -- type(of: %1)/'
```

### 11、TODO

### 12、TODO

### 13、breakpoint

####（1）breakpoint set

格式：breakpoint set [options] \<arguments\>

常用选项：

* -o \<boolean\> (--one-shot \<boolean\>)，设置一次性断点，当触发断点，断点自动删除掉
* -S \<selector\> (--selector \<selector\>)，根据Objective-C的selector（例如"-[ViewController viewDidLoad]"）设置断点

```
(lldb) breakpoint set -S -[RegisterWithSixParamtersViewController\ viewDidLoad]
(lldb) breakpoint set -S "-[RegisterWithSixParamtersViewController viewDidLoad]"
```
Tips:
>
直接复制代码中方法的selector，`⌘ + ⇧ + ⎇ + ^ + c`

* -K \<boolean\> (--skip-prologue \<boolean\>)，触发断点时是否自动跳过prologue。默认是跳过的，可以设置false，这样触发断点时总是停在汇编第一条指令处。

```
(lldb) br set -K false -S '-[RegisterWithSixParamtersViewController methodWithArg3:arg4:arg5:arg6:]'
```

* -r \<regular expression\>，简写rb \<regular expression\>，正则匹配符号，设置断点

匹配特定的符号

```
(lldb) rb SwiftTestClass.name.setter
(lldb) rb name\.setter
(lldb) rb '\-\[UIViewController\ '
```

匹配所有的符号

```
(lldb) rb .
```

匹配在特定module中所有的符号

```
(lldb) rb . -s UIKit
```

匹配在特定module中所有的符号，而且断点是一次性的

```
(lldb) rb . -s UIKit -o
```

例子：

* 指定文件和行号，设置断点

```
(lldb) breakpoint set -f main.m -l 16
Breakpoint 1: where = DebuggerDance`main + 27 at main.m:16, address = 0x000000010a3f6cab

(lldb) b main.m:17
Breakpoint 2: where = DebuggerDance`main + 52 at main.m:17, address = 0x000000010a3f6cc4
```

* 指定C函数的符号，设置断点

```
(lldb) b isEven
Breakpoint 3: where = DebuggerDance`isEven + 16 at main.m:4, address = 0x000000010a3f6d00
(lldb) br s -F isEven
Breakpoint 4: where = DebuggerDance`isEven + 16 at main.m:4, address = 0x000000010a3f6d00
```

* 指定OC方法的符号，设置断点

```
(lldb) breakpoint set -F "-[NSArray objectAtIndex:]"
Breakpoint 5: where = CoreFoundation`-[NSArray objectAtIndex:], address = 0x000000010ac7a950
(lldb) b -[NSArray objectAtIndex:]
Breakpoint 6: where = CoreFoundation`-[NSArray objectAtIndex:], address = 0x000000010ac7a950
(lldb) breakpoint set -F "+[NSSet setWithObject:]"
Breakpoint 7: where = CoreFoundation`+[NSSet setWithObject:], address = 0x000000010abd3820
(lldb) b +[NSSet setWithObject:]
Breakpoint 8: where = CoreFoundation`+[NSSet setWithObject:], address = 0x000000010abd3820
```

注意：上面的命令方式，仅在当前debug session中生效，并没有同步到Xcode的breakpoint中

####（2）breakpoint list

格式：breakpoint list    
简写：br li    
说明：显示当前所有文件的断点（包括多个target）    
例子：

```
(lldb) br li
Current breakpoints:
1: file = '/Users/arig/Desktop/DebuggerDance/DebuggerDance/main.m', line = 16, locations = 1, resolved = 1, hit count = 1

  1.1: where = DebuggerDance`main + 27 at main.m:16, address = 0x000000010a3f6cab, resolved, hit count = 1
```

####（3）breakpoint enable/disable

格式：breakpoint enable/disable \<breakpointID\>    
说明：启用和禁用某个断点
例子：

```
(lldb) br dis 1
1 breakpoints disabled.
(lldb) br li
Current breakpoints:
1: file = '/Users/arig/Desktop/DebuggerDance/DebuggerDance/main.m', line = 16, locations = 1 Options: disabled

  1.1: where = DebuggerDance`main + 27 at main.m:16, address = 0x000000010a3f6cab, unresolved, hit count = 1
```

####（4）breakpoint delete

格式：breakpoint delete \<breakpoint ID\> 

删除特定断点

```
(lldb) br del 1
1 breakpoints deleted; 0 breakpoint locations disabled.
(lldb) br li
No breakpoints currently set.
```

删除全部断点

```
(lldb) br delete
About to delete all breakpoints, do you want to do that?: [Y/n] Y
All breakpoints removed. (3 breakpoints)
```

####（5）breakpoint command add/delete/list

格式：breakpoint command \<subcommand\>   
说明：subcommand有add、delete和list三个子命令

* 设置断点，触发后继续执行 （实际上，添加空的脚本）

```
(lldb) breakpoint command add 1
Enter your debugger command(s).  Type 'DONE' to end.
> continue
> DONE
(lldb) br li 1
1: name = 'isEven', locations = 1, resolved = 1, hit count = 0
    Breakpoint commands:
      continue

  1.1: where = DebuggerDance`isEven + 16 at main.m:4, address = 0x00000001083b5d00, resolved, hit count = 0
```

* 设置断点的脚本，以及触发条件(-c)

```
(lldb) breakpoint set -F isEven
Breakpoint 1: where = DebuggerDance`isEven + 16 at main.m:4, address = 0x00000001083b5d00
(lldb) breakpoint modify -c 'i == 99' 1
(lldb) breakpoint command add 1
Enter your debugger command(s).  Type 'DONE' to end.
> p i
> DONE
(lldb) br li 1
1: name = 'isEven', locations = 1, resolved = 1, hit count = 0
    Breakpoint commands:
      p i

Condition: i == 99

  1.1: where = DebuggerDance`isEven + 16 at main.m:4, address = 0x00000001083b5d00, resolved, hit count = 0 
```

#### (6) breakpoint modify

格式：breakpoint modify [options]    
常用选项：

* -c \<expr\> (--condition \<expr\>)，设置断点触发条件

```
(lldb) breakpoint modify 1 -c "(BOOL)[$rdi isKindOfClass:[NSTextView
class]]"
```

### 15、register

格式：register \<subcommand\> [options]    
说明：子命令有read和write两个

#### (1) register read

格式：register read [options] \<register name\>
常用选项： 

* 没有选项，输出通用寄存器值

```
(lldb) register read
```

* 读取特定寄存器的值

```
(lldb) register read rax
```

* -f d，以十进制格式输出当前寄存器值

```
(lldb) register read -f d
```

* -a，输出所有寄存器值

```
(lldb) register read -a
```

包括General Purpose Registers、Floating Point Registers和Exception State Registers。

#### (2) register write

格式：register write \<register name\> \<value\>

```
(lldb) register write rip 0x100008a70
```

修改rip寄存器，必须在进入函数的第一行指令时，用于跳转到其他函数。0x100008a70是另一个函数的加载地址，函数加载地址，可以使用image -rvn \<function name\>搜索出来。

### 16、lldb attach进程

格式：lldb -n \<process name\>

```
$ lldb -n Finder
(lldb) process attach --name "Finder"
error: attach failed: cannot attach to process due to System Integrity Protection
```

一般不能debug经过Apple签名的程序，需要禁用System Integrity Protection。    
步骤如下：

* 重启macOS，屏幕变黑时，按住⌘+R直到出现Logo
* Utilities -> Terminal，输入`csrutil disable; reboot`

### 17、target

lldb中有target概念，指的是调试的目标，可以存在多个调试目标。直接输入lldb，进入lldb调试，没有任何target。

```
(lldb) target list
No targets.
```

target有几个子命令

* target create，指定到一个可执行文件，创建target。有别名file命令。

```
(lldb) target create -d /Applications/Xcode.app/Contents/MacOS/Xcode
Current executable set to '/Applications/Xcode.app/Contents/MacOS/Xcode' (x86_64).
```

或者

```
(lldb) file /Applications/Xcode.app/Contents/MacOS/Xcode
Current executable set to '/Applications/Xcode.app/Contents/MacOS/Xcode' (x86_64).
```

* target list，列出所有的target

```
(lldb) target list
Current targets:
  target #0: <none> ( platform=host )
  target #1: <none> ( platform=host )
* target #2: /Applications/Xcode.app/Contents/MacOS/Xcode ( arch=x86_64-apple-macosx, platform=host )
```

* target delete，删除某个target

```
(lldb) target delete 0
1 targets deleted.
```

* target select，设置当前target

```
(lldb) target select 1
Current targets:
  target #0: <none> ( platform=host )
* target #1: /Applications/Xcode.app/Contents/MacOS/Xcode ( arch=x86_64-apple-macosx, platform=host )
```

### 18、lldb查看命令帮助

* 查看命令帮助

```
(lldb) help <command>
```

* 查看子命令帮助

```
(lldb) help <command> <subcommand>
```

### 19、lldb启动可执行文件

```
(lldb) process launch -e /dev/ttys027 --
```

* 启动当前target，结合target命令使用
* -e，将stderr定向到/dev/ttys027文件

### 20、lldb常用快捷键

* Ctrl + c，暂停当前进程

### 21、image

格式：image \<subcommand\>    
说明：image是target module的简写    
常用子命令：list、lookup、dump等

#### (1) image list

列出所有module

```
(lldb) image list
[  0] 65E8199C-E9B4-3A6D-8800-84FFFFDE0C19 0x0000000104b8d000 /Users/wesley_chen/Library/Developer/Xcode/DerivedData/Signals-ezwjdgxtmgvixuaawmjotragooie/Build/Products/Debug-iphonesimulator/Signals.app/Signals 
[  1] 6695F30B-4E88-3C0B-9867-7D738C44A3E6 0x0000000108cab000 /usr/lib/dyld 
[  2] 0846E6B8-AF93-38F4-86B8-EE1548F71A43 0x0000000104bbc000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/usr/lib/dyld_sim 
```

查看特定的module

```
(lldb) image list Foundation
[  0] AFD58A66-011A-3575-8D12-AC868A4D0157 0x0000000104eb1000 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/Foundation.framework/Foundation 
```

>
输出格式，如`<UUID> <load address> <binary file path>`    
UUID，image的唯一标识符，用于查找对应的符号信息    
load address，在进程的内存空间中的加载地址    
binary file path，二进制文件的文件路径

#### (2) image dump

查看特定module的符号信息

```
(lldb) image dump symtab UIKit -s address
```

>   
-s address，表示按照address排序

#### (3) image lookup

格式：image lookup [options] \<regex\>

* -n，搜索特定的符号名

```
(lldb) image lookup -n "-[UIViewController viewDidLoad]"
1 match found in /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/UIKit.framework/UIKit:
        Address: UIKit[0x00000000001d1df6] (UIKit.__TEXT.__text + 1900502)
        Summary: UIKit`-[UIViewController viewDidLoad]
```

* -rn，正则匹配搜索特定的符号名

```
(lldb) image lookup -rn UIViewController
(lldb) image lookup -rn '\[UIViewController\ '
(lldb) image lookup -rn '\[UIViewController\(\w+)\ '
```

* -rn \<function name\>\_block\_invoke\_\<order number\> \<module name\>，正则匹配搜索的block符号

	* \_block\_invoke，是block的符号    
	* function name，是block所在的函数    
	* order number，如果函数中有多个block，则number是序号，但是第一个block序号不是0或1，而直接是<function name>\_block\_invoke，第二个block则是<function name>\_block\_invoke\_2。注意是从2开始的。    
	* module name，指定特定module    

```
(lldb) image lookup -rn _block_invoke
(lldb) image lookup -rn _block_invoke Commons
6 matches found in /Users/wesley_chen/Library/Developer/Xcode/DerivedData/Signals-ezwjdgxtmgvixuaawmjotragooie/Build/Products/Debug-iphonesimulator/Signals.app/Frameworks/Commons.framework/Commons:
        Address: Commons[0x0000000000002340] (Commons.__TEXT.__text + 1216)
        Summary: Commons`__32-[UnixSignalHandler initPrivate]_block_invoke at UnixSignalHandler.m:78        Address: Commons[0x00000000000025b0] (Commons.__TEXT.__text + 1840)
        Summary: Commons`__32-[UnixSignalHandler initPrivate]_block_invoke.27 at UnixSignalHandler.m:105        Address: Commons[0x0000000000001f00] (Commons.__TEXT.__text + 128)
        Summary: Commons`__34+[UnixSignalHandler sharedHandler]_block_invoke at UnixSignalHandler.m:67        Address: Commons[0x0000000000002770] (Commons.__TEXT.__text + 2288)
        Summary: Commons`__38-[UnixSignalHandler appendSignal:sig:]_block_invoke at UnixSignalHandler.m:119        Address: Commons[0x00000000000027b0] (Commons.__TEXT.__text + 2352)
        Summary: Commons`__38-[UnixSignalHandler appendSignal:sig:]_block_invoke_2 at UnixSignalHandler.m:123        Address: Commons[0x0000000000002b30] (Commons.__TEXT.__text + 3248)
        Summary: Commons`__38-[UnixSignalHandler appendSignal:sig:]_block_invoke_3 at UnixSignalHandler.m:135
```

* -v，输出详细信息

```
(lldb) image lookup -rvn "\-\[RegisterWithSixParamtersViewController\ viewDidLoad]"
1 match found in /Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloLLDB-eqmlveobenalktcpgudrgrnfyltk/Build/Products/Debug-iphonesimulator/HelloLLDB.app/HelloLLDB:
        Address: HelloLLDB[0x0000000100002380] (HelloLLDB.__TEXT.__text + 4816)
        Summary: HelloLLDB`-[RegisterWithSixParamtersViewController viewDidLoad] at RegisterWithSixParamtersViewController.m:18
         Module: file = "/Users/wesley_chen/Library/Developer/Xcode/DerivedData/HelloLLDB-eqmlveobenalktcpgudrgrnfyltk/Build/Products/Debug-iphonesimulator/HelloLLDB.app/HelloLLDB", arch = "x86_64"
    CompileUnit: id = {0x00000000}, file = "/Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloLLDB/HelloLLDB/AppTestDemos/RegisterWithSixParamtersViewController.m", language = "objective-c"
       Function: id = {0x50000006f}, name = "-[RegisterWithSixParamtersViewController viewDidLoad]", range = [0x00000001095bb380-0x00000001095bb3cf)
       FuncType: id = {0x50000006f}, decl = RegisterWithSixParamtersViewController.m:18, compiler_type = "void (void)"
         Blocks: id = {0x50000006f}, range = [0x1095bb380-0x1095bb3cf)
      LineEntry: [0x00000001095bb380-0x00000001095bb394): /Users/wesley_chen/GitHub_Projcets/HelloProjects/HelloLLDB/HelloLLDB/AppTestDemos/RegisterWithSixParamtersViewController.m:18
         Symbol: id = {0x00000081}, range = [0x00000001095bb380-0x00000001095bb3d0), name="-[RegisterWithSixParamtersViewController viewDidLoad]"
       Variable: id = {0x50000008d}, name = "self", type = "RegisterWithSixParamtersViewController *const", location =  DW_OP_fbreg(-8), decl = 
       Variable: id = {0x50000009a}, name = "_cmd", type = "SEL", location =  DW_OP_fbreg(-16), decl = 
```

Blocks一行，range表示函数的加载地址范围，[0x1095bb380-0x1095bb3cf)，左闭右开

![函数的加载地址范围.png](images/函数的加载地址范围.png)

### 22、run

```
(lldb) run
```

说明：不编译app，直接重新启动app

## lldbinit配置

<b>（1）加载.lldbinit文件</b>

LLDB使用.lldbinit-[context]文件，来初始化一些LLDB配置。LLDB按照下面顺序，查找.lldbinit-[context]文件

1\. 根据上下文环境，查找~/.lldbinit-[context]文件。例如Xcode中的lldb，优先使用`~/.lldbinit-Xcode`文件；Terminal中的lldb，优先使用`~/.lldbinit-lldb`文件

2\. 如果没有.lldbinit-[context]文件，则使用`~/.lldbinit`文件

3\. 如果没有~/.lldbinit文件，则使用根目录下的`.lldbinit`文件

推荐使用方式1和2

<b>（2）.lldbinit文件的配置项</b>

* 配置LLDB显示汇编代码，用Intel形式

```
settings set target.x86-disassembly-flavor intel
```

LLDB默认使用AT&T形式，显示汇编代码。

Intel格式和AT&T格式的区别

1. Intel格式交换了指令的source和destination，即opcode dest, src
2. Intel格式移除了$和%符号


* 设置不跳过函数的prologue

```
settings set target.skip-prologue false
```


## lldb快捷键

* `^ + c`，暂停当前进程
* `^ + d`，结束输入


## Call Convention

#### x86_64

* RDI、RSI、RDX、RCX、R8、R9，存放方法（函数）的前6个参数，从第7个参数开始用栈来存放。
* RAX，存放方法（函数）的返回值
* RIP，存放当前指令的地址，如下
![$RIP的作用.png](images/$RIP的作用.png)


#### ARM64

* x0-x7，存放方法（函数）的前8个参数，具体个数视调试而定
* x0，存放方法（函数）的返回值

