//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

// @see https://stackoverflow.com/a/34065545
@interface ScanQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) BOOL firstDetected;
@property (nonatomic, assign) BOOL animating;

@property (nonatomic, assign) BOOL allowJumpToNextSceneWhenDetected;
@property (nonatomic, assign) BOOL jumpingToNextScene;
@end

@implementation ScanQRCodeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSError *error;
        
        _session = [AVCaptureSession new];
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
        if (_input) {
            // Note: add NSCameraUsageDescription to Info.plist
            [_session addInput:_input];
        }
        else {
            NSLog(@"Error: %@", error);
        }
        
        _output = [AVCaptureMetadataOutput new];
        [_session addOutput:_output];
        
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        // Note: 这里有个坑，设置metadataObjectTypes不能在addOutput:方法之前，否则captureOutput:didOutputMetadataObjects:fromConnection:方法不会回调
        _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwitch *switcher = [UISwitch new];
    switcher.on = self.allowJumpToNextSceneWhenDetected;
    [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
    [switcher sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switcher];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.previewView];
    [self.view addSubview:self.textView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.jumpingToNextScene = NO;
    self.firstDetected = YES;
    
    // Note: 约束在viewDidAppear中开始检测QRCode，因此back swipe手势，会触发viewWillAppear
    // start the flow of data from the inputs to the outputs
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.firstDetected = NO;
    
    [self.session stopRunning];
}

#pragma mark - Actions

- (void)switcherToggled:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    switcher.on = !switcher.on;
    self.allowJumpToNextSceneWhenDetected = switcher.on;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    CGRect highlightViewRect = CGRectZero;
    
    AVMetadataMachineReadableCodeObject *codeObject;
    NSString *detectedString = nil;
    NSArray *codeTypes = @[AVMetadataObjectTypeUPCECode,
                           AVMetadataObjectTypeCode39Code,
                           AVMetadataObjectTypeCode39Mod43Code,
                           AVMetadataObjectTypeEAN13Code,
                           AVMetadataObjectTypeEAN8Code,
                           AVMetadataObjectTypeCode93Code,
                           AVMetadataObjectTypeCode128Code,
                           AVMetadataObjectTypePDF417Code,
                           AVMetadataObjectTypeQRCode,
                           AVMetadataObjectTypeAztecCode
                           ];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([codeTypes containsObject:metadata.type]) {
            codeObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
            highlightViewRect = codeObject.bounds;
            detectedString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }
    
    if (detectedString) {
        NSLog(@"%@", detectedString);
        self.textView.text = detectedString;
    }
    else {
        NSLog(@"%@", @"not detected");
        self.textView.text = @"(not detected)";
    }
    
    if (detectedString && !CGRectEqualToRect(highlightViewRect, CGRectZero)) {
        // Note: 正在执行动画，则不要重新显示highlightView
        if (!self.animating && !self.jumpingToNextScene) {
            [self showHighlightViewWithDetectedString:detectedString atRect:highlightViewRect animated:self.firstDetected ? YES : NO];
        }
    }
    else {
        [self hideHighlightView];
    }
    
    NSLog(@"rect: %@", NSStringFromCGRect(highlightViewRect));
}

- (void)showHighlightViewWithDetectedString:(NSString *)detectedString atRect:(CGRect)rect animated:(BOOL)animated {
    self.firstDetected = NO;
    self.highlightView.hidden = NO;
    
    if (animated) {
        CGSize presetSize = CGSizeMake(200, 200);
        self.highlightView.frame = CGRectMake((CGRectGetWidth(self.previewView.bounds) - presetSize.width) / 2.0, (CGRectGetHeight(self.previewView.bounds) - presetSize.height) / 2.0, presetSize.width, presetSize.height);
        self.animating = YES;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.highlightView.frame = rect;
        } completion:^(BOOL finished) {
            self.animating = NO;
            if (self.allowJumpToNextSceneWhenDetected) {
                NSLog(@"jump with detected rect: %@", NSStringFromCGRect(rect));
                [self jumpToNextSceneWithDetectedString:detectedString];
            }
        }];
    }
    else {
        self.highlightView.frame = rect;
        if (self.allowJumpToNextSceneWhenDetected) {
            NSLog(@"jump with detected rect: %@", NSStringFromCGRect(rect));
            [self jumpToNextSceneWithDetectedString:detectedString];
        }
    }
}

- (void)jumpToNextSceneWithDetectedString:(NSString *)detectedString {
    NSLog(@"jump with detected string: %@", detectedString);
    self.jumpingToNextScene = YES;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat padding = 10;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, padding + 64, screenSize.width - 2 * padding, 200)];
    textView.keyboardType = UIKeyboardTypeASCIICapable;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 1;
    textView.text = [detectedString copy];
    
    UIViewController *vc = [UIViewController new];
    vc.title = @"Copyied in pasteboard!";
    vc.automaticallyAdjustsScrollViewInsets = NO;
    vc.view.backgroundColor = [UIColor whiteColor];
    [vc.view addSubview:textView];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [UIPasteboard generalPasteboard].string = [detectedString copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.highlightView.hidden = YES;
    });
}

- (void)hideHighlightView {
    self.firstDetected = YES;
    self.highlightView.hidden = YES;
}

#pragma mark - Getters

#define LabelHeight 100

- (UIView *)highlightView {
    if (!_highlightView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        view.layer.borderColor = [UIColor yellowColor].CGColor;
        view.layer.borderWidth = 1.5;
        
        _highlightView = view;
    }
    
    return _highlightView;
}

- (UIView *)previewView {
    if (!_previewView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - LabelHeight - 64)];
        view.backgroundColor = [UIColor blackColor];
        
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        previewLayer.frame = view.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [view.layer addSublayer:previewLayer];
        [view addSubview:self.highlightView];
        
        _previewLayer = previewLayer;
        _previewView = view;
    }
    
    return _previewView;
}

- (UITextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.previewView.frame), screenSize.width, LabelHeight)];
        textView.editable = NO;
        textView.selectable = YES;
        textView.textColor = [UIColor blackColor];
        
        _textView = textView;
    }
    
    return _textView;
}

@end
