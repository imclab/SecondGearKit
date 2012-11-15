//
//  SGManagedObject.h
//  SecondGearKit
//
//  Created by Justin Williams on 6/26/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface SGManagedObject : NSManagedObject

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSManagedObjectContext *)mainObjectContext;

+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)applicationCachesDirectory;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

- (void)save;
- (void)delete;

+ (NSString *)entityName;
+ (NSEntityDescription *)entity;
+ (NSEntityDescription *)entityWithContext:(NSManagedObjectContext *)context;

+ (void)resetPersistentStore;

@end
