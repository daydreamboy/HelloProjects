//
//  UsePasteboardViewController.m
//  HelloUIPasteboard
//
//  Created by wesley_chen on 2020/7/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UsePasteboardViewController.h"
#import "WCMacroTool.h"
#import "WCControlTool.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define SpaceV 10

@interface UsePasteboardViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *demoView1;
@property (nonatomic, strong) UIView *demoView2;
@property (nonatomic, strong) UIView *demoView3;
@end

@implementation UsePasteboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.demoView1];
    [self.scrollView addSubview:self.demoView2];
    [self.scrollView addSubview:self.demoView3];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(screenSize.width, CGRectGetMaxY(_demoView3.frame));
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

#pragma mark - Demo Views

- (UIView *)demoView1 {
    if (!_demoView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat paddingH = 10;
        CGFloat paddingV = 10;
        
        CGFloat textFieldWidth = (screenSize.width - 3 * paddingH) / 2.0;
        CGFloat textFieldHeight = 30;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, paddingH, screenSize.width, UNSPECIFIED)];
        _demoView1 = view;
        
        UITextField *textFieldLeft = [[UITextField alloc] initWithFrame:CGRectMake(paddingH, 0, textFieldWidth, textFieldHeight)];
        textFieldLeft.borderStyle = UITextBorderStyleRoundedRect;
        [_demoView1 addSubview:textFieldLeft];
        
        UITextField *textFieldRight = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textFieldLeft.frame) + paddingH, 0, textFieldWidth, textFieldHeight)];
        textFieldRight.borderStyle = UITextBorderStyleRoundedRect;
        [_demoView1 addSubview:textFieldRight];
        
        UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonLeft setTitle:@"Copy String" forState:UIControlStateNormal];
        [buttonLeft sizeToFit];
        buttonLeft.center = CGPointMake(CGRectGetMidX(textFieldLeft.frame), CGRectGetMaxY(textFieldLeft.frame) + CGRectGetHeight(buttonLeft.frame) / 2.0 + paddingV);
        
        weakify(textFieldLeft);
        [WCControlTool addBlockForControl:buttonLeft events:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            strongifyWithReturn(textFieldLeft, return;);
            
            [UIPasteboard generalPasteboard].string = textFieldLeft.text;
        }];
        
        [_demoView1 addSubview:buttonLeft];
        
        UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonRight setTitle:@"Paste String" forState:UIControlStateNormal];
        [buttonRight sizeToFit];
        buttonRight.center = CGPointMake(CGRectGetMidX(textFieldRight.frame), CGRectGetMaxY(textFieldRight.frame) + CGRectGetHeight(buttonRight.frame) / 2.0 + paddingV);
        
        weakify(textFieldRight);
        [WCControlTool addBlockForControl:buttonRight events:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            strongifyWithReturn(textFieldRight, return;);
            
            textFieldRight.text = STR_CATENATE(textFieldRight.text, [UIPasteboard generalPasteboard].string);
        }];
        
        [_demoView1 addSubview:buttonRight];
        
        _demoView1.frame = FrameSetSize(_demoView1.frame, NAN, CGRectGetMaxY(buttonRight.frame));
    }
    
    return _demoView1;
}

