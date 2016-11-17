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

//#define timeToUpdate 0.04  //25 framerate

@interface ViewController () <DownloadTasksDelegate, UITableViewDelegate, UITableViewDataSource,GotPDFLinksDelegate,UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

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
    
    [self emptyTableView];
    [self initALL];
    [self setupSearchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) emptyTableView
{
    // For EmptyDataSet
    // empty tableView
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

- (void) initALL
{
    self.downloadManager = [DownloadManager sharedManagerWithDelegate:self];
    self.searchPDFmanager = [GoogleSearchPDF sharedManagerWithDelegate:self];
    
    self.arrayOfDataDownload = [NSMutableArray array];
    self.dictionaryOfCurrentDownload = [NSMutableDictionary dictionary];
    
    NSArray* dataDownloadsFromDatabase = [DataDownload getAllDataDownloadFromaDatabase];
    [self.arrayOfDataDownload addObjectsFromArray:dataDownloadsFromDatabase];
}

- (void) setupSearchBar
{
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Type search request";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.spellCheckingType = UITextSpellCheckingTypeNo;
    self.searchBar.keyboardType = UIKeyboardTypeWebSearch;
    self.searchBar.enablesReturnKeyAutomatically = NO;
    self.searchBar.returnKeyType = UIReturnKeySearch;
}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchPDFmanager getTenPDFLinksWithSearchString:self.searchBar.text];
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
    dataDownload.isDownloading = NO;
    NSURL* localURL = [NSURL URLWithString:dataDownload.localURL];
    [[NSFileManager defaultManager] moveItemAtURL:url toURL:localURL error:nil];
}
-(void) progressDownload: (double) progress
              identifier: (int16_t) identifier
         totalDownloaded: (NSString*) downloaded
{
    DataDownload* dataDownload = [self.dictionaryOfCurrentDownload objectForKey:@(identifier)];
    dataDownload.progress = progress;
    dataDownload.downloaded = downloaded;
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
    }
    
    cell.dataDownload = [self.arrayOfDataDownload objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = cell.dataDownload.name;
    
    cell.dataDownload.progress = (double)cell.dataDownload.isComplate;
    double percent = (((cell.dataDownload.progress*100) < 0)||((cell.dataDownload.progress*100) > 100)) ?
    0.f: cell.dataDownload.progress*100;
    cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",percent];
    [cell.progressView setProgress:cell.dataDownload.progress animated:NO];
    cell.sizeProgressLabel.text = cell.dataDownload.downloaded;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
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
        dataDownload.isDownloading = NO;
    }
    else if (!dataDownload.isDownloading)
    {
        dataDownload.downloadTask = [self.downloadManager downloadWithURL:dataDownload.urlString];
        dataDownload.identifier = (int16_t)dataDownload.downloadTask.taskIdentifier;
        dataDownload.isDownloading = YES;
        [self.dictionaryOfCurrentDownload setObject:dataDownload forKey:@(dataDownload.identifier)];
    }
    else if (dataDownload.isDownloading)
    {
        if (dataDownload.downloadTask.state == NSURLSessionTaskStateRunning)
        {
            [dataDownload.downloadTask suspend];
        }
        else if (dataDownload.downloadTask.state == NSURLSessionTaskStateSuspended)
        {
            [dataDownload.downloadTask resume];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        DownloadCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell removeAllObserver];
        
        DataDownload* dataDownload = [self.arrayOfDataDownload objectAtIndex:indexPath.row];
        [self.arrayOfDataDownload removeObject:dataDownload];
        [dataDownload removeFromDatabase];
        [dataDownload.downloadTask cancel];
        
        dataDownload = nil;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}
#pragma mark - DZNEmptyDataSetSource & DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"emptyPlaceholder.png"];
}

//The attributed string for the title of the empty state
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Please trying search something";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//The attributed string for the description of the empty state
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Program trying search this in Google like pdf and u can download it and watch.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
