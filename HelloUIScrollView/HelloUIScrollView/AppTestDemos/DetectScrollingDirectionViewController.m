//
//  DetectScrollingDirectionViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/12/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "DetectScrollingDirectionViewController.h"
#import "WCScrollViewTool.h"

@interface DetectScrollingDirectionViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *hudTip;
@property (nonatomic, strong) NSValue *lastContentOffset;
@property (nonatomic, assign) WCScrollViewScrollingDirection scrollDirection;
@end

@implementation DetectScrollingDirectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.hudTip];
    
    UIBarButtonItem *verticalItem = [[UIBarButtonItem alloc] initWithTitle:@"Vertical" style:UIBarButtonItemStylePlain target:self action:@selector(verticalItemClicked:)];
    UIBarButtonItem *horizontalItem = [[UIBarButtonItem alloc] initWithTitle:@"Horizontal" style:UIBarButtonItemStylePlain target:self action:@selector(horizontalItemClicked:)];
    UIBarButtonItem *allItem = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(allItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[allItem, horizontalItem, verticalItem];
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.alwaysBounceHorizontal = NO;
        scrollView.alwaysBounceVertical = NO;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(screenSize.width, screenSize.height * 2);
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
        _contentView.backgroundColor = [UIColor greenColor];
        
        [scrollView addSubview:_contentView];
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (UILabel *)hudTip {
    if (!_hudTip) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        label.userInteractionEnabled = NO;
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        label.alpha = 0;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:25];
        
        _hudTip = label;
    }
    
    return _hudTip;
}

#pragma mark - Actions

- (void)verticalItemClicked:(id)sender {
    CGSize contentSize = [WCScrollViewTool fittedContentSizeWithScrollView:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height * 2);
    self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

- (void)horizontalItemClicked:(id)sender {
    CGSize contentSize = [WCScrollViewTool fittedContentSizeWithScrollView:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(contentSize.width * 2, contentSize.height);
    self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

- (void)allItemClicked:(id)sender {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.scrollView.contentSize = CGSizeMake(screenSize.width * 2, screenSize.height * 2);
    self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"User begin dragging");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"User end dragging and is decelerate: %@", decelerate ? @"YES" : @"NO");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ScrollView begin decelerating: %f", scrollView.contentOffset.y);
    
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    self.hudTip.alpha = 1;
//    self.hudTip.text = @"begin decelerating by user";
//    [self.hudTip sizeToFit];
//    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"ScrollView end decelerating");
    
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    self.hudTip.alpha = 1;
//    self.hudTip.text = @"end decelerating by user";
//    [self.hudTip sizeToFit];
//    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
//    [UIView animateWithDuration:1.5 animations:^{
//        self.hudTip.alpha = 0;
//    }];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"ScrollView end scrolling by animation");
    
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    self.hudTip.alpha = 1;
//    self.hudTip.text = @"end scrolling by animation";
//    [self.hudTip sizeToFit];
//    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
//    [UIView animateWithDuration:1.5 animations:^{
//        self.hudTip.alpha = 0;
//    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll.y: %f", scrollView.contentOffset.y);
    NSLog(@"scrollViewDidScroll.x: %f", scrollView.contentOffset.x);

    if (self.lastContentOffset) {
        if (scrollView.contentOffset.x > [self.lastContentOffset CGPointValue].x) {
            self.scrollDirection = WCScrollViewScrollingDirectionRight;
        }
        else if (scrollView.contentOffset.x < [self.lastContentOffset CGPointValue].x) {
            self.scrollDirection = WCScrollViewScrollingDirectionLeft;
        }
        // scroll view move down and check is over top
        else if (scrollView.contentOffset.y > [self.lastContentOffset CGPointValue].y && ![WCScrollViewTool checkIsOverTopWithScrollView:scrollView]) {
            self.scrollDirection = WCScrollViewScrollingDirectionDown;
        }
        // scroll view move up and check is over bottom
        else if (scrollView.contentOffset.y < [self.lastContentOffset CGPointValue].y && ![WCScrollViewTool checkIsOverBottomWithScrollView:scrollView]) {
            self.scrollDirection = WCScrollViewScrollingDirectionUp;
        }
    }

    self.lastContentOffset = [NSValue valueWithCGPoint:scrollView.contentOffset];
    
    // @see https://stackoverflow.com/a/1857162
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    // Note: ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrolling:) withObject:scrollView afterDelay:0.3];
}

#pragma mark -

- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidEndScrollingAnimation:) object:scrollView];
    
    NSLog(@"ScrollView end scrolling");
    
    NSString *direction;
    switch (self.scrollDirection) {
        case WCScrollViewScrollingDirectionLeft:
            direction = @"Left";
            break;
        case WCScrollViewScrollingDirectionRight:
            direction = @"Right";
            break;
        case WCScrollViewScrollingDirectionUp:
            direction = @"Up";
            break;
        case WCScrollViewScrollingDirectionDown:
            direction = @"Down";
            break;
        case WCScrollViewScrollingDirectionNone:
        default:
            direction = @"None";
            break;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.hudTip.alpha = 1;
    self.hudTip.text = [NSString stringWithFormat:@"end scrolling with %@", direction];
    [self.hudTip sizeToFit];
    self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [UIView animateWithDuration:1.5 animations:^{
        self.hudTip.alpha = 0;
    }];
}

@end
