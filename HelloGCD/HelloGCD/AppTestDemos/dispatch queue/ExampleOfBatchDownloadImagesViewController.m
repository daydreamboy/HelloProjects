//
//  ExampleOfBatchDownloadImagesViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/12/20.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "ExampleOfBatchDownloadImagesViewController.h"



@interface ExampleOfBatchDownloadImagesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *urls;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation ExampleOfBatchDownloadImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setup];
}

- (void)setup {
//    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    if ([_tableView respondsToSelector:@selector(layoutMargins)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:_tableView];
    [self.view sendSubviewToBack:_tableView];
    
    _urls = @[
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_china@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_usa@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_hongkong@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_taiwan@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_canada@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_UK@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_france@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_japan@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_korea@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_thailand@3x.png",
              @"http://passport.qatest.didichuxing.com/static/flags/icon_pacific_australia@3x.png",
              ];
    _images = [NSMutableArray array];
    for (NSUInteger i = 0; i < _urls.count; i++) {
        [_images addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // http://stackoverflow.com/questions/13996621/downloading-multiple-files-in-batches-in-ios
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 5;
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self methodToCallOnCompletion];
        }];
    }];
    
    for (NSInteger i = 0; i < _urls.count; i++) {
        NSURL *URL = [NSURL URLWithString:_urls[i]];
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSData *data = [NSData dataWithContentsOfURL:URL];
            UIImage *image = [UIImage imageWithData:data];
            @synchronized (_images) {
                _images[i] = image;
            }
            NSString *fileName = [_urls[i] lastPathComponent];
            NSLog(@"%ld image downloaded", i);
//            NSString *filePath = [documentsPath stringByAppendingString:[url lastPathComponent]];
//            [data writeToFile:filename atomically:YES];
        }];
        [completionOperation addDependency:operation];        
    }

    [queue addOperations:completionOperation.dependencies waitUntilFinished:NO];
    [queue addOperation:completionOperation];
}

- (void)methodToCallOnCompletion {
    NSLog(@"all are downloaded");
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_images count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"ExampleOfBatchDownloadImagesViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    
    UIImage *image = _images[indexPath.row];
    if ([image isKindOfClass:[UIImage class]]) {
        cell.imageView.image = image;
    }
    
    return cell;
}

@end
