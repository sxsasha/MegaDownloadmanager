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
        self.cellAccessoryType = UITableViewCellAccessoryNone;
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
    
    _urlString = urlString;
    self.dataDownloadCoreData.urlString = urlString;
    
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


#pragma mark Setters for updating interface
- (void) setIsPause:(BOOL)isPause
{
    _isPause = isPause;
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       if (isPause)
                       {
                           self.cell.pauseImageView.image = [UIImage imageNamed:@"pause.png"];
                           [self.cell.pauseImageView setHidden:NO];
                       }
                       else if (self.isDownloading)
                       {
                           self.cell.pauseImageView.image = [UIImage imageNamed:@"download.png"];
                           [self.cell.pauseImageView setHidden:NO];
                       }
                       else
                       {
                           [self.cell.pauseImageView setHidden:YES];
                       }
                   });
}

- (void) setIsDownloading:(BOOL)isDownloading
{
    _isDownloading = isDownloading;
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       if (isDownloading)
                       {
                           self.cell.pauseImageView.image = [UIImage imageNamed:@"download.png"];
                           [self.cell.pauseImageView setHidden:NO];
                       }
                   });
}

- (void) setIsComplate:(BOOL)isComplate
{
    _isComplate = isComplate;
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",100.f];
                       [self.cell.progressView setProgress:1.f animated:NO];
                       self.cell.pauseImageView.hidden = YES;
                   });
}

- (void) setProgress:(double)progress
{
    _progress = progress;
    double percent = (((progress*100) < 0)||((progress*100) > 100)) ? 0.f: progress*100;
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",percent];
                       [self.cell.progressView setProgress:progress animated:NO];
                   });

}

- (void) setDownloaded:(NSString *)downloaded
{
    _downloaded = downloaded;
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       self.cell.sizeProgressLabel.text = downloaded;
                   });
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
