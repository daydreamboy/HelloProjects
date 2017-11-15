//
//  DrawStringWithSimpleLayoutV2ViewController.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DrawStringWithSimpleLayoutV2ViewController.h"
#import "CTViewV5.h"
#import "MarkupParserV2SupportImage.h"

@interface DrawStringWithSimpleLayoutV2ViewController ()

@end

@implementation DrawStringWithSimpleLayoutV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zombies" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    MarkupParserV2SupportImage *parser = [MarkupParserV2SupportImage new];
    [parser parseMarkup:text];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CTViewV5 *view = [[CTViewV5 alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    
    [view buildFramesWithAttrString:parser.attrStringM images:parser.images];
    
    [self.view addSubview:view];
}

@end
