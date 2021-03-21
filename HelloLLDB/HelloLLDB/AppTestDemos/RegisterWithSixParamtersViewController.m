//
//  RegisterWithSixParamtersViewController.m
//  HelloLLDB
//
//  Created by wesley_chen on 12/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "RegisterWithSixParamtersViewController.h"

@interface RegisterWithSixParamtersViewController ()

@end

// RDI、RSI、RDX、RCX、R8、R9，存放方法（函数）的前6个参数，从第7个参数开始用栈来存放。
@implementation RegisterWithSixParamtersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_register_read];
    
    NSLog(@"HOME env: %s", getenv("HOME"));
}

- (void)test_register_read {
    // Note: br set -K false -S "-[RegisterWithSixParamtersViewController methodWithArg3:arg4:arg5:arg6:]"
    NSString *returnVal = [self methodWithArg3:@"3" arg4:@"4" arg5:@"5" arg6:@"6"];
    NSLog(@"returnVal: %@", returnVal);
}

- (NSString *)methodWithArg3:(NSString *)arg3 arg4:(NSString *)arg4 arg5:(NSString *)arg5 arg6:(NSString *)arg6
{
/* arch = x86_64
 ====================================
(lldb) register read
General Purpose Registers:
       rax = 0x0000000101f2c210  @"'5'"
       rbx = 0x000000010327a9dd  "count"
       rcx = 0x0000000101f2c1f0  @"'4'"
       rdx = 0x0000000101f2c1d0  @"'3'"
       rdi = 0x00007fcd96d19810
       rsi = 0x0000000101f2b273  "methodWithArg3:arg4:arg5:arg6:"
       rbp = 0x00007ffeedcd2370
       rsp = 0x00007ffeedcd2338
        r8 = 0x0000000101f2c210  @"'5'"
        r9 = 0x0000000101f2c230  @"'6'"
       r10 = 0x00c6e50100c64600
       r11 = 0x0000000101f2a2c0  HelloLLDB`-[RegisterWithSixParamtersViewController methodWithArg3:arg4:arg5:arg6:] at RegisterWithSixParamtersViewController.m:27
       r12 = 0x0000000000000018
       r13 = 0x00007fcd96d19810
       r14 = 0x0000000104b9d7e4  UIKit`_UIApplicationLinkedOnVersion
       r15 = 0x0000000102844980  libobjc.A.dylib`objc_msgSend
       rip = 0x0000000101f2a2c0  HelloLLDB`-[RegisterWithSixParamtersViewController methodWithArg3:arg4:arg5:arg6:] at RegisterWithSixParamtersViewController.m:27
    rflags = 0x0000000000000246
        cs = 0x000000000000002b
        fs = 0x0000000000000000
        gs = 0x0000000000000000

(lldb) po $rdi
<RegisterWithSixParamtersViewController: 0x7fcd96d19810>
 */

    
/* arch = arm64
 ====================================
(lldb) register read
General Purpose Registers:
        x0 = 0x0000000100427bb0
        x1 = 0x00000001000fef84  "methodWithArg3:arg4:arg5:arg6:"
        x2 = 0x0000000100100228  @"'3'"
        x3 = 0x0000000100100248  @"'4'"
        x4 = 0x0000000100100268  @"'5'"
        x5 = 0x0000000100100288  @"'6'"
        x6 = 0x0000000000000000
        x7 = 0x00000000ffffffff
        x8 = 0x0000000100100228  @"'3'"
        x9 = 0x00000001b7f6cfec  runtimeLock + 28
       x10 = 0x00000001b7f6cff0  runtimeLock + 32
       x11 = 0x0080880100808880
       x12 = 0x0000000000000000
       x13 = 0x0000000000808800
       x14 = 0x0000000000808900
       x15 = 0x00000000008088c0
       x16 = 0x0000000000808801
       x17 = 0x00000001000fc22c  HelloLLDB`-[RegisterWithSixParamtersViewController methodWithArg3:arg4:arg5:arg6:] at RegisterWithSixParamtersViewController.m:29
       x18 = 0x0000000000000000
       x19 = 0x00000001b7ff8950  UIKit`_UIApplicationLinkedOnVersion
       x20 = 0x0000000100427bb0
       x21 = 0x0000000000000018
       x22 = 0x000000019891295f  "count"
       x23 = 0x0000000000000000
       x24 = 0x0000000100427bb0
       x25 = 0x0000000000000000
       x26 = 0x0000000198920ffe  "didMoveToParentViewController:"
       x27 = 0x0000000100401550
       x28 = 0x0000000100312790
        fp = 0x000000016fd09120
        lr = 0x00000001000fc1e8  HelloLLDB`-[RegisterWithSixParamtersViewController test_register_read] + 88 at RegisterWithSixParamtersViewController.m:25
        sp = 0x000000016fd09100
        pc = 0x00000001000fc22c  HelloLLDB`-[RegisterWithSixParamtersViewController methodWithArg3:arg4:arg5:arg6:] at RegisterWithSixParamtersViewController.m:29
      cpsr = 0x60000000

(lldb) po $x0
<RegisterWithSixParamtersViewController: 0x100427bb0>
 */
    
#if DEBUG
    NSLog(@"%@:%@ (breakpoint): %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], @(__LINE__), @"expect never hit this line. Please check your parameters and type `continue` to resume. And this information only for Debug, never show on Release");
    raise(SIGTRAP); // __builtin_trap();
#endif
    NSLog(@"do something");
    return @"7";
}

@end
