//
//  GetSymbolicCallStackViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2020/5/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetSymbolicCallStackViewController.h"
#import <mach-o/dyld.h>

@interface GetSymbolicCallStackViewController ()
- (void)methodNotExists;
@end

@implementation GetSymbolicCallStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeACrash];
}

- (void)makeACrash {
//    @try {
        [self methodNotExists];
//    } @catch (NSException *exception) {
//        NSArray<NSString *> *callStackSymbols = [exception callStackSymbols];
//
//        NSString *loadImageAddress = [self getPrismImageLoadAddress];
//        NSString *backtrace = [callStackSymbols componentsJoinedByString:@"\n"];
//        NSString *log = [[NSString alloc] initWithFormat:@"\nprism Load image address:%@\ncall backtrace:\n%@", loadImageAddress, backtrace];
//        
//        NSLog(@"%@", log);
//    } @finally {
//
//    }
}

- (NSString *)getPrismImageLoadAddress {
    const struct mach_header *executableHeader = NULL;
    //遍历所有绑定运行的image
    for (uint32_t i = 0; i < _dyld_image_count(); i++){
        const struct mach_header *header = _dyld_get_image_header(i);
       //找到可执行文件类型的image
        if (header->filetype == MH_EXECUTE) {
            executableHeader = header;
            break;
        }
    }
    //将指针地址转换成string类型
    NSString *address = [NSString stringWithFormat:@"0x%lx", (NSInteger)executableHeader];
    return address;
}

@end
