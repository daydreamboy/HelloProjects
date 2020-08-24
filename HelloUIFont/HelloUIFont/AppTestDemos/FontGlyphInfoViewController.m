//
//  FontGlyphInfoViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/8/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "FontGlyphInfoViewController.h"
#import <CoreText/CoreText.h>
#import <CoreFoundation/CoreFoundation.h>
#import "WCFontTool.h"
#import "FontGlyphDetailInfoViewController.h"

@interface MyCustomCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UILabel *indexLabel;
@end

@interface MyCustomCollectionViewCell ()
@property (nonatomic, strong, readwrite) UILabel *textLabel;
@property (nonatomic, strong, readwrite) UILabel *indexLabel;
@property (nonatomic, strong, readwrite) UILabel *unicodeLabel;
@end

#define kIndexLabelH    18
#define kUnicodeLabelH  15

@implementation MyCustomCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.unicodeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.indexLabel.frame = CGRectMake(0, 0, self.bounds.size.width, kIndexLabelH);
    self.unicodeLabel.frame = CGRectMake(0, self.bounds.size.height - kUnicodeLabelH, self.bounds.size.width, kIndexLabelH);
}

#pragma mark - Getter

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        
        _textLabel = label;
    }
    
    return _textLabel;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kIndexLabelH)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor grayColor];
        
        _indexLabel = label;
    }
    
    return _indexLabel;
}

- (UILabel *)unicodeLabel {
    if (!_unicodeLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kIndexLabelH, self.bounds.size.width, kUnicodeLabelH)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor grayColor];
        
        _unicodeLabel = label;
    }
    
    return _unicodeLabel;
}

@end

typedef NS_ENUM(NSUInteger, SortType) {
    SortTypeByIndex,
    SortTypeByUnicode,
};

@interface FontGlyphInfoViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) WCFontInfo *fontInfo;
@property (nonatomic, strong) NSArray<WCFontGlyphInfo *> *glyphInfos;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, assign) CGFloat spacing;
@property (nonatomic, assign) NSUInteger numberOfCellPerRow;
@property (nonatomic, strong) UIView *collectionViewBackground;
@property (nonatomic, assign) SortType sortType;
@end

@implementation FontGlyphInfoViewController

- (instancetype)initWithFontFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _fontInfo = [WCFontTool fontInfoWithFilePath:filePath];
        
        self.title = [NSString stringWithFormat:@"%@ (%lu glyphs)", [filePath lastPathComponent], _fontInfo.glyphInfos.count];
        
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        _glyphInfos = [_fontInfo.glyphInfos sortedArrayUsingDescriptors:@[sorter]];
        
        NSString *fontName;
        [WCFontTool registerFontWithFilePath:filePath fontName:&fontName error:nil];
        _fontName = fontName;
        
        _spacing = 1.0; // BUG: use 1.0/ [UIScreen mainScreen].scale, separators show not equally
        _numberOfCellPerRow = 6;
        
        _collectionViewBackground = [UIView new];
        _collectionViewBackground.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortItemClicked:)];
}

- (void)dealloc {
    [WCFontTool unregisterIconFontWithName:self.fontName error:nil completionHandler:nil];
}

#pragma mark - Getter

- (void)sortItemClicked:(id)sender {
    if (self.sortType == SortTypeByIndex) {
        self.sortType = SortTypeByUnicode;
    }
    else if (self.sortType == SortTypeByUnicode) {
        self.sortType = SortTypeByIndex;
    }
    
    if (self.sortType == SortTypeByIndex) {
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        self.glyphInfos = [_fontInfo.glyphInfos sortedArrayUsingDescriptors:@[sorter]];
        
        [self.collectionView reloadData];
    }
    else if (self.sortType == SortTypeByUnicode) {
        self.glyphInfos = _fontInfo.glyphInfos;
        
        [self.collectionView reloadData];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat widthLeftBySpace = width - (self.numberOfCellPerRow + 1) * self.spacing;
        CGFloat itemWidth = widthLeftBySpace / self.numberOfCellPerRow;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(self.spacing, self.spacing, self.spacing, self.spacing);
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.minimumLineSpacing = self.spacing;
        layout.minimumInteritemSpacing = self.spacing;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - startY) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor whiteColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView = view;
    }
    
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath: %@", @(indexPath.row));
    
    WCFontGlyphInfo *glyphInfo = self.glyphInfos[indexPath.row];
    FontGlyphDetailInfoViewController *vc = [[FontGlyphDetailInfoViewController alloc] initWithGlyphInfo:glyphInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.glyphInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sCellIdentifier" forIndexPath:indexPath];
    WCFontGlyphInfo *glyphInfo = self.glyphInfos[indexPath.row];
    cell.textLabel.text = glyphInfo.character;
    cell.textLabel.font = [UIFont fontWithName:self.fontName size:32];
    // Note: %hu, unsigned short
    cell.indexLabel.text = [NSString stringWithFormat:@"%hu", glyphInfo.index];
    cell.indexLabel.font = [UIFont systemFontOfSize:12];
    cell.unicodeLabel.text = glyphInfo.unicodeString;
    cell.unicodeLabel.font = [UIFont systemFontOfSize:10];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (!self.collectionViewBackground.superview) {
        CGSize contentSize2 = self.collectionView.collectionViewLayout.collectionViewContentSize;
        self.collectionViewBackground.frame = CGRectMake(0, 0, contentSize2.width, contentSize2.height);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView insertSubview:self.collectionViewBackground atIndex:0];
        });
    }
    
    return cell;
}

@end
