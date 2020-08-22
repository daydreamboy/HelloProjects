//
//  WCIconFont.h
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TBIconFont : NSObject
/*
 *  返回iconfont对应字号的字体
 *
 *  @param fontSize 字号
 *
 *  @return 字体
 */
+ (UIFont*)iconFontWithSize:(NSInteger)fontSize;

/**
 *  使用iconfont的UIButton,text首页到映射表中查询，未找到则使用原始值
 *
 *  @param type     button类型
 *  @param fontSize iconfont字体大小
 *  @param text     iconfont编码，或者映射值：http://yunpan.taobao.com/share/link/D5FoiG4ZE,
 *
 *  @return 使用iconfont的UIButton
 */
+ (UIButton*)iconFontButtonWithType:(UIButtonType)type fontSize:(NSInteger)fontSize text:(NSString*)text;

/**
 *  使用iconfont的UILabel,text首页到映射表中查询，未找到则使用原始值
 *
 *  @param frame    label的frame
 *  @param fontSize iconfont字体大小
 *  @param text     iconfont编码，或者映射值：http://yunpan.taobao.com/share/link/D5FoiG4ZE
 *
 *  @return 使用iconfont的UILabel
 */
+ (UILabel*)iconFontLabelWithFrame:(CGRect)frame fontSize:(NSInteger)fontSize text:(NSString*)text;

/**
 *  根据映射表的中名称获取对应的iconfont的unicode编码
 *
 *  @param name 可以理解的名称
 *
 *  @return unicode编码
 */
+ (NSString*)iconFontUnicodeWithName:(NSString*)name;


+ (NSDictionary*)iconfontMapDict;

@end

NS_ASSUME_NONNULL_END
