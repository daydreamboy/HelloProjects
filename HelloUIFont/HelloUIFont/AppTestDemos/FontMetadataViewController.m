//
//  FontMetadataViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/8/21.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "FontMetadataViewController.h"
#import <CoreText/CoreText.h>
#import <CoreFoundation/CoreFoundation.h>
#import "WCFontTool.h"

@interface MyCustomCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UILabel *textLabel;
@end

@interface MyCustomCollectionViewCell ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation MyCustomCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        
        // Note: not add subview to itself according to Apple Doc
        //[self addSubview:label];
        [self.contentView addSubview:label];
        
        _textLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

@end


@interface FontMetadataViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) WCFontInfo *fontInfo;
@property (nonatomic, strong) NSArray<WCFontGlyphInfo *> *glyphInfos;
@property (nonatomic, strong) UICollectionView *collectionView6;
@property (nonatomic, copy) NSString *fontName;
@end

@implementation FontMetadataViewController

- (instancetype)initWithFontFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _fontInfo = [WCFontTool fontInfoWithFilePath:filePath];
        
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
        _glyphInfos = [_fontInfo.glyphInfos sortedArrayUsingDescriptors:@[sorter]];
        
        NSString *fontName;
        [WCFontTool registerFontWithFilePath:filePath fontName:&fontName error:nil];
        _fontName = fontName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView6];
}

- (void)dealloc {
    [WCFontTool unregisterIconFontWithName:self.fontName error:nil completionHandler:nil];
}

- (UICollectionView *)collectionView6 {
    if (!_collectionView6) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = screenSize.width / 6.0;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(side, side);
        layout.minimumLineSpacing = 0; // Note: default is 10
        layout.minimumInteritemSpacing = 0; // Note: default is 10
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - startY) collectionViewLayout:layout];
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = [UIColor clearColor];
        
        [view registerClass:[MyCustomCollectionViewCell class] forCellWithReuseIdentifier:@"sCellIdentifier"];
        
        _collectionView6 = view;
    }
    
    return _collectionView6;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath: %@", @(indexPath.row));
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
    cell.textLabel.font = [UIFont fontWithName:self.fontName size:32];
    cell.textLabel.text = glyphInfo.character;
    
    return cell;
}

@end
