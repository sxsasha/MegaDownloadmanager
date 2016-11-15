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
@property (nonatomic,strong) NSMutableDictionary* dictionaryOfCurrentDownload;

@property (nonatomic,strong) DownloadManager* downloadManager;
@property (nonatomic,strong) GoogleSearchPDF* searchPDFmanager;

@property (nonatomic,strong) UIWebView* webView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initALL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) initALL
{
    
//    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
//                                                                  inDomains:NSUserDomainMask] lastObject];
//    NSLog(@"documentsURL: %@", documentsURL);
//    [[CoreDataManager sharedManager] deleteAll];
//    [[CoreDataManager sharedManager] save:nil];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.downloadManager = [DownloadManager sharedManagerWithDelegate:self];
    self.searchPDFmanager = [GoogleSearchPDF sharedManagerWithDelegate:self];
    
    self.arrayOfDataDownload = [NSMutableArray array];
    self.dictionaryOfCurrentDownload = [NSMutableDictionary dictionary];
    
    NSArray* dataDownloadsFromDatabase = [DataDownload getAllDataDownloadFromaDatabase];
    [self.arrayOfDataDownload addObjectsFromArray:dataDownloadsFromDatabase];
    
    //[self.searchPDFmanager getTenPDFLinksWithSearchString:@"Test"];
}

#pragma mark - Actions

- (IBAction)addMorePDFLinks:(UIBarButtonItem *)sender
{
    [self.searchPDFmanager getTenPDFLinksWithSearchString:self.searchBar.text];
}

#pragma mark - Help Methods

- (void) updateDownloadCell: (DataDownload*) dataDownload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!dataDownload.isComplate)
        {
            double percent = (((dataDownload.progress*100) < 0)||((dataDownload.progress*100) > 100)) ?
            0.f: dataDownload.progress*100;
            dataDownload.cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",percent];
            [dataDownload.cell.progressView setProgress:dataDownload.progress animated:YES];
            return;
        }
        else
        {
            dataDownload.cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",100.0];
            [dataDownload.cell.progressView setProgress:1.f animated:YES];
        }
    });
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - GotPDFLinksDelegate

- (void)givePDFLink:(NSArray <NSString*> *)links
{
    for (NSString* urlString in links)
    {
        DataDownload* download = [[DataDownload alloc] init];
        download.urlString = urlString;
        
        [self.arrayOfDataDownload addObject:download];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - DownloadTasksDelegate

-(void) complateDownloadInURL:(NSURL *)url identifier:(int16_t)identifier
{
    DataDownload* dataDownload = [self.dictionaryOfCurrentDownload objectForKey:@(identifier)];
    dataDownload.progress = 1.0f;
    dataDownload.isComplate = YES;
    NSURL* localURL = [NSURL URLWithString:dataDownload.localURL];
    [[NSFileManager defaultManager] moveItemAtURL:url toURL:localURL error:nil];
    
    [self updateDownloadCell:dataDownload];
}

-(void) progressDownload:(double)progress identifier:(int16_t)identifier
{
    DataDownload* dataDownload = [self.dictionaryOfCurrentDownload objectForKey:@(identifier)];
    dataDownload.progress = progress;
    
    [self updateDownloadCell:dataDownload];
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
    
    DataDownload* dataDownload = [self.arrayOfDataDownload objectAtIndex:indexPath.row];
    dataDownload.cell = cell;
    cell.nameLabel.text = dataDownload.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DataDownload* dataDownload = [self.arrayOfDataDownload objectAtIndex:indexPath.row];
    NSURL* localURL = [NSURL URLWithString:dataDownload.localURL];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localURL.resourceSpecifier])
    {
        UIViewController* viewController = [[UIViewController alloc]init];
        
        [self.webView loadHTMLString: @"" baseURL: nil];
        self.webView = nil;
        viewController.view = self.webView = [[UIWebView alloc]init];
        
        NSURL* localURL = [NSURL URLWithString:dataDownload.localURL];
        NSURLRequest* requests = [NSURLRequest requestWithURL:localURL];
        [self.webView loadRequest:requests];
        
        [self.navigationController pushViewController:viewController animated:YES];
        dataDownload.isComplate = YES;
        [self updateDownloadCell:dataDownload];
    }
    else if (dataDownload.progress == 0.f)
    {
        dataDownload.identifier = [self.downloadManager downloadWithURL:dataDownload.urlString];
        [self.dictionaryOfCurrentDownload setObject:dataDownload forKey:@(dataDownload.identifier)];
    }
}

@end
