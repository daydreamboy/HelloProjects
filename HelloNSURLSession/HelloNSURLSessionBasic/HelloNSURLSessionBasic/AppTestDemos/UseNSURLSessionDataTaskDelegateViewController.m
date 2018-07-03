//
//  UseNSURLSessionDataTaskDelegateViewController.m
//  HelloNSURLSessionBasic
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseNSURLSessionDataTaskDelegateViewController.h"

// Note: NSURLSessionDataDelegate < NSURLSessionTaskDelegate < NSURLSessionDelegate
@interface UseNSURLSessionDataTaskDelegateViewController () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableData *dataToDownload;
@property (nonatomic, assign) long long downloadSize;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *labelProgress;
@end

@implementation UseNSURLSessionDataTaskDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelProgress];
    [self.view addSubview:self.progressView];
    
    NSString *url = @"http://card-data.oss-cn-hangzhou.aliyuncs.com/temp_2018-06-08T09%3A30%3A51.477Z.json";
    [self downloadDataWithUrl:url completion:^(id jsonObject, NSError *error) {
        if ([jsonObject isKindOfClass:[NSDictionary class]] && !error) {
            NSLog(@"%@", jsonObject);
        }
        else {
            NSLog(@"error: %@", error);
            NSLog(@"expect NSDictionary, but it's %@", jsonObject);
        }
    }];
}

#pragma mark - Getters

- (UILabel *)labelProgress {
    if (!_labelProgress) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 + 10, screenSize.width - 2 * paddingH, 20)];
        label.text = @"0 %";
        _labelProgress = label;
    }
    
    return _labelProgress;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        
        UIProgressView *view = [[UIProgressView alloc] initWithFrame:CGRectMake(paddingH, 64 + 50, screenSize.width - 2 * paddingH, 20)];
        
        _progressView = view;
    }
    
    return _progressView;
}

#pragma mark -

- (void)downloadDataWithUrl:(NSString *)url completion:(void (^)(id jsonObject, NSError *error))completion {
    NSString *dataUrl = url;
    NSURL *URL = [NSURL URLWithString:dataUrl];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // WARNING: Don't use dataTaskWithURL:completionHandler:, this won't trigger delegate methods in NSURLSessionDataDelegate
    NSURLSessionDataTask *downloadTask = [defaultSession dataTaskWithURL:URL];
    
    [downloadTask resume];
}

#pragma mark - NSURLSessionDataDelegate < NSURLSessionTaskDelegate < NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    
    self.downloadSize = [response expectedContentLength];
    self.progressView.progress = 0.0;
    self.dataToDownload = [NSMutableData data];
    
    self.labelProgress.text = [NSString stringWithFormat:@"%.2f %%", self.progressView.progress * 100.0];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    [self.dataToDownload appendData:data];
    self.progressView.progress = [self.dataToDownload length] / (double)self.downloadSize;
    
    self.labelProgress.text = [NSString stringWithFormat:@"%.2f %%", self.progressView.progress * 100.0];
}

@end
