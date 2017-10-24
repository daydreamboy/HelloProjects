//
//  CoreDataStack.m
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "CoreDataStack.h"

@interface CoreDataStack ()
@property (nonatomic, strong) NSURL *applicationDocumentsDirectory;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, copy) NSString *modelName;
@property (nonatomic, strong) NSURL *databaseURL;
@end

@implementation CoreDataStack

- (instancetype)initWithModelName:(NSString *)modelName {
    self = [super init];
    if (self) {
        _modelName = modelName;
    }
    return self;
}

- (instancetype)initWithModelName:(NSString *)modelName databaseURL:(NSURL *)databaseURL {
    self = [super init];
    if (self) {
        _modelName = modelName;
        _databaseURL = databaseURL;
    }
    return self;
}

#pragma mark - Public Methods

- (void)saveContext {
    [self.context performBlockAndWait:^{
        if ([self.context hasChanges]) {
            @try {
                NSError *error = nil;
                [self.context save:&error];
                if (error) {
                    NSLog(@"save error: %@", error);
                }
            }
            @catch (NSException *exception) {
                NSLog(@"exception error: %@", exception);
                abort();
            }
            @finally {
                
            }
        }
    }];
}

#pragma mark - Getters

- (NSURL *)applicationDocumentsDirectory {
    if (!_applicationDocumentsDirectory) {
        NSArray<NSURL *> *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        _applicationDocumentsDirectory = urls[urls.count - 1];
    }
    
    return _applicationDocumentsDirectory;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
        // Note: create a NSManagedObjectContext and configure its @persistentStoreCoordinator
        // - NSMainQueueConcurrencyType
        // - NSPrivateQueueConcurrencyType
        // - NSConfinementConcurrencyType (deprecated iOS 9.0)
        NSManagedObjectContext *c = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        c.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _context = c;
    }
    
    return _context;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *url = self.databaseURL ?: [self.applicationDocumentsDirectory URLByAppendingPathComponent:self.modelName];
        
        @try {
            // Note: let CoreData merge different versions of a managed object model
            NSDictionary *opts = @{ NSMigratePersistentStoresAutomaticallyOption: @YES };
            NSError *error = nil;
            // Note: create NSPersistentStore and attach it to `coordinator`
            [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:opts error:&error];
            if (error) {
                NSLog(@"Error adding persistent store: %@", error);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception adding persistent store: %@", exception);
        }
        @finally {
            _persistentStoreCoordinator = coordinator;
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        // Note: create a NSManagedObjectModel with a momd path (ps. momd == ManagedObjectModel Directory)
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

@end
