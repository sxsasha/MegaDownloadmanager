//
//  CoreDataManager.m
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CoreDataManager.h"


#define documentURL [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]

@implementation CoreDataManager

+(CoreDataManager*) sharedManager
{
    static CoreDataManager* sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CoreDataManager alloc] init];
        [sharedManager managedObjectContext];
    });
    
    return sharedManager;
}

#pragma mark - Init Model, Coordinator and Context

- (NSManagedObjectModel*) managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model.momd" withExtension:@""];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
    if(_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *SQLURL = [documentURL URLByAppendingPathComponent:@"Download.sqlite"];
    
    NSError *errorWithCreateSQLStore = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSDictionary* options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),
                              NSInferMappingModelAutomaticallyOption: @(YES)};
    
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:SQLURL
                                                        options:options
                                                          error:&errorWithCreateSQLStore])
    {
        // trying to delete and repeate
        if([[NSFileManager defaultManager] removeItemAtURL:SQLURL error:&errorWithCreateSQLStore])
        {
             [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:SQLURL options:nil error:nil];
        }
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext*) managedObjectContext
{
    if(_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext;
}

#pragma mark - Work with Core Data Entity
#pragma mark -
#pragma mark -
#pragma mark - Work with Data Download
-(DataDownloadCoreData*) addDataDownload
{
    DataDownloadCoreData *newDownload = [NSEntityDescription insertNewObjectForEntityForName:@"DataDownload" inManagedObjectContext:self.managedObjectContext];
    
    return newDownload;
}

-(void) deleteAllDataDownload
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataDownload"];
    NSArray* allDataDownloads = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (NSManagedObject *managedObject in allDataDownloads)
    {
        [_managedObjectContext deleteObject:managedObject];
    }
}

-(NSArray*) getAllDataDownloads
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DataDownload"];
    
    fetchRequest.resultType = NSManagedObjectResultType;
    fetchRequest.includesSubentities = YES;
    fetchRequest.includesPropertyValues = YES;
    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSArray* allDataDownloads = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return allDataDownloads;
}

#pragma mark - Work with search history

-(SearchHistory*) addSearchRequest: (NSString*) string count: (int16_t)count atTime: (NSDate*) date
{
    SearchHistory *newSearchRequest = [NSEntityDescription insertNewObjectForEntityForName:@"SearchHistory" inManagedObjectContext:self.managedObjectContext];
    
    newSearchRequest.searchString = string;
    newSearchRequest.getCount = count;
    newSearchRequest.time = date;
    
<<<<<<< HEAD
    [self save:nil];
    
=======
>>>>>>> Beta
    return newSearchRequest;
}

-(NSArray*) getAllSearchHistory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SearchHistory"];
    
    fetchRequest.resultType = NSManagedObjectResultType;
    fetchRequest.includesSubentities = YES;
    fetchRequest.includesPropertyValues = YES;
    fetchRequest.returnsObjectsAsFaults = NO;
    
    NSArray* allDataDownloads = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return allDataDownloads;
}

-(void) deleteAllSearchHistory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SearchHistory"];
    NSArray* allDataDownloads = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (NSManagedObject *managedObject in allDataDownloads)
    {
        [_managedObjectContext deleteObject:managedObject];
    }
}

#pragma mark - main Methods

-(void) deleteEntity: (NSManagedObject*) object
{
    [self.managedObjectContext deleteObject:object];
}

- (BOOL) save: (NSError**) errorWithSave
{
    return  [self.managedObjectContext save:errorWithSave];
}

@end
