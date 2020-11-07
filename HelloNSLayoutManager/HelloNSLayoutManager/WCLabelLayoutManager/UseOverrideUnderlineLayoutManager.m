//
//  UseOverrideUnderlineLayoutManager.m
//  HelloNSLayoutManager
//
//  Created by wesley_chen on 2020/11/7.
//

#import "UseOverrideUnderlineLayoutManager.h"
#import "OverrideUnderlineLayoutManager.h"

@interface UseOverrideUnderlineLayoutManager ()
@property (nonatomic, strong) OverrideUnderlineLayoutManager *usedLayoutManager;
@end

@implementation UseOverrideUnderlineLayoutManager

- (instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString {
    _usedLayoutManager = [[OverrideUnderlineLayoutManager alloc] init];
    return [super initWithAttributedString:attributedString layoutManager:_usedLayoutManager];
}

@end
