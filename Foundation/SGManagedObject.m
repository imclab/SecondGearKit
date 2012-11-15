//
//  SGManagedObject.m
//  SecondGearKit
//
//  Created by Justin Williams on 6/26/12.
//  Copyright (c) 2012 Second Gear. All rights reserved.
//

#import "SGManagedObject.h"

static NSManagedObjectModel *_sManagedObjectModel = nil;
static NSManagedObjectContext *_sMainObjectContext = nil;
static NSURL *_sPersistentStoreURL = nil;
static NSDictionary *_sPersistentStoreOptions = nil;

@interface SGManagedObject ()
+ (NSDictionary *)persistentStoreOptions;
+ (NSURL *)persistentStoreURL;
@end

@implementation SGManagedObject

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    static NSPersistentStoreCoordinator *sPersistentStoreCoordinator = nil;

    if (sPersistentStoreCoordinator != nil)
	{
		return sPersistentStoreCoordinator;
	}
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Bring this sumbitch up.
        sPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSError *addPersistentStoreError = nil;
        BOOL successfullyAddedPSC = ([sPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:&addPersistentStoreError] != nil);
        if (successfullyAddedPSC == NO)
        {
            NSLog(@"Error adding persistent store coordinator: %@, %@", addPersistentStoreError, [addPersistentStoreError userInfo]);
        }

    });
    
	return sPersistentStoreCoordinator;
}

+ (NSManagedObjectModel *)managedObjectModel
{
	if (_sManagedObjectModel != nil)
	{
		return _sManagedObjectModel;
	}
    
    NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = applicationInfo[@"CFBundleName"];
    NSString *path = [[NSBundle mainBundle] pathForResource:appName ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    _sManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
		
	return _sManagedObjectModel;
}

+ (NSManagedObjectContext *)mainObjectContext
{
    if (_sMainObjectContext != nil)
	{
        return _sMainObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _sMainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _sMainObjectContext.persistentStoreCoordinator = coordinator;
    }
	
	NSAssert(dispatch_get_current_queue() == dispatch_get_main_queue(), @"Unsafe access of managed object context from non-main thread");

    return _sMainObjectContext;
}

+ (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)applicationCachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Initializer Methods
// +--------------------------------------------------------------------
// | Initializer Methods
// +--------------------------------------------------------------------

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
	if (context == nil)
	{
		context = [SGManagedObject mainObjectContext];
	}
	
	NSEntityDescription *entity = [[self class] entityWithContext:context];
	
	return (self = [self initWithEntity:entity insertIntoManagedObjectContext:context]);
}

#pragma mark -
#pragma mark Instance Methods
// +--------------------------------------------------------------------
// | Instance Methods
// +--------------------------------------------------------------------

- (void)save
{
    [self.managedObjectContext save:nil];
}

- (void)delete
{
    [self.managedObjectContext deleteObject:self];
}

+ (NSString *)entityName
{
	return NSStringFromClass([self class]);
}

+ (NSEntityDescription *)entity
{
	return [self entityWithContext:nil];
}

+ (NSEntityDescription *)entityWithContext:(NSManagedObjectContext *)context
{
	if (context == nil)
	{
		context = [self mainObjectContext];
	}
	
	return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
}

#pragma mark -
#pragma mark Private/Convenience Methods
// +--------------------------------------------------------------------
// | Private/Convenience Methods
// +--------------------------------------------------------------------

+ (NSDictionary *)persistentStoreOptions
{
    if (_sPersistentStoreOptions != nil)
    {
        return _sPersistentStoreOptions;
    }
    
    _sPersistentStoreOptions = @{
    NSMigratePersistentStoresAutomaticallyOption : @YES,
    NSInferMappingModelAutomaticallyOption : @YES
    };
    
    return _sPersistentStoreOptions;
}

+ (NSURL *)persistentStoreURL
{
    if (_sPersistentStoreURL != nil)
    {
        return _sPersistentStoreURL;
    }
    
    NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = applicationInfo[@"CFBundleName"];

#if TARGET_OS_IPHONE
    NSString *cachesDirectoryStorePath = [[self applicationCachesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", appName]];
    _sPersistentStoreURL = [NSURL fileURLWithPath:cachesDirectoryStorePath];
#else
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    applicationSupportURL = [applicationSupportURL URLByAppendingPathComponent:appName];
    
    NSDictionary *properties = [applicationSupportURL resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:nil];
    if (properties == nil)
    {
        [fileManager createDirectoryAtPath:[applicationSupportURL path] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    _sPersistentStoreURL = [applicationSupportURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", appName]];

#endif

    
    return _sPersistentStoreURL;
}

+ (void)resetPersistentStore
{
	_sMainObjectContext = nil;
	NSURL *url = [self persistentStoreURL];
	NSPersistentStoreCoordinator *psc = [SGManagedObject persistentStoreCoordinator];
	if ([psc removePersistentStore:psc.persistentStores.lastObject error:nil])
    {
		[[NSFileManager defaultManager] removeItemAtURL:url error:nil];
		[psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:[SGManagedObject persistentStoreOptions] error:nil];
	}
}


@end
