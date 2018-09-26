//
//  UseYYLabelWithLinkViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseYYLabelWithLinkViewController.h"
#import "YYLabel.h"
#import "YYKit.h"

@interface MyView : UIView

@end

@implementation MyView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}
@end

@interface UseYYLabelWithLinkViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) YYLabel *label1;
@property (nonatomic, strong) YYLabel *label2;
@property (nonatomic, strong) YYLabel *label3;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyView *myView;
@end

@implementation UseYYLabelWithLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myView];
    
    UITapGestureRecognizer *tapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewTapped:)];
    tapGesure.delegate = self;
    tapGesure.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesure];
}

#pragma mark - Actions

- (void)selfViewTapped:(id)sender {
    NSLog(@"tapped");
}

- (void)bubbleTapped:(id)sender {
    NSLog(@"tapped2");
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            
        }
        
        return NO;
    }
    return YES;
}

#pragma mark - Getters

- (YYLabel *)label1 {
    if (!_label1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string = @"This is a link, www.baidu.com. Tap to open it.";
        NSRange range = [string rangeOfString:@"www.baidu.com"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attrString setTextHighlightRange:range
                                 color:[UIColor blueColor]
                       backgroundColor:nil//[UIColor lightGrayColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 NSLog(@"tap text range:...");
                             }];
        
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, 100, screenSize.width - 2 * 10, 30)];
        label.attributedText = attrString;
        [label setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"text: %@", text);
        }];
        
        _label1 = label;
    }
    
    return _label1;
}

- (YYLabel *)label2 {
    if (!_label2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string = @"This is a link, www.baidu.com. Tap to open it.";
        NSRange range = [string rangeOfString:@"www.baidu.com"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attrString setTextHighlightRange:range color:[UIColor blueColor] backgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] userInfo:@{@"key": @"value"}];
        
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label1.frame) + 10, screenSize.width - 2 * 10, 30)];
        label.attributedText = attrString;
        [label setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"highlighted text: %@", [text attributedSubstringFromRange:range]);
            NSDictionary *attrs = [[text attributedSubstringFromRange:range] attributesAtIndex:0 effectiveRange:nil];
            NSLog(@"userInfo: %@", [attrs[YYTextHighlightAttributeName] userInfo]);
        }];
        
        _label2 = label;
    }
    
    return _label2;
}

- (YYLabel *)label3 {
    if (!_label3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string = @"This is a link, www.baidu.com. Tap to open it.";
        NSRange range = [string rangeOfString:@"www.baidu.com"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        
        YYTextHighlight *textHighlight = [YYTextHighlight highlightWithBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]];
        [textHighlight setColor:[UIColor blueColor]];
        [textHighlight setUserInfo:@{@"key": @"value"}];
        [textHighlight setTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"highlighted text: %@", [text attributedSubstringFromRange:range]);
            NSDictionary *attrs = [[text attributedSubstringFromRange:range] attributesAtIndex:0 effectiveRange:nil];
            NSLog(@"userInfo: %@", [attrs[YYTextHighlightAttributeName] userInfo]);
        }];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        [attrString setTextHighlight:textHighlight range:range];
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label2.frame) + 10, screenSize.width - 2 * 10, 30)];
        label.attributedText = attrString;
        // Note: not called
        [label setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"highlighted text: %@", [text attributedSubstringFromRange:range]);
            NSDictionary *attrs = [[text attributedSubstringFromRange:range] attributesAtIndex:0 effectiveRange:nil];
            NSLog(@"userInfo: %@", [attrs[YYTextHighlightAttributeName] userInfo]);
        }];
        
        _label3 = label;
    }
    
    return _label3;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, screenSize.width, 200) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        _tableView = tableView;
    }
    
    return _tableView;
}

- (MyView *)myView {
    if (!_myView) {
        MyView *view = [[MyView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame), 100, 100)];
        view.backgroundColor = [UIColor yellowColor];
        _myView = view;
    }
    
    return _myView;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"UseYYLabelWithLinkViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string = @"This is a link, www.baidu.com. Tap to open it.";
        NSRange range = [string rangeOfString:@"www.baidu.com"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attrString setTextHighlightRange:range color:[UIColor blueColor] backgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] userInfo:@{@"key": @"value"}];
        
//        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 30)];
//        label.attributedText = attrString;
//        [label setHighlightTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//            NSLog(@"highlighted text: %@", [text attributedSubstringFromRange:range]);
//            NSDictionary *attrs = [[text attributedSubstringFromRange:range] attributesAtIndex:0 effectiveRange:nil];
//            NSLog(@"userInfo: %@", [attrs[YYTextHighlightAttributeName] userInfo]);
//        }];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        view.backgroundColor = [UIColor greenColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleTapped:)];
        [view addGestureRecognizer:tap];
        view.tag = 100;
        
        UIView *subview = [cell.contentView viewWithTag:100];
        if (!subview) {
            [cell.contentView addSubview:view];
        }
        
//        [cell addSubview:label];
    }
    
    return cell;
}

@end
