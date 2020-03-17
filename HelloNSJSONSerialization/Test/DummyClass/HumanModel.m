//
//  HumanModel.m
//  Test
//
//  Created by wesley_chen on 2020/3/17.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "HumanModel.h"

@implementation FingerModel
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}
@end

@implementation HandModel

@end

@implementation HumanModel

+ (instancetype)createHuman {
    FingerModel *leftHandFinger1 = [[FingerModel alloc] initWithName:@"thumb"];
    FingerModel *leftHandFinger2 = [[FingerModel alloc] initWithName:@"index"];
    FingerModel *leftHandFinger3 = [[FingerModel alloc] initWithName:@"middle"];
    FingerModel *leftHandFinger4 = [[FingerModel alloc] initWithName:@"ring"];
    FingerModel *leftHandFinger5 = [[FingerModel alloc] initWithName:@"pinky"];
    
    FingerModel *rightHandFinger1 = [[FingerModel alloc] initWithName:@"thumb"];
    FingerModel *rightHandFinger2 = [[FingerModel alloc] initWithName:@"index"];
    FingerModel *rightHandFinger3 = [[FingerModel alloc] initWithName:@"middle"];
    FingerModel *rightHandFinger4 = [[FingerModel alloc] initWithName:@"ring"];
    FingerModel *rightHandFinger5 = [[FingerModel alloc] initWithName:@"pinky"];
    
    HandModel *leftHand = [HandModel new];
    leftHand.thumb = leftHandFinger1;
    leftHand.indexFinger = leftHandFinger2;
    leftHand.middleFinger = leftHandFinger3;
    leftHand.ringFinger = leftHandFinger4;
    leftHand.pinky = leftHandFinger5;
    
    HandModel *rightHand = [HandModel new];
    rightHand.thumb = rightHandFinger1;
    rightHand.indexFinger = rightHandFinger2;
    rightHand.middleFinger = rightHandFinger3;
    rightHand.ringFinger = rightHandFinger4;
    rightHand.pinky = rightHandFinger5;
    
    HumanModel *model = [HumanModel new];
    model.leftHand = leftHand;
    model.rightHand = rightHand;
    model.map = @{
        @"1": @"a",
        @"2": @"b",
        @"3": @"c",
    };
    model.mapHands = @{
        @"leftHand": leftHand,
        @"rightHand": rightHand,
    };
    
    return model;
}

@end
