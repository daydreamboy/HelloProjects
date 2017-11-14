//
//  CTViewV4.h
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTViewV4 : UIScrollView
- (void)buildFramesWithAttrString:(NSAttributedString *)attrString images:(NSDictionary<NSString *, id> *)images;
@end
