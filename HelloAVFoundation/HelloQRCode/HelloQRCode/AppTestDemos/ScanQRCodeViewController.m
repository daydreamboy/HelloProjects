//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define HighLightViewPresetSize     (CGSizeMake(200, 200))
#define HighLightViewBorderWidth    1.5
#define HighLightViewBorderColor    [UIColor yellowColor]

#define switcherAllowJumpStatus     NO

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
@property (nonatomic, strong) UISwitch *switcherAllowJump; ///< 是否允许跳转到result界面

@property (nonatomic, assign) BOOL firstDetected; ///< 是否首次识别
@property (nonatomic, assign) BOOL ignoreScanCallback; ///< 是否忽略scan回调
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
        
        _firstDetected = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.switcherAllowJump];
    
    [self.view addSubview:self.previewView];
    [self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    if ([self appearingDueToPushed]) {
        // start the flow of data from the inputs to the outputs
        [self.session startRunning];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self appearingDueToPushed]) {
        [self.session startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"viewWillDisappear");
    self.ignoreScanCallback = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    
    [self hideHighlightView];
    
    self.ignoreScanCallback = NO;
    [self.session stopRunning];
}

#pragma mark - Actions

- (void)switcherAllowJumpToggled:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    switcher.on = !switcher.on;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"captureOutput");
    
    if (self.ignoreScanCallback) {
        return;
    }
    
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
        [self showHighlightViewWithDetectedString:detectedString atRect:highlightViewRect animated:self.firstDetected ? YES : NO];
    }
    else {
        [self hideHighlightView];
    }
    
    NSLog(@"rect: %@", NSStringFromCGRect(highlightViewRect));
}

#pragma mark -

- (BOOL)appearingDueToPushed {
    if (self.navigationController) {
        return self.isMovingToParentViewController;
    }
    else {
        return NO;
    }
}

- (void)showHighlightViewWithDetectedString:(NSString *)detectedString atRect:(CGRect)rect animated:(BOOL)animated {
    
    self.firstDetected = NO;
    self.highlightView.hidden = NO;
    
    if (animated) {
        self.ignoreScanCallback = YES;
        self.highlightView.frame = CGRectMake((CGRectGetWidth(self.previewView.bounds) - HighLightViewPresetSize.width) / 2.0, (CGRectGetHeight(self.previewView.bounds) - HighLightViewPresetSize.height) / 2.0, HighLightViewPresetSize.width, HighLightViewPresetSize.height);
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.highlightView.frame = rect;
        } completion:^(BOOL finished) {
            if (self.switcherAllowJump.on) {
                NSLog(@"jump with detected rect: %@", NSStringFromCGRect(rect));
                [self jumpToNextSceneWithDetectedString:detectedString];
            }
            else {
                NSLog(@"ignoreScanCallback");
                self.ignoreScanCallback = NO;
            }
        }];
    }
    else {
        self.highlightView.frame = rect;
        if (self.switcherAllowJump.on) {
            NSLog(@"jump with detected rect: %@", NSStringFromCGRect(rect));
            
            self.ignoreScanCallback = YES;
            [self jumpToNextSceneWithDetectedString:detectedString];
        }
    }
}

- (void)jumpToNextSceneWithDetectedString:(NSString *)detectedString {
    NSLog(@"jump with detected string: %@", detectedString);
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
    
    [UIPasteboard generalPasteboard].string = [detectedString copy];
    
    [self.navigationController pushViewController:vc animated:YES];
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
        view.layer.borderColor = HighLightViewBorderColor.CGColor;
        view.layer.borderWidth = HighLightViewBorderWidth;
        
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

- (UISwitch *)switcherAllowJump {
    if (!_switcherAllowJump) {
        
        UISwitch *switcher = [UISwitch new];
        switcher.on = switcherAllowJumpStatus;
        [switcher addTarget:self action:@selector(switcherAllowJumpToggled:) forControlEvents:UIControlEventValueChanged];
        [switcher sizeToFit];
        
        _switcherAllowJump = switcher;
    }
    
    return _switcherAllowJump;
}

@end
