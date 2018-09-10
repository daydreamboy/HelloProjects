//
//  RegisterWithMoreSixParametersViewController.m
//  HelloLLDB
//
//  Created by wesley_chen on 12/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "RegisterWithMoreSixParametersViewController.h"

@interface RegisterWithMoreSixParametersViewController ()

@end

@implementation RegisterWithMoreSixParametersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_register_read];
}

- (void)test_register_read {
    // Note: br set -K false -S "-[RegisterWithMoreSixParametersViewController methodWithArg3:arg4:arg5:arg6:arg7:arg8:]"
    NSString *returnVal = [self methodWithArg3:@"3" arg4:@"4" arg5:@"5" arg6:@"6" arg7:@"7" arg8:@"8"];
    NSLog(@"returnVal: %@", returnVal);
}

- (NSString *)methodWithArg3:(NSString *)arg3 arg4:(NSString *)arg4 arg5:(NSString *)arg5 arg6:(NSString *)arg6 arg7:(NSString *)arg7 arg8:(NSString *)arg8
{
/*
(lldb) register read
General Purpose Registers:
       rax = 0x000000010ce9a0f0  @"'5'"
       rbx = 0x000000010ce9a130  @"'7'"
       rcx = 0x000000010ce9a0d0  @"'4'"
       rdx = 0x000000010ce9a0b0  @"'3'"
       rdi = 0x00007fcaf650bd70
       rsi = 0x000000010ce98451  "methodWithArg3:arg4:arg5:arg6:arg7:arg8:"
       rbp = 0x00007ffee2d64370
       rsp = 0x00007ffee2d64308
        r8 = 0x000000010ce9a0f0  @"'5'"
        r9 = 0x000000010ce9a110  @"'6'"
       r10 = 0x0098e70100984600
       r11 = 0x000000010ce96ff0  HelloLLDB`-[RegisterWithMoreSixParametersViewController methodWithArg3:arg4:arg5:arg6:arg7:arg8:] at RegisterWithMoreSixParametersViewController.m:28
       r12 = 0x0000000000000018
       r13 = 0x00007fcaf650bd70
       r14 = 0x000000010fb0b7e4  UIKit`_UIApplicationLinkedOnVersion
       r15 = 0x000000010d7b2980  libobjc.A.dylib`objc_msgSend
       rip = 0x000000010ce96ff0  HelloLLDB`-[RegisterWithMoreSixParametersViewController methodWithArg3:arg4:arg5:arg6:arg7:arg8:] at RegisterWithMoreSixParametersViewController.m:28
    rflags = 0x0000000000000246
        cs = 0x000000000000002b
        fs = 0x0000000000000000
        gs = 0x0000000000000000

(lldb) po 0x00007fcaf650bd70
<RegisterWithMoreSixParametersViewController: 0x7fcaf650bd70>
 */
#if DEBUG
    NSLog(@"%@:%@ (breakpoint): %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], @(__LINE__), @"expect never hit this line. Please check your parameters and type `continue` to resume. And this information only for Debug, never show on Release");
    raise(SIGTRAP); // __builtin_trap();
#endif
    NSLog(@"do something");
    return @"9";
}

@end
