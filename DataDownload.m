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
<<<<<<< HEAD
=======
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
        self.localName = dataDownload.localName;
        self.urlString = dataDownload.urlString;
        
        if ([self checkIfWeHaveSomeFile:self.localName])
        {
            self.isComplate = YES;
            self.progress = 1.f;
        }
>>>>>>> Beta
    }
    return self;
}

<<<<<<< HEAD
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

=======
- (void)dealloc
{
    
>>>>>>> Beta
}

#pragma mark - Setters & Getters
- (void) setUrlString:(NSString *)urlString
{
<<<<<<< HEAD
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

=======
    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    if (!_name)
    {
        self.name = [[urlString stringByRemovingPercentEncoding]  lastPathComponent];
    }

    if (!_localName)
    {
        //gen name, replace space with _
        NSString* localName = [urlString lastPathComponent];

        if ([localName length] < 5)
        {
            localName = [localName stringByAppendingString:@".pdf"];
        }
        else
        {
            NSRange extension = NSMakeRange([localName length] - 4, 4);
            if (![[localName substringWithRange:extension] isEqualToString:@".pdf"])
            {
                localName = [localName stringByAppendingString:@".pdf"];
            }
        }
        
        
        NSMutableCharacterSet* characters = [NSMutableCharacterSet alphanumericCharacterSet];
        [characters addCharactersInString:@"."];
        [characters invert];
        
        NSArray* isHaveSpace = [localName componentsSeparatedByCharactersInSet:characters];
        self.localName = [isHaveSpace componentsJoinedByString:@"_"];

        if ([self checkIfWeHaveSomeFile:self.localName])
        {
            NSRange addSomeRange = NSMakeRange([self.localName length] - 4, 0);
            self.localName = [self.localName stringByReplacingCharactersInRange:addSomeRange withString:@"A"];
        }
    }
    
    //create localURL (where save)
    self.localURL = [documentsURL URLByAppendingPathComponent:self.localName].absoluteString;
    
>>>>>>> Beta
    _urlString = urlString;
    self.dataDownloadCoreData.urlString = urlString;
    
    [self.coreDataManager save:nil];
<<<<<<< HEAD
=======
}

- (void) setName:(NSString *)name
{
    _name = name;
    self.dataDownloadCoreData.name = name;
}

- (void) setLocalName:(NSString *)localName
{
    _localName = localName;
    self.dataDownloadCoreData.localName = localName;
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
>>>>>>> Beta
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
