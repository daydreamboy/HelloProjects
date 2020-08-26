//
//  UseMulticastDelegateViewController.m
//  HelloNSObject
//
//  Created by wesley_chen on 2020/8/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseMulticastDelegateViewController.h"

@interface MyTextView1 : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@end

@interface MyTextView1 () <UITextViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *placeHolderLabel;
//@property (nonatomic, assign) id<UITextViewDelegate> textViewDelegate;
@property (nonatomic, assign, readwrite) UIEdgeInsets paddingInsets;
@property (nonatomic, assign) CGFloat paddingsH;
@property (nonatomic, assign) CGFloat paddingsV;
@end

@implementation MyTextView1

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _placeholder = @"";
        _placeholderColor = [UIColor lightGrayColor];
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0)];
        _placeHolderLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
#if DEBUG_UI
        _placeHolderLabel.backgroundColor = [UIColor greenColor];
#endif
    }
    
    return self;
}

- (void)dealloc {
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_placeHolderLabel.superview) {
        if (_placeholder.length) {
            _placeHolderLabel.text = _placeholder;
            _placeHolderLabel.textColor = _placeholderColor;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.alpha = [self.text length] ? 0 : 1;
            
            _placeHolderLabel.frame = CGRectMake(0, 0, 200, 30);
        }
        [self addSubview:_placeHolderLabel];
        [self sendSubviewToBack:_placeHolderLabel];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    [self togglePlaceholder];
}

- (void)togglePlaceholder {
    if (_placeholder.length) {
        _placeHolderLabel.alpha = [self.text length] ? 0 : 1;
    }
}

@end


@interface UseMulticastDelegateViewController ()

@end

@implementation UseMulticastDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
