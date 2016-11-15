//
//  DataDownloadCoreData+CoreDataProperties.h
//  MegaDownloadManager
//
//  Created by admin on 15.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownloadCoreData.h"


NS_ASSUME_NONNULL_BEGIN

@interface DataDownloadCoreData (CoreDataProperties)

+ (NSFetchRequest<DataDownloadCoreData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *isComplate;
@property (nullable, nonatomic, copy) NSString *localURL;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *urlString;

@end

NS_ASSUME_NONNULL_END
