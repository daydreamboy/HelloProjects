//
//  CTViewV5.h
//  HelloCoreText
//
//  Created by wesley_chen on 14/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTViewV5 : UIScrollView
- (void)buildFramesWithAttrString:(NSAttributedString *)attrString images:(NSArray<NSDictionary<NSString *, id> *> *)images;
@end
