//
//  TransitionColorsViewController.m
//  AppTest
//
//  Created by wesley chen on 15/7/31.
//
//

#import "TransitionColorsViewController.h"
#import "WCColorTool.h"

@interface TransitionColorsViewController ()
@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *toLabel;
@end

@implementation TransitionColorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 20 + 64, screenSize.width - 2 * 20, 30)];
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    slider.maximumValue = 1.0;
    slider.minimumValue = 0.0;
    [self.view addSubview:slider];
    
    UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(slider.frame), screenSize.width / 2, 30)];
    fromLabel.textAlignment = NSTextAlignmentCenter;
    fromLabel.text = @"0.0";
    fromLabel.textColor = [UIColor whiteColor];
    fromLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:fromLabel];
    self.fromLabel = fromLabel;
    
    UILabel *toLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fromLabel.frame), CGRectGetMaxY(slider.frame), screenSize.width / 2, 30)];
    toLabel.textAlignment = NSTextAlignmentCenter;
    toLabel.text = @"1.0";
    toLabel.textColor = [UIColor whiteColor];
    toLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:toLabel];
    self.toLabel = toLabel;
}

- (void)valueChanged:(UISlider *)sender {
    NSLog(@"value: %f", sender.value);
    
    NSArray *colors = [WCColorTool transitionColorsFromColor:[UIColor redColor] toColor:[UIColor greenColor] onProgress:sender.value];
    
    self.fromLabel.backgroundColor = colors[0];
    self.toLabel.backgroundColor = colors[1];
    
    self.fromLabel.text = [NSString stringWithFormat:@"%f", sender.value];
    self.toLabel.text = [NSString stringWithFormat:@"%f", 1 - sender.value];
}

@end
