//
//  WCScrollViewTool.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCScrollViewTool : NSObject

+ (BOOL)scrollToTopOfListWithTableView:(UITableView *)tableView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea;

+ (BOOL)scrollToBottomOfListWithTableView:(UITableView *)tableView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea;

+ (BOOL)scrollToBottomWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
