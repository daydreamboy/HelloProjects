//
//  Team+CoreDataProperties.h
//  HelloCoreData
//
//  Created by wesley_chen on 06/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Team+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Team (CoreDataProperties)

+ (NSFetchRequest<Team *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imageName;
@property (nonatomic) int32_t losses;
@property (nullable, nonatomic, copy) NSString *qualifyingZone;
@property (nullable, nonatomic, copy) NSString *teamName;
@property (nonatomic) int32_t wins;

@end

NS_ASSUME_NONNULL_END
