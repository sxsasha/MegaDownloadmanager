//
//  DataDownload.m
//  MegaDownloadManager
//
//  Created by admin on 15.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DataDownload.h"

@implementation DataDownload

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.coreDataManager = [CoreDataManager sharedManager];
        self.dataDownloadCoreData = [self.coreDataManager addDataDownload];
    }
    return self;
}

- (instancetype)initWithDataDownload: (DataDownloadCoreData*) dataDownload
{
    self = [super init];
    if (self)
    {
        self.coreDataManager = [CoreDataManager sharedManager];
        self.dataDownloadCoreData = dataDownload;
    }
    return self;
}

- (void)dealloc
{

}

#pragma mark - Setters & Getters
- (void) setUrlString:(NSString *)urlString
{
    //gen name, replace space with _
    NSString* name = [[urlString lastPathComponent] stringByRemovingPercentEncoding];
    
    NSRange extension = NSMakeRange([name length] - 3, 3);
    if (![[name substringWithRange:extension] isEqualToString:@"pdf"])
    {
        name = [name stringByAppendingString:@".pdf"];
    }
    
    NSArray* isHaveSpace = [name componentsSeparatedByString:@" "];
    self.name = [isHaveSpace componentsJoinedByString:@"_"];

    //create localURL (where save)
    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    self.localURL = [documentsURL URLByAppendingPathComponent:self.name].absoluteString;

    _urlString = urlString;
    self.dataDownloadCoreData.urlString = urlString;
    
    [self.coreDataManager save:nil];
}

- (void) setIsComplate:(BOOL)isComplate
{
    _isComplate = isComplate;
    
    if ((isComplate)&&(![self.dataDownloadCoreData.isComplate boolValue]))
    {
        self.dataDownloadCoreData.isComplate = @(_isComplate);
        [self.coreDataManager save:nil];
    }
}

- (void) setName:(NSString *)name
{
    _name = name;
    self.dataDownloadCoreData.name = name;
}

- (void) setLocalURL:(NSString *)localURL
{
    _localURL =localURL;
    self.dataDownloadCoreData.localURL = localURL;
}

#pragma mark - Help Methods

+(NSArray*) getAllDataDownloadFromaDatabase
{
    NSArray <DataDownloadCoreData*>* dataDownloadsFromDatabase = [[CoreDataManager sharedManager] getAllDataDownloads];
    
    NSMutableArray* array = [NSMutableArray array];
    for (DataDownloadCoreData* obj in dataDownloadsFromDatabase)
    {
        DataDownload* dataDownload = [[DataDownload alloc] initWithDataDownload:obj];
        dataDownload.urlString = obj.urlString;
        dataDownload.isComplate = [obj.isComplate boolValue];

        [array addObject:dataDownload];
    }
    return array;
}

- (void) removeFromDatabase
{
    [self.coreDataManager deleteEntity:self.dataDownloadCoreData];
    NSURL* localURL = [NSURL URLWithString:self.localURL];
    [[NSFileManager defaultManager] removeItemAtURL:localURL error:nil];
    self.dataDownloadCoreData = nil;
    
    [self.coreDataManager save:nil];
}

@end
