//
//  DownloadManager.h
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

<<<<<<< HEAD
#import <Foundation/Foundation.h>
#import "DataDownload.h"

@protocol DownloadTasksDelegate <NSObject>

-(void) progressDownload: (double) progress
              identifier: (int16_t) identifier
         totalDownloaded: (NSString*) totalString;
-(void) complateDownloadInURL:(NSURL*) url identifier: (int16_t) identifier;

@end

=======
>>>>>>> Beta

#import <Foundation/Foundation.h>
#import "DataDownload.h"
#import "TaskWithBlocks.h"

@interface DownloadManager : NSObject <NSURLSessionDownloadDelegate>

@property (nonatomic,strong) NSURLSession* defaultSession;
<<<<<<< HEAD
@property (nonatomic,weak) id <DownloadTasksDelegate> delegate;

+(DownloadManager*) sharedManagerWithDelegate: (id <DownloadTasksDelegate>) delegate;
-(NSURLSessionDownloadTask*) downloadWithURL: (NSString*) urlString;
=======
@property (nonatomic,strong) NSMutableDictionary* dictOfDownloadTask;


+(DownloadManager*) sharedManager;

-(NSURLSessionDownloadTask*) downloadWithURL: (NSString*) urlString
                            progressDownload: (ProgressBlock) progressBlock
                               complateBlock: (ComplateBlock)complateBlock
                                  errorBlock: (ErrorBlock) errorBlock;
>>>>>>> Beta

@end
