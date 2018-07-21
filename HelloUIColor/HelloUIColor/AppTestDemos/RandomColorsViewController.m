//
//  RandomColorsViewController.m
//  AppTest
//
//  Created by wesley_chen on 23/10/2017.
//

#import "RandomColorsViewController.h"
#import "WCColorTool.h"

@interface RandomColorsViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation RandomColorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.label];
    self.label.text = [WCColorTool RGBAHexStringFromUIColor:self.view.backgroundColor];
}

#pragma mark - Getters

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.center = self.view.center;
        label.backgroundColor = [UIColor darkGrayColor];
        
        _label = label;
    }
    
    return _label;
}

#pragma mark - Actions

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    if (targetView == self.view) {
        
        NSArray *systemColors = @[
                                  UIColor.blackColor,      // 0.0 white
                                  UIColor.darkGrayColor,   // 0.333 white
                                  UIColor.lightGrayColor,  // 0.667 white
                                  UIColor.whiteColor,      // 1.0 white
                                  UIColor.grayColor,       // 0.5 white
                                  UIColor.redColor,        // 1.0, 0.0, 0.0 RGB
                                  UIColor.greenColor,      // 0.0, 1.0, 0.0 RGB
                                  UIColor.blueColor,       // 0.0, 0.0, 1.0 RGB
                                  UIColor.cyanColor,       // 0.0, 1.0, 1.0 RGB
                                  UIColor.yellowColor,     // 1.0, 1.0, 0.0 RGB
                                  UIColor.magentaColor,    // 1.0, 0.0, 1.0 RGB
                                  UIColor.orangeColor,     // 1.0, 0.5, 0.0 RGB
                                  UIColor.purpleColor,     // 0.5, 0.0, 0.5 RGB
                                  UIColor.brownColor,      // 0.6, 0.4, 0.2 RGB
                                  UIColor.clearColor
                                  ];
        
        NSInteger index = (NSInteger)arc4random() % (systemColors.count + 1);
        UIColor *color = index >= systemColors.count ? [WCColorTool randomRGBAColor] : systemColors[index];
        
        self.view.backgroundColor = color;
        self.label.text = [WCColorTool RGBAHexStringFromUIColor:self.view.backgroundColor];
    }
}


@end
