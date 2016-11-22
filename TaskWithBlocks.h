//
//  TaskWithBlocks.h
//  MegaDownloadManager
//
//  Created by admin on 22.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ProgressBlock)(double, int, NSString*);
typedef void (^ComplateBlock)(int, NSURL*);
typedef void (^ErrorBlock)(NSError*);

@class DataDownload;

@interface TaskWithBlocks : NSObject

@property (nonatomic, copy) ProgressBlock progressBlock;
@property (nonatomic, copy) ComplateBlock complateBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@property (nonatomic, weak) NSURLSessionDownloadTask* downloadTask;

@end
