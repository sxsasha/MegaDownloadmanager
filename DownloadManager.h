//
//  DownloadManager.h
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DataDownload.h"
#import "TaskWithBlocks.h"

@interface DownloadManager : NSObject <NSURLSessionDownloadDelegate>

@property (nonatomic,strong) NSURLSession* defaultSession;
@property (nonatomic,strong) NSMutableDictionary* dictOfDownloadTask;


+(DownloadManager*) sharedManager;

-(NSURLSessionDownloadTask*) downloadWithURL: (NSString*) urlString
                            progressDownload: (ProgressBlock) progressBlock
                               complateBlock: (ComplateBlock)complateBlock
                                  errorBlock: (ErrorBlock) errorBlock;

@end
