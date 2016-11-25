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
#import "DownloadCell.h"


@interface DataDownload : NSObject

@property (nonatomic,   strong) NSString *name;
@property (nonatomic,   strong) NSString *localName;
@property (nonatomic,   assign) int16_t identifier;
@property (nonatomic,   strong) NSString *urlString;
@property (nonatomic,   strong) NSString *localURL;
@property (nonatomic,   assign) double progress;
@property (nonatomic,   strong) NSString* downloaded;
@property (nonatomic,   assign) BOOL isComplate;
@property (nonatomic,   assign) BOOL isDownloading;
@property (nonatomic,   assign) BOOL isPause;

@property (nonatomic,   strong) DataDownloadCoreData* dataDownloadCoreData;
@property (nonatomic,   strong) CoreDataManager* coreDataManager;
@property (nonatomic,   weak) NSURLSessionDownloadTask* downloadTask;

@property (nonatomic,   weak) DownloadCell* cell;
@property (nonatomic,   assign) UITableViewCellAccessoryType cellAccessoryType;

+(NSArray*) getAllDataDownloadFromaDatabase;
- (void) removeFromDatabase;

@end
