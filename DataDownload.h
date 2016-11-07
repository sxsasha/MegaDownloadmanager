//
//  DataDownload.h
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDownload : NSObject

@property (nonatomic,strong) NSString* name;
@property (nonatomic,assign) NSUInteger identifier;
@property (nonatomic,strong) NSString* urlString;
@property (nonatomic,strong) NSURL* localURL;
@property (nonatomic,assign) double progress;
@property (nonatomic,assign) BOOL isComplate;

@end
