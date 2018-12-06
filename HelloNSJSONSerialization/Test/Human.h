//
//  Human.h
//  Test
//
//  Created by wesley_chen on 2018/12/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Finger : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger index;
- (instancetype)initWithName:(NSString *)name index:(NSInteger)index;
@end

@interface Hand : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<Finger *> *fingers;
- (instancetype)initWithName:(NSString *)name;
@end

@interface Human : NSObject
@property (nonatomic, strong) NSArray<Hand *> *hands;
@end