- (UIView *)demoView2 {
    if (!_demoView2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat paddingH = 10;
        CGFloat paddingV = 10;
        
        CGFloat labelWidth = (screenSize.width - 3 * paddingH) / 2.0;
        CGFloat labelHeight = 50;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_demoView1.frame) + paddingH + SpaceV, screenSize.width, UNSPECIFIED)];
        _demoView2 = view;
        
        UILabel *labelLeft = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, 0, labelWidth, labelHeight)];
        labelLeft.numberOfLines = 0;
        labelLeft.textAlignment = NSTextAlignmentCenter;
        labelLeft.text = @"https://www.baidu.com/";
        [_demoView2 addSubview:labelLeft];
        
        UILabel *labelRight = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelLeft.frame) + paddingH, 0, labelWidth, labelHeight)];
        labelRight.numberOfLines = 0;
        labelRight.textAlignment = NSTextAlignmentCenter;
        [_demoView2 addSubview:labelRight];
        
        UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonLeft setTitle:@"Copy Url" forState:UIControlStateNormal];
        [buttonLeft sizeToFit];
        buttonLeft.center = CGPointMake(CGRectGetMidX(labelLeft.frame), CGRectGetMaxY(labelLeft.frame) + CGRectGetHeight(buttonLeft.frame) / 2.0 + paddingV);
        
        weakify(labelLeft);
        [WCControlTool addBlockForControl:buttonLeft events:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            strongifyWithReturn(labelLeft, return;);
            
            NSDate *futureDate = [[NSDate date] dateByAddingTimeInterval:10];
            
            UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"sample_pasteboard" create:YES];
            [pasteboard setItems:@[] options:@{
                UIPasteboardOptionLocalOnly: @YES,
                UIPasteboardOptionExpirationDate: futureDate
            }];
            
            [pasteboard setValue:labelLeft.text ? [NSURL URLWithString:labelLeft.text] : @""  forPasteboardType:(id)kUTTypeURL];
        }];
        
        [_demoView2 addSubview:buttonLeft];
        
        UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonRight setTitle:@"Paste Url" forState:UIControlStateNormal];
        [buttonRight sizeToFit];
        buttonRight.center = CGPointMake(CGRectGetMidX(labelRight.frame), CGRectGetMaxY(labelRight.frame) + CGRectGetHeight(buttonRight.frame) / 2.0 + paddingV);
        weakify(labelRight);
        [WCControlTool addBlockForControl:buttonRight events:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            strongifyWithReturn(labelRight, return;);
            
            UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"sample_pasteboard" create:YES];
            labelRight.text = pasteboard.URL.absoluteString;
        }];
        
        [_demoView2 addSubview:buttonRight];
        
        _demoView2.frame = FrameSetSize(_demoView2.frame, NAN, CGRectGetMaxY(buttonRight.frame));
    }
    
    return _demoView2;
}

- (UIView *)demoView3 {
    if (!_demoView3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat paddingH = 10;
        CGFloat paddingV = 10;
        
        UIImage *image = [UIImage imageNamed:@"image.jpeg"];
        
        CGFloat imageViewWidth = (screenSize.width - 3 * paddingH) / 2.0;
        CGFloat imageViewHeight = image.size.height * imageViewWidth / image.size.width;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_demoView2.frame) + paddingH + SpaceV, screenSize.width, UNSPECIFIED)];
        _demoView3 = view;
        
        UIImageView *imageViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(paddingH, 0, imageViewWidth, imageViewHeight)];
        imageViewLeft.image = image;
        imageViewLeft.layer.borderColor = [UIColor redColor].CGColor;
        imageViewLeft.layer.borderWidth = 1;
        [_demoView3 addSubview:imageViewLeft];
        
        UIImageView *imageViewRight = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewLeft.frame) + paddingH, 0, imageViewWidth, imageViewHeight)];
        imageViewRight.layer.borderColor = [UIColor redColor].CGColor;
        imageViewRight.layer.borderWidth = 1;
        [_demoView3 addSubview:imageViewRight];
        
        UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonLeft setTitle:@"Copy Image" forState:UIControlStateNormal];
        [buttonLeft sizeToFit];
        buttonLeft.center = CGPointMake(CGRectGetMidX(imageViewLeft.frame), CGRectGetMaxY(imageViewLeft.frame) + CGRectGetHeight(buttonLeft.frame) / 2.0 + paddingV);
        weakify(imageViewLeft);
        [WCControlTool addBlockForControl:buttonLeft events:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            strongifyWithReturn(imageViewLeft, return;);
            
            if (imageViewLeft.image) {
                NSData *data = UIImagePNGRepresentation(imageViewLeft.image);
                [[UIPasteboard generalPasteboard] setData:data forPasteboardType:(id)kUTTypePNG];
            }
        }];
        [_demoView3 addSubview:buttonLeft];
        
        UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonRight setTitle:@"Paste Image" forState:UIControlStateNormal];
        [buttonRight sizeToFit];
        buttonRight.center = CGPointMake(CGRectGetMidX(imageViewRight.frame), CGRectGetMaxY(imageViewRight.frame) + CGRectGetHeight(buttonRight.frame) / 2.0 + paddingV);
        weakify(imageViewRight);
        [WCControlTool addBlockForControl:buttonRight events:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            strongifyWithReturn(imageViewRight, return;);
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            if ([pasteboard containsPasteboardTypes:UIPasteboardTypeListImage]) {
                for (NSString *imageType in UIPasteboardTypeListImage) {
                    if ([imageType isEqualToString:(id)kUTTypePNG]) {
                        NSData *data = [pasteboard dataForPasteboardType:imageType];
                        if (data.length) {
                            imageViewRight.image = [UIImage imageWithData:data];
                            break;
                        }
                    }
                }
            }
        }];
        [_demoView3 addSubview:buttonRight];
        
        _demoView3.frame = FrameSetSize(_demoView3.frame, NAN, CGRectGetMaxY(buttonRight.frame));
    }
    
    return _demoView3;
}

@end
