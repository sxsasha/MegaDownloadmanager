//
//  DownloadManager.h
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDownload.h"

@protocol DownloadTasksDelegate <NSObject>

-(void) progressDownload: (double) progress
              identifier: (int16_t) identifier
         totalDownloaded: (NSString*) totalString;
-(void) complateDownloadInURL:(NSURL*) url identifier: (int16_t) identifier;

@end



@interface DownloadManager : NSObject <NSURLSessionDownloadDelegate>

@property (nonatomic,strong) NSURLSession* defaultSession;
@property (nonatomic,weak) id <DownloadTasksDelegate> delegate;

+(DownloadManager*) sharedManagerWithDelegate: (id <DownloadTasksDelegate>) delegate;
-(NSURLSessionDownloadTask*) downloadWithURL: (NSString*) urlString;

@end
