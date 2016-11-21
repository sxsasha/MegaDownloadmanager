//
//  DownloadManager.m
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//
#import "DownloadManager.h"


#define maxConcurentDownload 10



@implementation DownloadManager

+(DownloadManager*) sharedManagerWithDelegate;//: (id <DownloadTasksDelegate>) delegate
{
    static DownloadManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadManager alloc]init];
        manager.dictOfDownloadTask = [NSMutableDictionary dictionary];
        
        NSOperationQueue* ourQueue = [[NSOperationQueue alloc]init];
        ourQueue.maxConcurrentOperationCount = maxConcurentDownload;
        
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                               delegate:manager
                                                          delegateQueue:ourQueue];
        //manager.delegate = delegate;
    });
    
    return manager;
}

-(NSURLSessionDownloadTask*) downloadWithURL: (NSString*) urlString
                                dataDownload: (DataDownload*) dataDownload
                            progressDownload: (ProgressBlock) progressBlock
                               complateBlock: (ComplateBlock)complateBlock
                                  errorBlock: (ErrorBlock) errorBlock
{
    NSURL* url = [NSURL URLWithString:urlString];
    if (url)
    {
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
        NSURLSessionDownloadTask* sessionTask = [self.defaultSession downloadTaskWithRequest:request];
        
        DownloadTaskBlock* downloadTaskBlock = [[DownloadTaskBlock alloc] init];
        downloadTaskBlock.dataDownload = dataDownload;
        downloadTaskBlock.progressBlock = progressBlock;
        downloadTaskBlock.complateBlock = complateBlock;
        downloadTaskBlock.errorBlock = errorBlock;
        downloadTaskBlock.downloadTask = sessionTask;
        [self.dictOfDownloadTask setObject:downloadTaskBlock forKey:@(sessionTask.taskIdentifier)];
        
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
    
    DownloadTaskBlock* downloadTaskBlock = self.dictOfDownloadTask[@(downloadTask.taskIdentifier)];
    downloadTaskBlock.progressBlock(progress,(int)downloadTask.taskIdentifier,size);
//    [self.delegate progressDownload:progress
//                         identifier:downloadTask.taskIdentifier
//                    totalDownloaded:size];
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    DownloadTaskBlock* downloadTaskBlock = self.dictOfDownloadTask[@(downloadTask.taskIdentifier)];
    downloadTaskBlock.complateBlock((int)downloadTask.taskIdentifier,location);
  //  [self.delegate complateDownloadInURL:location
    //                           identifier:(int16_t)downloadTask.taskIdentifier];
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
        i = [array count] - 1;
    }
    return [NSString stringWithFormat:@"%lld%@",((long long  int)xBytes),[array objectAtIndex:i] ];
}

@end
