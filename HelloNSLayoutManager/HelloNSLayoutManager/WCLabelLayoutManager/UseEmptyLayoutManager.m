//
//  UseEmptyLayoutManager.m
//  HelloNSLayoutManager
//
//  Created by wesley_chen on 2020/11/7.
//

#import "UseEmptyLayoutManager.h"
#import "EmptyLayoutManager.h"

@interface UseEmptyLayoutManager ()
@property (nonatomic, strong) EmptyLayoutManager *usedLayoutManager;
@end

@implementation UseEmptyLayoutManager

- (instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString {
    _usedLayoutManager = [[EmptyLayoutManager alloc] init];
    return [super initWithAttributedString:attributedString layoutManager:_usedLayoutManager];
}

@end
