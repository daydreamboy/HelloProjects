//
//  WCLabel.h
//  HelloUILabel
//
//  Created by wesley_chen on 2020/11/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCLabel : UILabel
@property (nonatomic, copy) void (^linkTappedBlock)(NSString *linkString);
@end

NS_ASSUME_NONNULL_END
