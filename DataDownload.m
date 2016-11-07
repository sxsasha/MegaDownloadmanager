//
//  DataDownload.m
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownload.h"

@implementation DataDownload

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.isComplate = NO;
        self.progress = 0.f;
    }
    return self;
}

- (void) setUrlString:(NSString *)urlString
{
    self.name = [[urlString lastPathComponent] stringByRemovingPercentEncoding];
    
    
    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    self.localURL = [documentsURL URLByAppendingPathComponent:self.name];
    _urlString = urlString;
}
@end
