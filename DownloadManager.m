//
//  DownloadManager.m
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//
#import "DownloadManager.h"


#define maxConcurentDownload 10
<<<<<<< HEAD
=======

>>>>>>> Beta

@implementation DownloadManager

+(DownloadManager*) sharedManager;
{
    static DownloadManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadManager alloc]init];
        manager.dictOfDownloadTask = [NSMutableDictionary dictionary];
        
        NSOperationQueue* ourQueue = [[NSOperationQueue alloc]init];
        ourQueue.maxConcurrentOperationCount = maxConcurentDownload;
        
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 0;
        sessionConfig.timeoutIntervalForResource = 0;
        sessionConfig.allowsCellularAccess = YES;
        
        manager.defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                               delegate:manager
                                                          delegateQueue:ourQueue];
<<<<<<< HEAD
        manager.delegate = delegate;
=======
>>>>>>> Beta
    });
    
    return manager;
}

-(NSURLSessionDownloadTask*) downloadWithURL: (NSString*) urlString
<<<<<<< HEAD
=======
                            progressDownload: (ProgressBlock) progressBlock
                               complateBlock: (ComplateBlock)complateBlock
                                  errorBlock: (ErrorBlock) errorBlock
>>>>>>> Beta
{
    NSURL* url = [NSURL URLWithString:urlString];
    if (url)
    {
<<<<<<< HEAD
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
        NSURLSessionDownloadTask* sessionTask = [self.defaultSession downloadTaskWithRequest:request];
=======
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask* sessionTask = [self.defaultSession downloadTaskWithRequest:request];
        
        TaskWithBlocks* downloadTaskBlock = [[TaskWithBlocks alloc]init];
        downloadTaskBlock.progressBlock = progressBlock;
        downloadTaskBlock.complateBlock = complateBlock;
        downloadTaskBlock.errorBlock = errorBlock;
        downloadTaskBlock.downloadTask = sessionTask;
        [self.dictOfDownloadTask setObject:downloadTaskBlock forKey:@(sessionTask.taskIdentifier)];
        
>>>>>>> Beta
        sessionTask.taskDescription = urlString;
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
    
<<<<<<< HEAD
    [self.delegate progressDownload:progress
                         identifier:(int16_t)downloadTask.taskIdentifier
                    totalDownloaded:size];
=======
    TaskWithBlocks* downloadTaskBlock = self.dictOfDownloadTask[@(downloadTask.taskIdentifier)];
    downloadTaskBlock.progressBlock(progress,(int)downloadTask.taskIdentifier,size);
>>>>>>> Beta
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
<<<<<<< HEAD
    [self.delegate complateDownloadInURL:location
                              identifier:(int16_t)downloadTask.taskIdentifier];
=======
   TaskWithBlocks* downloadTaskBlock = self.dictOfDownloadTask[@(downloadTask.taskIdentifier)];
    downloadTaskBlock.complateBlock((int)downloadTask.taskIdentifier,location);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    TaskWithBlocks* downloadTaskBlock = self.dictOfDownloadTask[@(task.taskIdentifier)];
    if (error)
    {
        downloadTaskBlock.errorBlock(error);
    }
    
    [self.dictOfDownloadTask removeObjectForKey:@(task.taskIdentifier)];
>>>>>>> Beta
}

#pragma mark - Help methods

- (NSString*) getReadableFormat:(int64_t) bytes
{
    NSArray* array = @[@"b",@"kb",@"mb",@"gb",@"tb",@"pb"];
    int64_t xBytes = bytes;
    int i = 0;
    while (xBytes > 1024)
    {
        xBytes = xBytes / 1024;
        i = i + 1;
    }
    
    if (i >= [array count])
    {
<<<<<<< HEAD
        i = [array count] - 1;
=======
        i = (int)[array count] - 1;
>>>>>>> Beta
    }
    return [NSString stringWithFormat:@"%lld%@",((long long  int)xBytes),[array objectAtIndex:i] ];
}

@end
