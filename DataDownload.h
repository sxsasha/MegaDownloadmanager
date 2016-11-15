//
//  DataDownload.h
//  MegaDownloadManager
//
//  Created by admin on 15.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDownloadCoreData.h"
#import "CoreDataManager.h"

@class DownloadCell;

@interface DataDownload : NSObject

@property (nonatomic,   strong) NSString *name;
@property (nonatomic,   assign) int16_t identifier;
@property (nonatomic,   strong) NSString *urlString;
@property (nonatomic,   strong) NSString *localURL;
@property (nonatomic,   assign) double progress;
@property (nonatomic,   assign) BOOL isComplate;

@property (nonatomic,   strong) DownloadCell* cell;
@property (nonatomic,   strong) DataDownloadCoreData* dataDownloadCoreData;
@property (nonatomic,   strong) CoreDataManager* coreDataManager;

+(NSArray*) getAllDataDownloadFromaDatabase;

@end
