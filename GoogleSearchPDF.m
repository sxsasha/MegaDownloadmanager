//
//  GoogleSearchPDF.m
//  MegaDownloadManager
//
//  Created by admin on 07.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "GoogleSearchPDF.h"
#import "CoreDataManager.h"

#define GoogleAPI @"AIzaSyBIhTNx9XFK3dlLfKHRgnL8Ucx-8juCqbk"
#define GoogleSearchID @"013242499754616033066:azpci6bcd9s"

@interface GoogleSearchPDF ()

@property (nonatomic,strong) dispatch_queue_t queue;
@property (nonatomic,strong) NSURLSessionDataTask* dataTask;

@property (nonatomic,strong) NSMutableArray* arrayOfSearchHistory;
@property (nonatomic,strong) CoreDataManager* coreDataManager;
@end

@implementation GoogleSearchPDF

+(GoogleSearchPDF*) sharedManagerWithDelegate: (id <GotPDFLinksDelegate>) delegate
{
    static GoogleSearchPDF* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GoogleSearchPDF alloc]init];
        manager.delegate = delegate;
        manager.queue = dispatch_queue_create("GoogleSearchPDF", DISPATCH_QUEUE_SERIAL);
        manager.coreDataManager = [CoreDataManager sharedManager];
        
        manager.arrayOfSearchHistory = [NSMutableArray array];
        [manager.arrayOfSearchHistory addObjectsFromArray:[manager.coreDataManager getAllSearchHistory]];
        
    });
    
    return manager;
}

- (void) getTenPDFLinksWithSearchString: (NSString*) searchString
{
    if ([self checkSearchRequest:searchString])
    {
        dispatch_async(self.queue, ^{
            [self createRequest:searchString];
        });
    }
    else
    {
        [self.delegate errorWithSearchString:searchString];
    }
}

- (void) createRequest: (NSString*) searchString
{
    SearchHistory* foundHistory = nil;
    for (SearchHistory* history in self.arrayOfSearchHistory)
    {
        if([history.searchString isEqualToString:searchString])
        {
            history.getCount = history.getCount + 10;
            history.time = [NSDate date];
            foundHistory = history;
            break;
        }
    }
    if (!foundHistory)
    {
       foundHistory = [self.coreDataManager addSearchRequest:searchString count:1 atTime:[NSDate date]];
        [self.arrayOfSearchHistory addObject:foundHistory];
    }

    searchString = [searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    
    NSString* urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=%@&fileType=pdf&filter=1&cx=%@&key=%@&start=%d", searchString,GoogleSearchID,GoogleAPI,foundHistory.getCount];
    
    NSURL* url = [NSURL URLWithString:urlString];
    if (url)
    {
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.f];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
          {
              NSError* errorWithDeSerialization;
              if (data)
              {
                  NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorWithDeSerialization];
                  
                  if ((!errorWithDeSerialization)&&(dictionary))
                  {
                      [self parseDict:dictionary];
                  }
              }
          }] resume];
    }
    else
    {
        [self.delegate errorWithSearchString:searchString];
    }
    
}

-(void) parseDict: (NSDictionary*) dict
{
    NSArray* arrayOfSearchResult = dict[@"items"];
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* dictionary in arrayOfSearchResult)
    {
        [array addObject:dictionary[@"link"]];
    }
    [self.delegate givePDFLink:array];
}

#pragma mark - Help Methods

- (BOOL) checkSearchRequest: (NSString*) string
{
    NSMutableCharacterSet* nonForbiddenSet =[NSMutableCharacterSet alphanumericCharacterSet];
    [nonForbiddenSet addCharactersInString:@" "];
    NSCharacterSet* forbiddenSet = [nonForbiddenSet invertedSet];
    
    BOOL isForbidden = ([string rangeOfCharacterFromSet:forbiddenSet].location != NSNotFound)
    || (([string isEqualToString:@""]));
    
    if (isForbidden)
    {
        return NO;
    }

    return YES;
}



@end
