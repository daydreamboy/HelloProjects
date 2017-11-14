//
//  DrawStringFromSimpleMarkupV1ViewController.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DrawStringFromSimpleMarkupV1ViewController.h"
#import "CTViewV3.h"
#import "MarkupParserV1.h"

@interface DrawStringFromSimpleMarkupV1ViewController ()

@end

@implementation DrawStringFromSimpleMarkupV1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zombies" ofType:@"txt"];
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    MarkupParserV1 *parser = [MarkupParserV1 new];
    [parser parseMarkup:text];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CTViewV3 *view = [[CTViewV3 alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    
    [view importAttrString:parser.attrStringM];
    
    [self.view addSubview:view];
}

@end
