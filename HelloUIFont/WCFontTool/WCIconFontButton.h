//
//  WCIconFontButton.h
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBIconFontButton : UIControl

+ (instancetype)iconFontButton;

//暴露imageLabel和titleLabel，最好不要使用
@property(nonatomic, readonly)UILabel *imageLabel;
@property(nonatomic, readonly)UILabel *titleLabel;

//////////////////////////////////////////////////////////////////////////////

//required
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImageName:(NSString *)imageName forState:(UIControlState)state;
- (void)setImageColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
//////////////////////////////////////////////////////////////////////////////

/**
 *  设置iconfont图片名称，可读的名称，内部会做映射 http://yunpan.taobao.com/share/link/D5FoiG4ZE
 *
 *  @param nameN 普通状态图片名称             normal
 *  @param nameH 高亮和选中状态图片名称        selected|highlighted
 */
- (void)setImageNormalName:(nullable NSString *)nameN highlightedName:(nullable NSString *)nameH;

/**
 *  设置title名称,  normal|selected|highlighted 都是该值
 *
 *  @param title
 */
- (void)setTitle:(NSString *)title;

//////////////////////////////////////////////////////////////////////////////
//optional
/**
 *  设置图片颜色，默认都是[UIColor colorWithRed:0x5f/255.0 green:0x64/255.0 blue:0x6e/255.0 alpha:1.0]
 *
 *  @param colorN 普通状态颜色              normal
 *  @param colorH 高亮和选中状态颜色         selected|highlighted
 */
- (void)setImageNormalColor:(nullable UIColor *)colorN highlightedColor:(nullable UIColor *)colorH;
//添加一个disableColor设置参数
- (void)setImageNormalColor:(nullable UIColor *)colorN highlightedColor:(nullable UIColor *)colorH diableColor:(nullable UIColor *)colorD;

/**
 *  设置title颜色，默认都是[UIColor colorWithRed:0x5f/255.0 green:0x64/255.0 blue:0x6e/255.0 alpha:1.0]
 *
 *  @param colorN 普通状态颜色
 *  @param colorH 高亮和选中状态颜色         selected|highlighted
 */
- (void)setTitleNormalColor:(nullable UIColor *)colorN highlightedColor:(nullable UIColor *)colorH;
- (void)setTitleNormalColor:(nullable UIColor *)colorN highlightedColor:(nullable UIColor *)colorH diableColor:(nullable UIColor *)colorD;

/**
 *  设置图片对应字号（iconfont），title字号（systemfont）
 *
 *  @param imageFontSize iconfont图片对应的字号，默认28.0
 *  @param titleFontSize  标题使用的系统字体字号，默认16.0
 */
- (void)setImageFontSize:(NSInteger )imageFontSize titleFontSize:(NSInteger)titleFontSize;

/**
 *  标题位置，在设置整个控件frame之后设置才有效
 *
 *  @param frame
 */
- (void)setTitleFrame:(CGRect)frame;

/**
 *  图片位置，在设置整个控件frame之后设置才有效
 *
 *  @param frame
 */
- (void)setImageFrame:(CGRect)frame;


@end

NS_ASSUME_NONNULL_END
