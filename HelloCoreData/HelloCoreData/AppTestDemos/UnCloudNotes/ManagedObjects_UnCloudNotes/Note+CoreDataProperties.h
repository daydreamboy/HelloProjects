//
//  Note+CoreDataProperties.h
//  HelloCoreData
//
//  Created by wesley_chen on 11/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//
//

#import "Note+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *body;
@property (nullable, nonatomic, copy) NSDate *dateCreated;
@property (nonatomic) int64_t displayIndex;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) UIImage *image;

@end

NS_ASSUME_NONNULL_END
