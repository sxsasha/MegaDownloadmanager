//
//  DataDownload+CoreDataClass.h
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class DownloadCell;

@interface DataDownload : NSManagedObject

@property (strong ,nonatomic) DownloadCell* cell;
@property (assign ,nonatomic) int16_t identifier;
@property (assign, nonatomic) double progress;

@end

NS_ASSUME_NONNULL_END

#import "DataDownload+CoreDataProperties.h"
