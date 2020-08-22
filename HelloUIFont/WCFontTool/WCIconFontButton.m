//
//  WCIconFontButton.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCIconFontButton.h"
#import "WCIconFont.h"

#define kDefaultIconFontButtonWidth          60
#define kDefaultIconFontButtonHeight         40

#define kDefaultImageFontSize                28.0
#define kDefaultTitleFontSize                16.0

#define kDefaultImageWidth                   28.0
#define KDefaultMargin                       2.0


#define kDefaultColor   [UIColor colorWithRed:0x5f/255.0 green:0x64/255.0 blue:0x6e/255.0 alpha:1.0]

@interface TBIconFontButton ()
@property(nonatomic, strong)NSMutableDictionary *titleDict;
@property(nonatomic, strong)NSMutableDictionary *imageTitleDict;
@property(nonatomic, strong)NSMutableDictionary *titleColorDict;
@property(nonatomic, strong)NSMutableDictionary *imageColorDict;
@property(nonatomic, strong)NSMutableDictionary *backColorDict;
@property(nonatomic, assign)CGFloat imageFontSize;
@property(nonatomic, assign)BOOL imageFrameReset, titleFrameReset;

@end

@implementation TBIconFontButton

+ (instancetype)iconFontButton{
    TBIconFontButton *iconFontButton = [[TBIconFontButton alloc] initWithFrame:CGRectMake(0, 0, kDefaultIconFontButtonWidth, kDefaultIconFontButtonHeight)];
    return iconFontButton;
}

#pragma mark - Life Circle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _imageLabel.font = [TBIconFont iconFontWithSize:kDefaultImageFontSize];
        _titleLabel.font = [TBIconFont iconFontWithSize:kDefaultTitleFontSize];
        _imageLabel.frame = CGRectMake(KDefaultMargin, 0, kDefaultImageWidth, self.bounds.size.height);
        CGFloat originX = _imageLabel.frame.size.height + 2*KDefaultMargin;
        _titleLabel.frame = CGRectMake(originX, 0, MAX(0, self.bounds.size.width-originX), self.bounds.size.height);
        _titleLabel.textColor = kDefaultColor;
        [self addSubview:_imageLabel];
        [self addSubview:_titleLabel];
        
        _imageLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.imageLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.titleDict      = [NSMutableDictionary dictionaryWithCapacity:0];
        self.titleColorDict = [NSMutableDictionary dictionaryWithCapacity:0];
        self.imageColorDict = [NSMutableDictionary dictionaryWithCapacity:0];
        self.imageTitleDict = [NSMutableDictionary dictionaryWithCapacity:0];
        self.backColorDict  = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [self.titleColorDict addEntriesFromDictionary:@{[NSNumber numberWithInteger:UIControlStateNormal]: kDefaultColor,
                                                        [NSNumber numberWithInteger:UIControlStateHighlighted]: kDefaultColor,
                                                        [NSNumber numberWithInteger:UIControlStateDisabled]: [UIColor grayColor],
                                                        [NSNumber numberWithInteger:UIControlStateSelected]: kDefaultColor}];
        [self.imageColorDict addEntriesFromDictionary:@{[NSNumber numberWithInteger:UIControlStateNormal]: kDefaultColor,
                                                        [NSNumber numberWithInteger:UIControlStateHighlighted]: kDefaultColor,
                                                        [NSNumber numberWithInteger:UIControlStateDisabled]: [UIColor grayColor],
                                                        [NSNumber numberWithInteger:UIControlStateSelected]: kDefaultColor}];
        [self.backColorDict addEntriesFromDictionary:@{[NSNumber numberWithInteger:UIControlStateNormal]: [UIColor clearColor],
                                                       [NSNumber numberWithInteger:UIControlStateHighlighted]: [UIColor clearColor],
                                                       [NSNumber numberWithInteger:UIControlStateDisabled]: [UIColor clearColor],
                                                       [NSNumber numberWithInteger:UIControlStateSelected]: [UIColor clearColor]}];
    }
    return self;
}

#pragma mark - Public  Method  Required
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if (title) {
        [self.titleDict setObject:title forKey:[NSNumber numberWithInteger:state]];
    }
    self.titleLabel.text = [self validateTitle];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    if (color) {
        [self.titleColorDict setObject:color forKey:[NSNumber numberWithInteger:state]];
    }
    self.titleLabel.textColor = [self validateTitleColor];
}

- (void)setImageName:(NSString *)imageName forState:(UIControlState)state{
    if (imageName) {
        [self.imageTitleDict setObject:imageName forKey:[NSNumber numberWithInteger:state]];
    }
    self.imageLabel.text = [TBIconFont iconFontUnicodeWithName:[self validateImageTitle]];
}

- (void)setImageColor:(UIColor *)color forState:(UIControlState)state{
    if (color) {
        [self.imageColorDict setObject:color forKey:[NSNumber numberWithInteger:state]];
    }
    self.imageLabel.textColor = [self validateImageTitleColor];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    if (backgroundColor) {
        [self.backColorDict setObject:backgroundColor forKey:[NSNumber numberWithInteger:state]];
    }
    super.backgroundColor = [self validateBackgroundColor];
}

