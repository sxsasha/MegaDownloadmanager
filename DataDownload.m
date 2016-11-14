//
//  DataDownload+CoreDataClass.m
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownload.h"

@implementation DataDownload


- (void) UrlStrings111:(NSString *) url
{
    self.name = [[url lastPathComponent] stringByRemovingPercentEncoding];
    
    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    self.localURL = [documentsURL URLByAppendingPathComponent:self.name].absoluteString;
    
    
    //    [self willChangeValueForKey:@"urlString"];
    //    [self setPrimitiveValue:urlString forKey:@"urlString"];
    //    [self didChangeValueForKey:@"urlString"];
}

@end
