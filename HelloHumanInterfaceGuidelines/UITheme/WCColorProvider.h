//
//  WCColorProvider.h
//  
//
//  Created by wesley chen on 2020/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WCColorProvider <NSObject>
@required
/**
 * @param identifier 主题标识
 * @param colorKey 对应主题下的色值key
 */
- (UIColor *)colorWithThemeIdentifier:(NSString *)identifier colorKey:(NSString *)colorKey;

@end

NS_ASSUME_NONNULL_END
