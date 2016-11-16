//
//  SearchHistory+CoreDataProperties.m
//  MegaDownloadManager
//
//  Created by admin on 16.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "SearchHistory+CoreDataProperties.h"

@implementation SearchHistory (CoreDataProperties)

+ (NSFetchRequest<SearchHistory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SearchHistory"];
}

@dynamic searchString;
@dynamic getCount;
@dynamic time;

@end
