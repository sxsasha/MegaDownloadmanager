//
//  CoreDataManager.h
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataDownload.h"

@interface CoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

+(CoreDataManager*) sharedManager;
-(DataDownload*) addDataDownload;
-(void) deleteAll;
-(void) deleteDataDownload: (DataDownload*) dataDownload;
-(NSArray*) getAllDataDownloads;
-(BOOL) save: (NSError**) errorWithSave;


@end
