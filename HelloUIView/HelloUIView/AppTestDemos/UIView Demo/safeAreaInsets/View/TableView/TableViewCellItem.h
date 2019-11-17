//
//  TableViewCellItem.h
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef void(^Handler)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCellItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL switchable;
@property (nonatomic, assign) BOOL custom;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) Handler handler;

- (instancetype)initWithTitle:(NSString *)title enabled:(BOOL)enabled switchable:(BOOL)switchable custom:(BOOL)custom height:(CGFloat)height handler:(Handler)handler;

@end

NS_ASSUME_NONNULL_END
