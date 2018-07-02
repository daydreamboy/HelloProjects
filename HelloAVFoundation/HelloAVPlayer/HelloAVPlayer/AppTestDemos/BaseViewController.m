//
//  BaseViewController.m
//  HelloAVPlayer
//
//  Created by wesley_chen on 2018/7/2.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    _URLDemo1 = [NSURL fileURLWithPath:filePath];
    
    // @see http://demo.theoplayer.com/test-your-stream-with-statistics
    _URLRemoteDemo1 = [NSURL URLWithString:@"http://cdn.theoplayer.com/video/elephants-dream/448/chunklist_w370587926_b688000_vo_slen_t64TWFpbg==.m3u8"];
}

@end
