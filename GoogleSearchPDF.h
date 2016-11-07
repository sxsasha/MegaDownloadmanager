//
//  GoogleSearchPDF.h
//  MegaDownloadManager
//
//  Created by admin on 07.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GotPDFLinksDelegate <NSObject>

- (void) givePDFLink: (NSString*) link;

@end

@interface GoogleSearchPDF : NSObject

@property (nonatomic,weak) id <GotPDFLinksDelegate> delegate;
+(GoogleSearchPDF*) sharedManagerWithDelegate: (id <GotPDFLinksDelegate>) delegate;

- (void) getTenPDFLinks;
@end
