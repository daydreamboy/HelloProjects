//
//  FontGlyphDetailInfoViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/8/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "FontGlyphDetailInfoViewController.h"
#import "WCQuartzTool.h"
#import "WCMacroTool.h"

@interface FontGlyphDetailInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *glyphView;
@property (nonatomic, strong) WCFontGlyphInfo *glyphInfo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *listData;
@end

@implementation FontGlyphDetailInfoViewController

- (instancetype)initWithGlyphInfo:(WCFontGlyphInfo *)glyphInfo {
    self = [super init];
    if (self) {
        _glyphInfo = glyphInfo;
        
        _listData = @[
            @{ @"name": glyphInfo.name },
            @{ @"unicode": glyphInfo.unicodeString },
            @{ @"index": [NSString stringWithFormat:@"%@", @(glyphInfo.index)] },
            @{ @"boundingBox": NSStringFromCGRect(glyphInfo.boundingRect) },
        ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_RGB(0x1D242E);
    
    [self.view addSubview:self.glyphView];
    [self.view addSubview:self.tableView];
}

#pragma mark - Getter

- (UIView *)glyphView {
    if (!_glyphView) {
        CGFloat margin = 10;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat width = screenSize.width - 2 * margin;
        CGSize size = self.glyphInfo.boundingRect.size;
        
        CGFloat scale = width / size.width;
        CGFloat height = size.height * scale;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, width, height)];
        view.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        view.layer.borderColor = [UIColor grayColor].CGColor;
        
        CAShapeLayer *layerGlyph = [CAShapeLayer layer];
        layerGlyph.frame = view.bounds;
        layerGlyph.fillColor = UICOLOR_RGB(0x2B3440).CGColor;
        layerGlyph.strokeColor = [UIColor greenColor].CGColor;
        layerGlyph.lineWidth = 1.0;
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, 0, height);
        transform = CGAffineTransformScale(transform, scale, -scale);
        
        layerGlyph.path = [self.glyphInfo pathWithTransform:transform];
        [view.layer addSublayer:layerGlyph];
        
        NSArray<NSValue *> *points = [WCQuartzTool allPointsWithCGPath:layerGlyph.path];
        
        for (NSValue *value in points) {
            CGPoint pt = [value CGPointValue];
            
            CAShapeLayer *layerPoint = [CAShapeLayer new];
            layerPoint.bounds = CGRectMake(0, 0, 2, 2);
            layerPoint.position = pt;
            layerPoint.lineWidth = 2.0;
            layerPoint.fillColor = nil;
            layerPoint.strokeColor = [UIColor redColor].CGColor;
            
            CGPoint arcCenter = CGPointMake(layerPoint.bounds.size.width / 2.0, layerPoint.bounds.size.height / 2.0);
            CGFloat radius = layerPoint.bounds.size.width / 2.0;
            CGFloat startAngle = 0;
            CGFloat endAngle = M_PI * 2;
            BOOL clockwise = YES;

            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
            layerPoint.path = path.CGPath;
            
            [view.layer addSublayer:layerPoint];
        }
        
        _glyphView = view;
    }
    
    return _glyphView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(_glyphView.frame) + 50;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, screenSize.height - startY) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.layer.borderColor = [UIColor redColor].CGColor;
        tableView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"FontGlyphDetailInfoViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:sCellIdentifier];
    }
    
    NSDictionary *entry = self.listData[indexPath.row];
    cell.textLabel.text = [[entry allKeys] firstObject];
    cell.detailTextLabel.text = [[entry allValues] firstObject];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

@end