- (void)setImageNormalName:(NSString *)nameN highlightedName:(NSString*)nameH{
    if (nameN) {
        [self.imageTitleDict setObject:nameN forKey:[NSNumber numberWithInteger:UIControlStateNormal]];
    }
    if (nameH) {
        [self.imageTitleDict setObject:nameH forKey:[NSNumber numberWithInteger:UIControlStateSelected]];
        [self.imageTitleDict setObject:nameH forKey:[NSNumber numberWithInteger:UIControlStateHighlighted]];
    }
    
    NSString* name = [self validateImageTitle];// self.selected ? nameH : nameN;
    self.imageLabel.text = [TBIconFont iconFontUnicodeWithName:name];
}

- (void)setTitle:(NSString*)title{
    if (title) {
        [self.titleDict setObject:title forKey:[NSNumber numberWithInteger:UIControlStateNormal]];
        [self.titleDict setObject:title forKey:[NSNumber numberWithInteger:UIControlStateSelected]];
        [self.titleDict setObject:title forKey:[NSNumber numberWithInteger:UIControlStateHighlighted]];
    }
    self.titleLabel.text = [self validateTitle];
}


#pragma mark - Public  Method optional
- (void)setImageNormalColor:(UIColor *)colorN highlightedColor:(UIColor*)colorH{
    if (colorN) {
        [self.imageColorDict setObject:colorN forKey:[NSNumber numberWithInteger:UIControlStateNormal]];
    }
    if (colorH) {
        [self.imageColorDict setObject:colorH forKey:[NSNumber numberWithInteger:UIControlStateHighlighted]];
        [self.imageColorDict setObject:colorH forKey:[NSNumber numberWithInteger:UIControlStateSelected]];
    }
    self.imageLabel.textColor = [self validateImageTitleColor];//self.selected ? self.imageColorH : self.imageColorN;
}

- (void)setImageNormalColor:(UIColor *)colorN highlightedColor:(UIColor*)colorH diableColor:(UIColor*)colorD{
    [self setImageNormalColor:colorN highlightedColor:colorH];
    if (colorD) {
        [self.imageColorDict setObject:colorD forKey:[NSNumber numberWithInteger:UIControlStateDisabled]];
    }
}

- (void)setTitleNormalColor:(UIColor *)colorN highlightedColor:(UIColor*)colorH{
    if (colorN) {
        [self.titleColorDict setObject:colorN forKey:[NSNumber numberWithInteger:UIControlStateNormal]];
    }
    if (colorH) {
        [self.titleColorDict setObject:colorH forKey:[NSNumber numberWithInteger:UIControlStateHighlighted]];
        [self.titleColorDict setObject:colorH forKey:[NSNumber numberWithInteger:UIControlStateSelected]];
    }
    self.titleLabel.textColor = [self validateTitleColor];//self.selected ? self.titleColorH : self.titleColorN;
}

- (void)setTitleNormalColor:(UIColor *)colorN highlightedColor:(UIColor*)colorH diableColor:(UIColor*)colorD{
    [self setTitleNormalColor:colorN highlightedColor:colorH];
    if (colorD) {
        [self.titleColorDict setObject:colorD forKey:[NSNumber numberWithInteger:UIControlStateDisabled]];
    }
}


- (void)setImageFontSize:(NSInteger )imageFontSize titleFontSize:(NSInteger)textFontSize{
    self.imageLabel.font = [TBIconFont iconFontWithSize:imageFontSize];
    self.titleLabel.font = [UIFont systemFontOfSize:textFontSize];
    _imageFontSize = imageFontSize;
    
    [self setNeedsLayout];
}

- (void)setImageFontSize:(CGFloat)imageFontSize
{
    _imageFontSize = imageFontSize;
    
    [self setNeedsLayout];
}

- (void)setTitleFrame:(CGRect)frame{
    self.titleLabel.frame = frame;
    _titleFrameReset = YES;
}

- (void)setImageFrame:(CGRect)frame{
    self.imageLabel.frame = frame;
    _imageFrameReset = YES;
}

#pragma mark -
- (id)validateItemWithDict:(NSMutableDictionary*)dict{
    id object = nil;
    if (!self.isEnabled) {
        object = [dict objectForKey:[NSNumber numberWithInteger:UIControlStateDisabled]];
    } else if(self.isSelected) {
        object = [dict objectForKey:[NSNumber numberWithInteger:UIControlStateSelected]];
    } else if(self.isHighlighted){
        object = [dict objectForKey:[NSNumber numberWithInteger:UIControlStateHighlighted]];
    }
    object = object ? object : [dict objectForKey:[NSNumber numberWithInteger:UIControlStateNormal]];
    return object;
}


- (UIColor*)validateBackgroundColor{
    return [self validateItemWithDict:self.backColorDict];
}

- (UIColor*)validateImageTitleColor{
    return [self validateItemWithDict:self.imageColorDict];
}

- (UIColor*)validateTitleColor{
    return [self validateItemWithDict:self.titleColorDict];
}

