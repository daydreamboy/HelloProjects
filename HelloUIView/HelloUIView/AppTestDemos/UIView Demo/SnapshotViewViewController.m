//
//  SnapshotViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2020/5/22.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "SnapshotViewViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WCMacroTool.h"
#import "WCViewTool.h"

@interface WCScreenshotHelper : NSObject

+ (UIImage *)snapshotView:(UIView *)capturedView savedToPhotosAlbum:(BOOL)savedToPhotosAlbum;
+ (UIImage *)snapshotWindow:(UIWindow *)capturedWindow savedToPhotosAlbum:(BOOL)savedToPhotosAlbum;
+ (UIImage *)snapshotScrollView:(UIScrollView *)capturedScrollView withFullContent:(BOOL)withFullContent savedToPhotosAlbum:(BOOL)savedToPhotosAlbum;

+ (UIImage *)snapshotScreenSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum;
+ (UIImage *)snapshotScreenAfterAlertShownSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum;
+ (UIImage *)snapshotScreenAfterActionSheetShownSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum;

@end


@implementation WCScreenshotHelper

#pragma mark - Public Methods

+ (UIImage *)snapshotView:(UIView *)capturedView savedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    // If capturedView is invalid, return nil
    if (capturedView == nil || capturedView.bounds.size.height == 0 || capturedView.bounds.size.width == 0) {
        return nil;
    }

    UIImage *image = nil;
    if ([capturedView isKindOfClass:[UIWindow class]]) {
        image = [WCViewTool snapshotWithWindow:(UIWindow *)capturedView includeStatusBar:NO];
    }
    else if ([capturedView isKindOfClass:[UIScrollView class]]) {
        image = [self snapshotScrollView:(UIScrollView *)capturedView withFullContent:NO savedToPhotosAlbum:savedToPhotosAlbum];
    }
    else {
        image = [WCViewTool snapshotWithView:capturedView];
    }
    
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    return image;
}

// Snapshot for window
+ (UIImage *)snapshotWindow:(UIWindow *)capturedWindow savedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [WCViewTool snapshotWithWindow:capturedWindow includeStatusBar:NO];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

// Snapshot full screen
+ (UIImage *)snapshotScreenSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [WCViewTool snapshotScreenIncludeStatusBar:YES];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

// Snapshot scroll view with full content or with visible content
+ (UIImage *)snapshotScrollView:(UIScrollView *)capturedScrollView withFullContent:(BOOL)withFullContent savedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [WCViewTool snapshotWithScrollView:capturedScrollView shouldConsiderContent:withFullContent];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

// Snapshot full screen with alert view
+ (UIImage *)snapshotScreenAfterAlertShownSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [WCViewTool snapshotScreenAfterOtherWindowsHasShownIncludeStatusBar:NO];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

// Snapshot full screen with action sheet
+ (UIImage *)snapshotScreenAfterActionSheetShownSavedToPhotosAlbum:(BOOL)savedToPhotosAlbum {
    UIImage *image = [WCViewTool snapshotScreenAfterOtherWindowsHasShownIncludeStatusBar:NO];
    if (savedToPhotosAlbum && image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    return image;
}

@end

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ButtonTagShowAlert,
    ButtonTagShowActionSheet,
};

@interface SnapshotViewViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl1;
@property (nonatomic, strong) UISegmentedControl *segmentedControl2;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *plainView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, strong) UISegmentedControl *currentSegmentedControl;

@end

