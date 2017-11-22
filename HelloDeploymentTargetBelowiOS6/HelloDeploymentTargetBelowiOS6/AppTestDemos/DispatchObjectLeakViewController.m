//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "DispatchObjectLeakViewController.h"

@interface DispatchObjectLeakViewController ()
@property (nonatomic, strong) UIView *viewSquare;
@property (nonatomic, assign) dispatch_queue_t queue;
// Compile Error: when `iOS Deployment Target` is below iOS 6, dispatch_queue_t can use `strong` or `retain`
//@property (nonatomic, strong) dispatch_queue_t queue2;
@end

@implementation DispatchObjectLeakViewController

@synthesize viewSquare = _viewSquare;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viewSquare];
    NSLog(@"%@", self.viewSquare);
    
    self.queue = dispatch_queue_create("com.wc.example", DISPATCH_QUEUE_SERIAL);
    dispatch_async(self.queue, ^{
        NSLog(@"do something in queue");
    });
    NSLog(@"%@: %p", self.queue, self.queue);
}

- (void)dealloc {
    // Note: forbidden by ARC
    //[super dealloc];
    
    // Note: should make it NULL, because its property is `assign`,
    // but for leak example, just comment it
    //self.queue = NULL;
}

#pragma mark - Getters

- (UIView *)viewSquare {
    if (!_viewSquare) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIView *viewSquare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        viewSquare.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        viewSquare.backgroundColor = [UIColor redColor];
        
        _viewSquare = viewSquare;
    }
    
    return _viewSquare;
}

@end
