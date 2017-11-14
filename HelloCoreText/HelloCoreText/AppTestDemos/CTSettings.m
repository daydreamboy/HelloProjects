//
//  CTSettings.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "CTSettings.h"

@interface CTSettings ()
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) NSInteger columnPerPage;
@property (nonatomic, assign) CGRect pageRect;
@property (nonatomic, assign) CGRect columnRect;
@end

@implementation CTSettings

- (instancetype)init {
    self = [super init];
    if (self) {
        _margin = 20;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect viewBounds = CGRectMake(0, 0, screenSize.width, screenSize.height - 64);
        
        _columnPerPage = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? 1 : 2;
        _pageRect = CGRectInset(viewBounds, _margin, _margin);
        _columnRect = CGRectInset(CGRectMake(0, 0, _pageRect.size.width / _columnPerPage, _pageRect.size.height), _margin, _margin);
    }
    return self;
}

@end
