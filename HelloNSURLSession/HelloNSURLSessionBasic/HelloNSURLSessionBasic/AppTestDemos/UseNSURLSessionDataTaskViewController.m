//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseNSURLSessionDataTaskViewController.h"
#import "WCMacroTool.h"
#import "WCOrderedDictionary.h"

#define TableViewHeight 400
#define SpaceV 10

// NSURLSessionDataTask vs NSURLSessionDownloadTask
// Note: https://stackoverflow.com/a/20605116
@interface UseNSURLSessionDataTaskViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WCOrderedDictionary *listData;
@end

@implementation UseNSURLSessionDataTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textView];
    
    UIBarButtonItem *loadItem = [[UIBarButtonItem alloc] initWithTitle:@"Load" style:UIBarButtonItemStylePlain target:self action:@selector(loadItemClicked:)];
    self.navigationItem.rightBarButtonItem = loadItem;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat startY = CGRectGetMaxY(self.tableView.frame);
    self.textView.frame = FrameSetSize(self.textView.frame, NAN, height - startY - SpaceV);
}

#pragma mark - Getter

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 5;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(paddingH, paddingH, screenSize.width - 2 * paddingH, 30)];
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 5;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        NSString *url = @"http://card-data.oss-cn-hangzhou.aliyuncs.com/temp_2018-06-08T09%3A30%3A51.477Z.json";
        //url = @"https://c.tb.cn/I3.bbz8u";
        
        textField.placeholder = url;
        
        _textField = textField;
    }
    
    return _textField;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textField.frame) + SpaceV, screenSize.width, 200)];
        tableView.layer.borderColor = [UIColor blueColor].CGColor;
        tableView.layer.borderWidth = 1;
        tableView.dataSource = self;
        tableView.delegate = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (UITextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame) + SpaceV, screenSize.width, 300)];
        textView.layer.borderColor = [UIColor orangeColor].CGColor;
        textView.layer.borderWidth = 1;
        
        _textView = textView;
    }
    
    return _textView;
}

#pragma mark - Action

- (void)loadItemClicked:(id)sender {
    NSString *url;
    
    if (self.textField.text.length) {
        url = self.textField.text;
    }
    else {
        url = self.textField.placeholder;
    }
    
    if (url.length) {
        [self downloadDataWithUrl:url completion:^(NSData *data, NSError *error, NSURLResponse *response) {
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.textView.text = string;
            self.listData = [self dictionaryFromURLResponse:response data:data];
            [self.tableView reloadData];
        }];
    }
    else {
        SHOW_ALERT(@"Error", @"url is empty", @"Ok", nil);
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"UseNSURLSessionDataTaskViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:sCellIdentifier];
    }
    
    WCOrderedDictionaryPair pair = self.listData[indexPath.row];
    cell.textLabel.text = [pair firstObject];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.text = [pair lastObject];
    
    return cell;
}

#pragma mark -

- (void)downloadDataWithUrl:(NSString *)url completion:(void (^)(NSData *data, NSError *error, NSURLResponse *response))completion {
    NSString *dataUrl = url;
    NSURL *URL = [NSURL URLWithString:dataUrl];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // about NSURLResponse
        NSLog(@"mimeType: %@", response.MIMEType);
        NSLog(@"suggestedFilename: %@", response.suggestedFilename);
        NSLog(@"textEncodingName: %@", response.textEncodingName);
        NSLog(@"expectedContentLength: %lld", response.expectedContentLength);
        NSLog(@"URL: %@", response.URL);
        NSLog(@"data size: %lld", (long long)data.length);

        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(data, error, response);
        });
    }];
    
    [downloadTask resume];
}

#pragma mark -

- (WCOrderedDictionary *)dictionaryFromURLResponse:(NSURLResponse *)response data:(NSData *)data {
    WCOrderedDictionary *dictM = [WCOrderedDictionary dictionary];
    
    dictM[@"data size"] = [NSString stringWithFormat:@"%lld", (long long)data.length];
    dictM[@"mimeType"] = response.MIMEType;
    dictM[@"suggestedFilename"] = response.suggestedFilename;
    dictM[@"textEncodingName"] = response.textEncodingName;
    dictM[@"expectedContentLength"] = [NSString stringWithFormat:@"%lld", (long long)response.expectedContentLength];
    dictM[@"URL"] = [NSString stringWithFormat:@"%@", response.URL];
    
    return dictM;
}

@end
