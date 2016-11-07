//
//  DownloadManager.m
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DownloadManager.h"

#define maxConcurentDownload 15

@implementation DownloadManager

+(DownloadManager*) sharedManagerWithDelegate: (id <DownloadTasksDelegate>) delegate
{
    static DownloadManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadManager alloc]init];
        NSOperationQueue* ourQueue = [[NSOperationQueue alloc]init];
        ourQueue.maxConcurrentOperationCount = maxConcurentDownload;
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                               delegate:manager
                                                          delegateQueue:ourQueue];
        manager.delegate = delegate;
        manager.arrayOfDataTask = [NSMutableArray array];
    });
    
    return manager;
}

-(NSUInteger) downloadFromURL:(NSString*) urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    if (url)
    {
        NSURLSessionDownloadTask* sessionTask = [self.defaultSession downloadTaskWithURL:url];
        sessionTask.taskDescription = urlString;
        [self.arrayOfDataTask addObject:sessionTask];
        [sessionTask resume];
        return sessionTask.taskIdentifier;
    }
    return 0;
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self.delegate progressDownload:((double)totalBytesWritten / (double)totalBytesExpectedToWrite) taskIdentifier:
     downloadTask.taskIdentifier];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    [self.delegate complateDownloadInURL:location taskIdentifier:downloadTask.taskIdentifier];
}

@end
