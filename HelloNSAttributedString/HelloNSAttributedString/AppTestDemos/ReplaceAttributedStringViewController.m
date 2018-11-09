//
//  ReplaceAttributedStringViewController.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2018/11/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ReplaceAttributedStringViewController.h"
#import "NSAttributedString+Addition.h"
#import "WCAttributedStringTool.h"

@interface ReplaceAttributedStringViewController ()
@property (nonatomic, strong) UILabel *attrLabel;
@end

@implementation ReplaceAttributedStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    NSAttributedString *blue, *green, *never, *result;
    
    blue = [[NSAttributedString alloc] initWithString:@"Blue" attributes:@{
                                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                                                           NSForegroundColorAttributeName: [UIColor blueColor],
                                                                           }];
    
    green = [[NSAttributedString alloc] initWithString:@"Green" attributes:@{
                                                                             NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                                                             NSForegroundColorAttributeName: [UIColor greenColor],
                                                                             }];
    
    never = [[NSAttributedString alloc] initWithString:@"never" attributes:@{
                                                                             NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                             }];
    
    // Bug: Append "\n" to show  ,see http://stackoverflow.com/questions/19127828/ios-7-bug-nsattributedstring-does-not-appear
    result = [NSAttributedString attributedStringWithFormat:@"%@ and %@ must %@ be seen\n", blue, green, never];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = self.view.center;
    label.backgroundColor = [UIColor redColor];
    label.attributedText = [WCAttributedStringTool replaceStringWithAttributedString:result occurrenceString:@"Blue" replacementString:@"Blue GoGo" range:NSMakeRange(0, result.length)];;
    [self.view addSubview:label];
    
    UILabel *attrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 30)];
    attrLabel.attributedText = blue;
    [self.view addSubview:attrLabel];
    self.attrLabel = attrLabel;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, screenSize.height - 30, screenSize.width, 30);
    [button setTitle:@"Add NSAttributedString" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClicked:(UIButton *)button {
    
    static NSInteger i = 0;
    NSAttributedString *blue, *green, *never;
    
    blue = [[NSAttributedString alloc] initWithString:@"Blue" attributes:@{
                                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                                                           NSForegroundColorAttributeName: [UIColor blueColor],
                                                                           }];
    
    green = [[NSAttributedString alloc] initWithString:@"Green" attributes:@{
                                                                             NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                                                             NSForegroundColorAttributeName: [UIColor greenColor],
                                                                             }];
    
    never = [[NSAttributedString alloc] initWithString:@"never" attributes:@{
                                                                             NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                             }];
    
    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithAttributedString:self.attrLabel.attributedText];
    
    NSAttributedString *append;
    if (i % 3 == 0) {
        append = green;
    }
    else if (i % 3 == 1) {
        append = blue;
    }
    else if (i % 3 == 2) {
        append = never;
    }
    [temp appendAttributedString:append];
    self.attrLabel.attributedText = temp;
    
    i++;
}

@end
