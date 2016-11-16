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

@interface ViewController () <DownloadTasksDelegate, UITableViewDelegate, UITableViewDataSource,GotPDFLinksDelegate,UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray* arrayOfDataDownload;
@property (nonatomic,strong) NSMutableDictionary* dictionaryOfCurrentDownload;

@property (nonatomic,strong) DownloadManager* downloadManager;
@property (nonatomic,strong) GoogleSearchPDF* searchPDFmanager;

@property (nonatomic,strong) UIWebView* webView;
@property (strong, nonatomic) UISearchBar* searchBar;

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
    self.downloadManager = [DownloadManager sharedManagerWithDelegate:self];
    self.searchPDFmanager = [GoogleSearchPDF sharedManagerWithDelegate:self];
    
    self.arrayOfDataDownload = [NSMutableArray array];
    self.dictionaryOfCurrentDownload = [NSMutableDictionary dictionary];
    
    NSArray* dataDownloadsFromDatabase = [DataDownload getAllDataDownloadFromaDatabase];
    [self.arrayOfDataDownload addObjectsFromArray:dataDownloadsFromDatabase];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Type search request";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - Actions

- (IBAction)addMorePDFLinks:(UIBarButtonItem *)sender
{
    [self.searchPDFmanager getTenPDFLinksWithSearchString:self.searchBar.text];
}

#pragma mark - Help Methods

//- (void) updateDownloadCell: (DataDownload*) dataDownload
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (!dataDownload.isComplate)
//        {
//            double percent = (((dataDownload.progress*100) < 0)||((dataDownload.progress*100) > 100)) ?
//            0.f: dataDownload.progress*100;
//            dataDownload.cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",percent];
//            [dataDownload.cell.progressView setProgress:dataDownload.progress animated:YES];
//            return;
//        }
//        else
//        {
//            dataDownload.cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",100.0];
//            [dataDownload.cell.progressView setProgress:1.f animated:YES];
//        }
//    });
//}

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
}

-(void) progressDownload:(double)progress identifier:(int16_t)identifier
{
    DataDownload* dataDownload = [self.dictionaryOfCurrentDownload objectForKey:@(identifier)];
    dataDownload.progress = progress;
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
        cell = [[DownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        CALayer *layer = tableView.layer;
//        [layer setMasksToBounds:YES];
//        [layer setCornerRadius: 4.0];
//        [layer setBorderWidth:1.0];
//        [layer setBorderColor:[[UIColor redColor] CGColor]];
////
//        cell.layer.shadowOffset = CGSizeMake(1, 0);
//        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
//        cell.layer.shadowRadius = 5;
//        cell.layer.shadowOpacity = .25;
        
        cell.layer.shadowOpacity = 1.0;
        cell.layer.shadowRadius = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 2);
        cell.layer.shadowColor = UIColor.blackColor.CGColor;
        
//        cell.layer.borderWidth = 10.2;
//        cell.layer.cornerRadius = 10;
//        cell.layer.backgroundColor = [[UIColor redColor] CGColor];
    }
    
    cell.dataDownload = [self.arrayOfDataDownload objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = cell.dataDownload.name;
    
    cell.dataDownload.progress = (double)cell.dataDownload.isComplate;
    double percent = (((cell.dataDownload.progress*100) < 0)||((cell.dataDownload.progress*100) > 100)) ?
    0.f: cell.dataDownload.progress*100;
    cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",percent];
    [cell.progressView setProgress:cell.dataDownload.progress animated:NO];
    
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
    }
    else if (!dataDownload.isDownloading)
    {
        dataDownload.identifier = [self.downloadManager downloadWithURL:dataDownload.urlString];
        dataDownload.isDownloading = YES;
        [self.dictionaryOfCurrentDownload setObject:dataDownload forKey:@(dataDownload.identifier)];
    }
}

@end
