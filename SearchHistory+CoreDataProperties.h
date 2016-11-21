//
//  SearchHistory+CoreDataProperties.h
//  MegaDownloadManager
//
//  Created by admin on 16.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "SearchHistory.h"


NS_ASSUME_NONNULL_BEGIN

@interface SearchHistory (CoreDataProperties)

+ (NSFetchRequest<SearchHistory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *searchString;
@property (nonatomic) int16_t getCount;
@property (nullable, nonatomic, copy) NSDate *time;

@end

NS_ASSUME_NONNULL_END
