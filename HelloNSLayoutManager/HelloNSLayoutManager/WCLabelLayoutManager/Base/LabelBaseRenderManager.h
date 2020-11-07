//
//  LabelBaseRenderManager.h
//  HelloNSLayoutManager
//
//  Created by wesley_chen on 2020/11/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelBaseRenderManager : NSObject

@property (nonatomic, strong, readonly) NSLayoutManager *layoutManager;
@property (nonatomic, strong, readonly) NSTextStorage *textStorage;
@property (nonatomic, strong, readonly) NSTextContainer *textContainer;

- (instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString;
- (instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString layoutManager:(NSLayoutManager *)layoutManager;

- (void)setAttributedString:(NSAttributedString *)attributedString;
- (void)configureTextContainerSizeWithLabel:(UILabel *)label;
- (void)drawGlyphs;

@end

NS_ASSUME_NONNULL_END