@implementation SnapshotViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.title = @"WCScreenshotHelper";
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSLog(@"window: %@", window);
    }
    
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *homeDirectory = NSHomeDirectory();
    NSString *libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *tmpDirectory = NSTemporaryDirectory();

    NSLog(@"homeDirectory: %@\n\n", homeDirectory);
    NSLog(@"libraryDirectory: %@\n\n", libraryDirectory);
    NSLog(@"documentDirectory: %@\n\n", documentDirectory);
    NSLog(@"cachesDirectory: %@\n\n", cachesDirectory);
    NSLog(@"tmpDirectory: %@\n\n", tmpDirectory);
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat heightForNavBar = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat heightForStatusBar = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat spacing = 10.0f;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Capture" style:UIBarButtonItemStylePlain target:self action:@selector(captureView:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesgureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:tapGesgureRecognizer];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"UIView", @"UIWindow", @"Screen"]];
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;
    _currentSegmentedControl = segmentedControl;
    segmentedControl.frame = CGRectMake(0, SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? heightForStatusBar + heightForNavBar + spacing : spacing, screenSize.width, 30);
    [segmentedControl addTarget:self action:@selector(indexDidChange:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl1 = segmentedControl;
    [self.view addSubview:segmentedControl];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentedControl.frame) + spacing, screenSize.width, 20)];
    label.text = @"Snapshot UIScrollView with:";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    UISegmentedControl *segmentedControl2 = [[UISegmentedControl alloc] initWithItems:@[@"full content", @"visible content"]];
    segmentedControl2.backgroundColor = [UIColor whiteColor];
    segmentedControl2.frame = CGRectMake(0, CGRectGetMaxY(label.frame), screenSize.width, 30);
    [segmentedControl2 addTarget:self action:@selector(indexDidChange:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl2 = segmentedControl2;
    [self.view addSubview:segmentedControl2];
    
    UIButton *buttonForAlert = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonForAlert.frame = CGRectMake(spacing, CGRectGetMaxY(segmentedControl2.frame) + spacing, screenSize.width - 2 * spacing, 20);
    buttonForAlert.tag = ButtonTagShowAlert;
    [buttonForAlert setTitle:@"show alert" forState:UIControlStateNormal];
    [buttonForAlert addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonForAlert];
    
    UIButton *buttonForActionSheet = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonForActionSheet.frame = CGRectMake(spacing, CGRectGetMaxY(buttonForAlert.frame) + spacing, screenSize.width - 2 * spacing, 20);
    buttonForActionSheet.tag = ButtonTagShowActionSheet;
    [buttonForActionSheet setTitle:@"show action sheet" forState:UIControlStateNormal];
    [buttonForActionSheet addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonForActionSheet];
    
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width - 100 / 2.0, (screenSize.height - 100) / 2.0, 100, 100)];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    _plainView = view;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
    scrollView.backgroundColor = [UIColor orangeColor];
    scrollView.contentSize = CGSizeMake(120, screenSize.height + 300);
    NSLog(@"contentSize: %@", NSStringFromCGSize(scrollView.contentSize));
    [self.view addSubview:scrollView];
    
    UILabel *labelInScrollView = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
    labelInScrollView.text = @"Hello, world";
    labelInScrollView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:labelInScrollView];
    _scrollView = scrollView;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Capture UIAlertView now?" message:@"You will capture screen including this alert view" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    _alert = alert;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Capture UIActionSheet now?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
    _actionSheet = actionSheet;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 350, 200, 30)];
    textField.placeholder = @"Type here...";
    textField.keyboardType = UIKeyboardTypeDefault;
    [textField becomeFirstResponder];
    [self.view addSubview:textField];
    _textField = textField;
    

}

#pragma mark - Actions

- (void)captureView:(UIBarButtonItem *)barButtonItem {
    
    NSString *title = [_currentSegmentedControl titleForSegmentAtIndex:_currentSegmentedControl.selectedSegmentIndex];
    
    if ([title isEqualToString:@"UIView"]) {
        [WCScreenshotHelper snapshotView:_plainView savedToPhotosAlbum:YES];
    }
    else if ([title isEqualToString:@"UIWindow"]) {
        [WCScreenshotHelper snapshotWindow:[UIApplication sharedApplication].keyWindow savedToPhotosAlbum:YES];
    }
    else if ([title isEqualToString:@"Screen"]) {
        [WCScreenshotHelper snapshotScreenSavedToPhotosAlbum:YES];
    }
    else if ([title isEqualToString:@"full content"]) {
        [WCScreenshotHelper snapshotScrollView:_scrollView withFullContent:YES savedToPhotosAlbum:YES];
    }
    else if ([title isEqualToString:@"visible content"]) {
        [WCScreenshotHelper snapshotScrollView:_scrollView withFullContent:NO savedToPhotosAlbum:YES];
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)recognizer {
    [_textField resignFirstResponder];
}

- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case ButtonTagShowAlert:
            [_alert show];
            break;
        case ButtonTagShowActionSheet:
            [_actionSheet showInView:self.view];
            break;
        default:
            break;
    }
}

- (void)indexDidChange:(UISegmentedControl *)segmentedControl {
    
    if (segmentedControl == _segmentedControl1) {
        _segmentedControl2.selectedSegmentIndex = -1;
        _currentSegmentedControl = _segmentedControl1;
    }
    else if (segmentedControl == _segmentedControl2) {
        _segmentedControl1.selectedSegmentIndex = -1;
        _currentSegmentedControl = _segmentedControl2;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    }
    else if (buttonIndex == 1) {
        [WCScreenshotHelper snapshotScreenAfterAlertShownSavedToPhotosAlbum:YES];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [WCScreenshotHelper snapshotScreenAfterActionSheetShownSavedToPhotosAlbum:YES];
    }
    else if (buttonIndex == 1) {
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"error: %@", [error description]);
        
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status != ALAuthorizationStatusAuthorized) {
            //show alert for asking the user to give permission
            
        }
        return;
    }
    //
}

-(void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}


@end
