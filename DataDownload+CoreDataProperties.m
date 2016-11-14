//
//  DataDownload+CoreDataProperties.m
//  MegaDownloadManager
//
//  Created by admin on 14.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownload+CoreDataProperties.h"

@implementation DataDownload (CoreDataProperties)

+ (NSFetchRequest<DataDownload *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"DataDownload"];
}

@dynamic name;
@dynamic identifier;
@dynamic urlString;
@dynamic localURL;
@dynamic progress;
@dynamic isComplate;

- (void) setUrlString:(NSString *)urlString
{
    self.name = [[urlString lastPathComponent] stringByRemovingPercentEncoding];
    
    
    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    self.localURL = [documentsURL URLByAppendingPathComponent:self.name].absoluteString;
    
    [self willChangeValueForKey:@"urlString"];
    [self setPrimitiveValue:urlString forKey:@"urlString"];
    [self didChangeValueForKey:@"urlString"];
}

@end
