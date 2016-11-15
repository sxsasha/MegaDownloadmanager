//
//  DataDownload+CoreDataProperties.m
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownload+CoreDataProperties.h"

@implementation DataDownloadCoreData (CoreDataProperties)

+ (NSFetchRequest<DataDownloadCoreData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DataDownload"];
}

@dynamic name;
@dynamic localURL;
@dynamic isComplate;
@dynamic urlString;



@end
