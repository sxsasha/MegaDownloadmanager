//
//  GoogleSearchPDF.h
//  MegaDownloadManager
//
//  Created by admin on 07.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GotPDFLinksDelegate <NSObject>

- (void) givePDFLink: (NSArray <NSString*> *) link;
- (void) errorWithSearchString: (NSString*) string;

@end

@interface GoogleSearchPDF : NSObject

@property (nonatomic,weak) id <GotPDFLinksDelegate> delegate;

+(GoogleSearchPDF*) sharedManagerWithDelegate: (id <GotPDFLinksDelegate>) delegate;

- (void) getTenPDFLinksWithSearchString: (NSString*) searchString;
@end
