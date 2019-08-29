//
//  DyldRegisterFuncForAddImageViewController.m
//  HelloDyldFunctions
//
//  Created by wesley_chen on 2018/8/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DyldRegisterFuncForAddImageViewController.h"
#import "WCThreadSafeMutableArray.h"
#import <mach-o/dyld.h>
#import "WCDyldTool.h"

static BOOL sRegistered = NO;
// TODO: use more thread safe array
static WCThreadSafeMutableArray *sArray;

static void _onBinaryImageLoadedForOriginal(const struct mach_header* mh, intptr_t vmaddr_slide)
{
    NSLog(@"main thread: %@", [NSThread isMainThread] ? @"YES" : @"NO");
    NSLog(@"%p", mh);
    [sArray addObject:(__bridge id)(mh)];
    if ([NSThread isMainThread]) {
        
    }
    else {
        NSLog(@"break here");
    }
//    do {
//        if (mh == NULL) { break; }
//        if (_safeContainsMachHeader(mh)) { break; } /// already contains
//
//        /// add to array
//        _safeAddMachHeader(mh);
//
//        /// is register, just skip. No need to post notification
//        if (sIsRegister) { break; }
//
//        /// post notification
//        NSDictionary *userInfo = @{
//                                   sNoteOnImageLoadedKeyMHP:[NSNumber numberWithUnsignedLongLong:(unsigned long long)mh]
//                                   };
//        [[NSNotificationCenter defaultCenter] postNotificationName:sNoteOnImageLoaded object:nil userInfo:userInfo];
//    } while (NO);
}



__attribute__((constructor))
static void register_observe_binary_image_loaded(void)
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dyld_register_func_for_add_image(&_onBinaryImageLoadedForOriginal);
        sRegistered = YES;
        sArray = [[WCThreadSafeMutableArray alloc] init];
    });
}

@interface DyldRegisterFuncForAddImageViewController ()

@end

@implementation DyldRegisterFuncForAddImageViewController

+ (void)load {
    [WCDyldTool registerDynamicLibraresDidLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