- (NSString*)validateImageTitle{
    return [self validateItemWithDict:self.imageTitleDict];
}

- (NSString*)validateTitle{
    return [self validateItemWithDict:self.titleDict];
}

- (void)updateButtonState{
    //backgroundColor被自己覆盖了，不能用self，这边写的哎
    super.backgroundColor      = [self validateBackgroundColor];
    self.imageLabel.textColor = [self validateImageTitleColor];
    self.titleLabel.textColor = [self validateTitleColor];
    self.imageLabel.text      = [TBIconFont iconFontUnicodeWithName:[self validateImageTitle]];
    self.titleLabel.text      = [TBIconFont iconFontUnicodeWithName:[self validateTitle]];
}

#pragma mark - Override
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(_imageFrameReset && _titleFrameReset)
    {
        return;
    }
    else if(_imageFrameReset)
    {
        CGFloat textWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}].width;
        
        if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            CGFloat originX = self.imageLabel.frame.origin.x + self.imageLabel.frame.size.width + 2;
            self.titleLabel.frame = CGRectMake(originX, 0, MIN(textWidth, self.bounds.size.width-originX), self.bounds.size.height);
        }
        else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            CGFloat originX = self.imageLabel.frame.origin.x + self.imageLabel.frame.size.width + 2;
            self.titleLabel.frame = CGRectMake(MAX(originX, self.bounds.size.width - textWidth - 2 * 2), 0, MIN(textWidth, self.bounds.size.width - originX - 2), self.bounds.size.height);
        }
        else
        {
            CGFloat originX = self.imageLabel.frame.origin.x + self.imageLabel.frame.size.width + 2;
            self.titleLabel.frame = CGRectMake(MAX(originX, (self.bounds.size.width - originX - textWidth) / 2.0 + originX), 0, MIN(textWidth, self.bounds.size.width - originX - 2), self.bounds.size.height);
        }
    }
    else if(_titleFrameReset)
    {
        CGFloat imageWidth = [self.imageLabel.font pointSize];
        
        if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            CGFloat originX = MIN(self.bounds.size.width - self.titleLabel.frame.origin.x - imageWidth - 2, 2);
            self.imageLabel.frame = CGRectMake(originX, 0, imageWidth, self.bounds.size.height);
        }
        else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            CGFloat originX = MAX(2, self.bounds.size.width - self.titleLabel.frame.origin.x - imageWidth - 2);
            self.imageLabel.frame = CGRectMake(originX, 0, MIN(imageWidth, self.bounds.size.width - self.titleLabel.frame.origin.x - 2 * 2), self.bounds.size.height);
        }
        else
        {
            CGFloat originX = MAX(2, (self.bounds.size.width - self.titleLabel.frame.origin.x - imageWidth - 2) / 2.0);
            self.imageLabel.frame = CGRectMake(originX, 0, MIN(imageWidth, self.bounds.size.width - self.titleLabel.frame.origin.x - 2 * 2), self.bounds.size.height);
        }
    }
    else
    {
        CGFloat textWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}].width;
        CGFloat imageWidth = [self.imageLabel.font pointSize];
        
        if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft)
        {
            CGFloat originX = 2;
            self.imageLabel.frame = CGRectMake(originX, 0, imageWidth, self.bounds.size.height);
            originX += self.imageLabel.frame.size.width + 2;
            self.titleLabel.frame = CGRectMake(originX, 0, MIN(textWidth, self.bounds.size.width-originX), self.bounds.size.height);
        }
        else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight)
        {
            CGFloat originX = 2;
            self.imageLabel.frame = CGRectMake(MAX(originX, self.bounds.size.width - textWidth - imageWidth - 2 * 3), 0, imageWidth, self.bounds.size.height);
            originX = self.imageLabel.frame.origin.x + self.imageLabel.frame.size.width + 2;
            self.titleLabel.frame = CGRectMake(originX, 0, MIN(textWidth, self.bounds.size.width - originX - 2), self.bounds.size.height);
        }
        else
        {
            CGFloat originX = 2;
            self.imageLabel.frame = CGRectMake(MAX(originX, (self.bounds.size.width - textWidth - imageWidth - 2 * 3) / 2), 0, imageWidth, self.bounds.size.height);
            
            originX += self.imageLabel.frame.origin.x + self.imageLabel.frame.size.width + 2;
            self.titleLabel.frame = CGRectMake(originX, 0, MIN(textWidth, self.bounds.size.width - originX - 2), self.bounds.size.height);
        }
    }
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self updateButtonState];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self updateButtonState];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self updateButtonState];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    [self.backColorDict setObject:backgroundColor forKey:[NSNumber numberWithInteger:UIControlStateNormal]];
    [self.backColorDict setObject:backgroundColor forKey:[NSNumber numberWithInteger:UIControlStateHighlighted]];
    [self.backColorDict setObject:backgroundColor forKey:[NSNumber numberWithInteger:UIControlStateDisabled]];
    [self.backColorDict setObject:backgroundColor forKey:[NSNumber numberWithInteger:UIControlStateSelected]];
}
@end
