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

- (void)downloadDataWithUrl:(NSString *)url completion:(void (^)(id jsonObject, NSError *error))completion {
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
            
            // Note: completionHandler is called on main thread, so call completion on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion(jsonObject, jsonError);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                !completion ?: completion(data, error);
            });
        }
    }];
    
    [downloadTask resume];
}

@end
