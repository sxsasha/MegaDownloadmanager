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
    dispatch_async(self.queue, ^{
        [self createRequest];
    });
}

- (void) createRequest
{
    NSString* urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=ios&fileType=pdf&filter=1&cx=%@&key=%@&start=%ld",GoogleSearchID,GoogleAPI,self.startIndex];
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSData* JSONdata = [NSData dataWithContentsOfURL:url];
    
    NSError* error;
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:JSONdata options:NSJSONReadingAllowFragments error:&error];
    
    if ((!error)&&(dictionary))
    {
        [self parseDict:dictionary];
    }
}

-(void) parseDict: (NSDictionary*) dict
{
    NSArray* arrayOfSearchResult = dict[@"items"];
    
    for (NSDictionary* dictionary in arrayOfSearchResult)
    {
        [self.delegate givePDFLink:dictionary[@"link"]];
    }
}

@end
