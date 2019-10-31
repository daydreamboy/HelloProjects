//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseNSURLSessionDataTaskViewController.h"

// NSURLSessionDataTask vs NSURLSessionDownloadTask
// Note: https://stackoverflow.com/a/20605116
@interface UseNSURLSessionDataTaskViewController ()
@end

@implementation UseNSURLSessionDataTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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

#pragma mark -

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
            id jsonObject;
            @try {
                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            }
            @catch (NSException *e) {
                jsonError = [NSError errorWithDomain:e.name code:-1 userInfo:@{ NSLocalizedDescriptionKey: e.reason }];
            }
            
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
