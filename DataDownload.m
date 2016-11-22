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
        self.name = dataDownload.name;
        self.urlString = dataDownload.urlString;
        
        if ([self checkIfWeHaveSomeFile:self.name])
        {
            self.isComplate = YES;
            self.progress = 1.f;
        }
    }
    return self;
}

- (void)dealloc
{

}

#pragma mark - Setters & Getters
- (void) setUrlString:(NSString *)urlString
{
    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    if (!_name)
    {
        //gen name, replace space with _
        NSString* name = [[urlString lastPathComponent] stringByRemovingPercentEncoding];
        
        NSRange extension = NSMakeRange([name length] - 4, 4);
        if (![[name substringWithRange:extension] isEqualToString:@".pdf"])
        {
            name = [name stringByAppendingString:@".pdf"];
        }
        
        NSArray* isHaveSpace = [name componentsSeparatedByString:@" "];
        self.name = [isHaveSpace componentsJoinedByString:@"_"];

        if ([self checkIfWeHaveSomeFile:self.name])
        {
            NSRange addSomeRange = NSMakeRange([self.name length] - 4, 0);
            self.name = [self.name stringByReplacingCharactersInRange:addSomeRange withString:@"A"];
        }
    }
    
    //create localURL (where save)
    self.localURL = [documentsURL URLByAppendingPathComponent:self.name].absoluteString;
    
    _urlString = urlString;
    self.dataDownloadCoreData.urlString = urlString;
    
    [self.coreDataManager save:nil];
}

- (void) setIsComplate:(BOOL)isComplate
{
    _isComplate = isComplate;
}

- (void) setName:(NSString *)name
{
    _name = name;
    self.dataDownloadCoreData.name = name;
}

- (void) setLocalURL:(NSString *)localURL
{
    _localURL =localURL;
}

#pragma mark - Help Methods

+(NSArray*) getAllDataDownloadFromaDatabase
{
    NSArray <DataDownloadCoreData*>* dataDownloadsFromDatabase = [[CoreDataManager sharedManager] getAllDataDownloads];
    
    NSMutableArray* array = [NSMutableArray array];
    for (DataDownloadCoreData* obj in dataDownloadsFromDatabase)
    {
        DataDownload* dataDownload = [[DataDownload alloc] initWithDataDownload:obj];
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

- (BOOL) checkIfWeHaveSomeFile: (NSString*) name
{
    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSString* localURL = [documentsURL URLByAppendingPathComponent:name].resourceSpecifier;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localURL])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
