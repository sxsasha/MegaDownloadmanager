//
//  DataDownloadCoreData+CoreDataProperties.m
//  MegaDownloadManager
//
<<<<<<< HEAD
//  Created by admin on 15.11.16.
=======
//  Created by admin on 23.11.16.
>>>>>>> Beta
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownloadCoreData+CoreDataProperties.h"

@implementation DataDownloadCoreData (CoreDataProperties)

+ (NSFetchRequest<DataDownloadCoreData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DataDownload"];
}

@dynamic isComplate;
<<<<<<< HEAD
@dynamic localURL;
@dynamic name;
@dynamic urlString;
=======
@dynamic name;
@dynamic urlString;
@dynamic localName;
>>>>>>> Beta

@end
