//
//  GoogleSearchPDF.m
//  MegaDownloadManager
//
//  Created by admin on 07.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "GoogleSearchPDF.h"

#define GoogleAPI @"AIzaSyBIhTNx9XFK3dlLfKHRgnL8Ucx-8juCqbk"
#define GoogleSearchID @"013242499754616033066:azpci6bcd9s"

@interface GoogleSearchPDF ()

@property (nonatomic,strong) dispatch_queue_t queue;
@property (nonatomic,assign) NSInteger startIndex;
@property (nonatomic,strong) NSURLSessionDataTask* dataTask;
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
        manager.startIndex = 1 + (arc4random() % 90);
    });
    
    return manager;
}

- (void) getTenPDFLinks
{
    //dispatch_async(self.queue, ^{
        [self createRequest];
   // });
}

- (void) createRequest
{
    NSString* urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=ios&fileType=pdf&filter=1&cx=%@&key=%@&start=%ld",GoogleSearchID,GoogleAPI,self.startIndex];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.f];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSError* errorWithDeSerialization;
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorWithDeSerialization];
        
        if ((!errorWithDeSerialization)&&(dictionary))
        {
            [self parseDict:dictionary];
        }
    }] resume];
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

@end
