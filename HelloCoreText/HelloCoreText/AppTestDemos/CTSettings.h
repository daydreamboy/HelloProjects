//
//  CTSettings.h
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CTSettings : NSObject
@property (nonatomic, assign, readonly) CGFloat margin;
@property (nonatomic, assign, readonly) NSInteger columnPerPage;
@property (nonatomic, assign, readonly) CGRect pageRect;
@property (nonatomic, assign, readonly) CGRect columnRect;
@end
