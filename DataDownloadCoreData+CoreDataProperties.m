//
//  DataDownloadCoreData+CoreDataProperties.m
//  MegaDownloadManager
//
//  Created by admin on 15.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownloadCoreData+CoreDataProperties.h"

@implementation DataDownloadCoreData (CoreDataProperties)

+ (NSFetchRequest<DataDownloadCoreData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DataDownload"];
}

@dynamic isComplate;
@dynamic localURL;
@dynamic name;
@dynamic urlString;

@end
