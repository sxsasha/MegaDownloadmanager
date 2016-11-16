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
        ourQueue.qualityOfService = NSQualityOfServiceUserInitiated;
        
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                               delegate:manager
                                                          delegateQueue:ourQueue];
        manager.delegate = delegate;
        manager.arrayOfDataTask = [NSMutableArray array];
    });
    
    return manager;
}

-(NSURLSessionDownloadTask*) downloadWithURL: (NSString*) urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    if (url)
    {
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.f];
        NSURLSessionDownloadTask* sessionTask = [self.defaultSession downloadTaskWithRequest:request];
        sessionTask.taskDescription = urlString;
        [self.arrayOfDataTask addObject:sessionTask];
        [sessionTask resume];
        return sessionTask;
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
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSString* downloaded = [self getReadableFormat:totalBytesWritten];
    NSString* expectedSize = [self getReadableFormat:totalBytesExpectedToWrite];
    NSString* size = [NSString stringWithFormat:@"%@/%@",downloaded,expectedSize];
    
    [self.delegate progressDownload:progress
                         identifier:(int16_t)downloadTask.taskIdentifier
                    totalDownloaded:size];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    [self.delegate complateDownloadInURL:location
                              identifier:(int16_t)downloadTask.taskIdentifier];
}

#pragma mark - Help methods

- (NSString*) getReadableFormat:(int64_t) bytes
{
    NSArray* array = @[@"b",@"kb",@"mb",@"gb",@"tb"];
    int64_t xBytes = bytes;
    int i = 0;
    while (xBytes < 1024)
    {
        xBytes = xBytes / 1024;
        i = i + 1;
    }
    return [NSString stringWithFormat:@"%lld%@",((long long  int)xBytes),[array objectAtIndex:i] ];
}

@end
