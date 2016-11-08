//
//  ViewController.m
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"
#import "DataDownload.h"
#import "DownloadManager.h"
#import "DownloadCell.h"
#import "GoogleSearchPDF.h"

#define timeToUpdate 0.04  //25 framerate

@interface ViewController () <DownloadTasksDelegate, UITableViewDelegate, UITableViewDataSource,GotPDFLinksDelegate>

@property (nonatomic,strong) NSMutableArray* arrayOfDataDownload;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,strong) DownloadManager* downloadManager;
@property (nonatomic,strong) GoogleSearchPDF* searchPDFmanager;
@property (nonatomic,assign) BOOL somethingChange;
@property (nonatomic,strong) UIWebView* webView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayOfDataDownload = [NSMutableArray array];
    self.downloadManager = [DownloadManager sharedManagerWithDelegate:self];
    self.somethingChange = NO;
    
    self.searchPDFmanager = [GoogleSearchPDF sharedManagerWithDelegate:self];
    [self.searchPDFmanager getTenPDFLinks];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setSomethingChange:(BOOL)somethingChange
{
    if (_somethingChange == NO)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeToUpdate * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            _somethingChange = NO;
        });
    }
    _somethingChange = YES;
}

#pragma mark - GotPDFLinksDelegate

- (void)givePDFLink:(NSString *)link
{
    DataDownload* download = [[DataDownload alloc]init];
    download.urlString = link;
    [self.arrayOfDataDownload addObject:download];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


#pragma mark - DownloadTasksDelegate

-(void) complateDownloadInURL:(NSURL *)url taskIdentifier:(NSUInteger)identifier
{
    for(DataDownload* download in self.arrayOfDataDownload)
    {
        if (download.identifier == identifier)
        {
            download.progress = 1.0f;
            download.isComplate = YES;
            self.somethingChange = YES;
            [[NSFileManager defaultManager] moveItemAtURL:url toURL:download.localURL error:nil];
            break;
        }
    }
}

-(void) progressDownload:(double)progress taskIdentifier:(NSUInteger)identifier
{
    for(DataDownload* download in self.arrayOfDataDownload)
    {
        if (download.identifier == identifier)
        {
            download.progress = progress;
            self.somethingChange = YES;
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfDataDownload count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"pdf";
    
    DownloadCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DownloadCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    DataDownload* download = [self.arrayOfDataDownload objectAtIndex:indexPath.row];
    cell.nameLabel.text = download.name;
    
    double percent = (((download.progress*100) < 0)||((download.progress*100) > 100)) ? 0.f: download.progress*100;
    cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",percent];
    [cell.progressView setProgress:download.progress animated:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DataDownload* download = [self.arrayOfDataDownload objectAtIndex:indexPath.row];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:download.localURL.resourceSpecifier])
    {
        download.isComplate = YES;
        download.progress = 1.f;
        
        UIViewController* viewController = [[UIViewController alloc]init];
        
        [self.webView loadHTMLString: @"" baseURL: nil];
        self.webView = nil;
        viewController.view = self.webView = [[UIWebView alloc]init];
        
        NSURLRequest* requests = [NSURLRequest requestWithURL:download.localURL];
        [self.webView loadRequest:requests];
        
        [self.navigationController pushViewController:viewController animated:YES];
        self.somethingChange = YES;
    }
    else if (download.progress == 0.f)
    {
        download.identifier = [self.downloadManager downloadFromURL:download.urlString];
    }
}

@end
