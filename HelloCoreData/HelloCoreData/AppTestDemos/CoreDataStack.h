//
//  CoreDataStack.h
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/**
 CoreData Stack contains four components:
 - NSManagedObjectModel (representation for .momd folder)
 - NSManagedObjectContext (the scratch pad for operating NSManagedObject)
 - NSPersistentStore (the store layer, usually backend is a SQLite database, controlled by NSPersistentStoreCoordinator)
 - NSPersistentStoreCoordinator (the bridge for NSManagedObjectModel and NSPersistentStore, which is holded by NSManageObjectContext)
 */
@interface CoreDataStack : NSObject
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
- (instancetype)initWithModelName:(NSString *)modelName;
- (instancetype)initWithModelName:(NSString *)modelName databaseURL:(NSURL *)databaseURL;
- (void)saveContext;
@end
