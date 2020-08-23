//
//  FontGlyphDetailInfoViewController.h
//  HelloUIFont
//
//  Created by wesley_chen on 2020/8/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCFontTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface FontGlyphDetailInfoViewController : UIViewController

- (instancetype)initWithGlyphInfo:(WCFontGlyphInfo *)glyphInfo;

@end

NS_ASSUME_NONNULL_END
