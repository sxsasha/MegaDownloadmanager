//
//  DataDownload+CoreDataProperties.h
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownloadCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataDownloadCoreData (CoreDataProperties)

+ (NSFetchRequest<DataDownloadCoreData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *urlString;
@property (nullable, nonatomic, copy) NSString *localURL;
@property (nonatomic) BOOL isComplate;

@end

NS_ASSUME_NONNULL_END
