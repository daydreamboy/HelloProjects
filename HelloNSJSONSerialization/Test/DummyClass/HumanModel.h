//
//  HumanModel.h
//  Test
//
//  Created by wesley_chen on 2020/3/17.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FingerModel : NSObject
@property (nonatomic, copy) NSString *name;
- (instancetype)initWithName:(NSString *)name;
@end

@interface HandModel : NSObject

@property (nonatomic, strong) FingerModel *thumb;
@property (nonatomic, strong) FingerModel *indexFinger;
@property (nonatomic, strong) FingerModel *middleFinger;
@property (nonatomic, strong) FingerModel *ringFinger;
@property (nonatomic, strong) FingerModel *pinky;

@end

@interface HumanModel : NSObject

@property (nonatomic, strong) HandModel *leftHand;
@property (nonatomic, strong) HandModel *rightHand;
@property (nonatomic, strong) NSDictionary *map;
@property (nonatomic, strong) NSDictionary *mapHands;

+ (instancetype)createHuman;

@end

NS_ASSUME_NONNULL_END
