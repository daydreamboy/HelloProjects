//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "DownloadDataViewController.h"

@interface DownloadDataViewController ()

@end

@implementation DownloadDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url = @"http://card-data.oss-cn-hangzhou.aliyuncs.com/temp_2018-06-08T09%3A30%3A51.477Z.json";
    [self downloadDataWithUrl:url];
}

- (void)downloadDataWithUrl:(NSString *)url {
    NSString *dataUrl = url;
    NSURL *URL = [NSURL URLWithString:dataUrl];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"data: %@", data);
        // about NSURLResponse
        NSLog(@"mimeType: %@", response.MIMEType);
        NSLog(@"suggestedFilename: %@", response.suggestedFilename);
        NSLog(@"textEncodingName: %@", response.textEncodingName);
        NSLog(@"expectedContentLength: %lld", response.expectedContentLength);
        NSLog(@"URL: %@", response.URL);
        
        if (data && !error) {
            NSLog(@"data size: %lld", (long long)data.length);
            NSError *jsonError;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if ([jsonObject isKindOfClass:[NSDictionary class]] && !jsonError) {
                NSLog(@"%@", jsonObject);
            }
            else {
                NSLog(@"expect NSDictionary, but it's %@", jsonObject);
            }
        }
    }];
    
    [downloadTask resume];
}

@end
