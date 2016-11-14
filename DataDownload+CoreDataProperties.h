//
//  DataDownload+CoreDataProperties.h
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownload.h"


NS_ASSUME_NONNULL_BEGIN

@interface DataDownload (CoreDataProperties)

+ (NSFetchRequest<DataDownload *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t identifier; // NSUInteger
@property (nullable, nonatomic, copy) NSString *urlString;
@property (nullable, nonatomic, copy) NSString *localURL; //NSURL
@property (nonatomic) double progress;
@property (nonatomic) BOOL isComplate;

@end

NS_ASSUME_NONNULL_END
