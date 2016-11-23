//
//  DataDownloadCoreData+CoreDataProperties.h
//  MegaDownloadManager
//
<<<<<<< HEAD
//  Created by admin on 15.11.16.
=======
//  Created by admin on 23.11.16.
>>>>>>> Beta
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownloadCoreData.h"


NS_ASSUME_NONNULL_BEGIN

@interface DataDownloadCoreData (CoreDataProperties)

+ (NSFetchRequest<DataDownloadCoreData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *isComplate;
<<<<<<< HEAD
@property (nullable, nonatomic, copy) NSString *localURL;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *urlString;
=======
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *urlString;
@property (nullable, nonatomic, copy) NSString *localName;
>>>>>>> Beta

@end

NS_ASSUME_NONNULL_END
