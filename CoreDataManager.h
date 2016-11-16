//
//  CoreDataManager.h
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataDownloadCoreData.h"
#import "SearchHistory.h"

@interface CoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

+(CoreDataManager*) sharedManager;

-(DataDownloadCoreData*) addDataDownload;
-(NSArray*) getAllDataDownloads;
-(void) deleteAllDataDownload;

-(SearchHistory*) addSearchRequest: (NSString*) string count: (int16_t)count atTime: (NSDate*) date;
-(NSArray*) getAllSearchHistory;
-(void) deleteAllSearchHistory;

-(void) deleteEntity: (NSManagedObject*) object;
-(BOOL) save: (NSError**) errorWithSave;


@end
