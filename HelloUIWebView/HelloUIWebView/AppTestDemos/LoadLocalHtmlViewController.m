//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "LoadLocalHtmlViewController.h"
#import "WCScreenshotHelper.h"

@interface LoadLocalHtmlViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation LoadLocalHtmlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *captureItem = [[UIBarButtonItem alloc] initWithTitle:@"Capture" style:UIBarButtonItemStyleDone target:self action:@selector(captureItemClicked:)];
    self.navigationItem.rightBarButtonItem = captureItem;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"qixi" withExtension:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
    
    self.webView = webView;
}

#pragma mark - Actions

- (void)captureItemClicked:(id)sender {
    [WCScreenshotHelper snapshotScrollView:self.webView.scrollView withFullContent:YES savedToPhotosAlbum:YES];
}

@end
