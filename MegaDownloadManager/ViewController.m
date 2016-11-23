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
#import "Reachability.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource,GotPDFLinksDelegate,UISearchBarDelegate, UIWebViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong) NSMutableArray* arrayOfDataDownload;
@property (nonatomic,strong) Reachability* reach;

@property (nonatomic,strong) DownloadManager* downloadManager;
@property (nonatomic,strong) GoogleSearchPDF* searchPDFmanager;

@property (nonatomic,strong) UIWebView* webView;
@property (strong, nonatomic) UISearchBar* searchBar;
@property (strong, nonatomic) UITextField* searchField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self emptyTableView];
    [self initAll];
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
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void) initAll
{
    self.downloadManager = [DownloadManager sharedManager];
    self.searchPDFmanager = [GoogleSearchPDF sharedManagerWithDelegate:self];
    
    self.arrayOfDataDownload = [NSMutableArray array];
    
    NSArray* dataDownloadsFromDatabase = [DataDownload getAllDataDownloadFromaDatabase];
    [self.arrayOfDataDownload addObjectsFromArray:dataDownloadsFromDatabase];
    
    // check if we have internet connections with Reachability
    self.reach = [Reachability reachabilityWithHostname:@"https://www.apple.com"];
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
    
    UIView* view = [self.searchBar.subviews firstObject];
    NSUInteger numViews = [view.subviews count];
    for(int i = 0; i < numViews; i++)
    {
        if([[view.subviews objectAtIndex:i] isKindOfClass:[UITextField class]])
        {
            self.searchField = [view.subviews objectAtIndex:i];
        }
    }

}


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self  addMorePDFLinks];
}

#pragma mark - Actions
- (IBAction)addMorePDFLinks:(UIBarButtonItem *)sender
{
    [self  addMorePDFLinks];
    [sender setEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

#pragma mark - Help Methods

- (void) addMorePDFLinks
{
    if (self.reach.isReachable)
    {
        [self.searchPDFmanager getTenPDFLinksWithSearchString:self.searchBar.text];
        [self.searchBar resignFirstResponder];
    }
    else
    {
        [self errorWithSearchString:nil];
        UIAlertController* alertController =
        [UIAlertController alertControllerWithTitle:@"No Internet Connection"
                                            message:@"Your device has no internet connection now"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:okAction];
         
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void) reSetupCell: (DownloadCell*) cell
{
    cell.dataDownload.progress = cell.dataDownload.progress;
    
    double percent = [self percentFromProgress:cell.dataDownload.progress];
    cell.progressLabel.text = [NSString stringWithFormat:@"%.2f",percent];
    
    cell.nameLabel.text = cell.dataDownload.name;
    
    cell.sizeProgressLabel.text = cell.dataDownload.downloaded;
    
    [cell.progressView setProgress:cell.dataDownload.progress animated:NO];
    
    cell.pauseImageView.hidden = !cell.dataDownload.isPause;
}

- (double) percentFromProgress: (double) progress
{
    return (((progress*100) < 0)||((progress*100) > 100)) ? 0.f: progress*100;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - GotPDFLinksDelegate

- (void)givePDFLink:(NSArray <NSString*> *)links
{
    NSMutableArray* array = [NSMutableArray array];
    for (NSString* urlString in links)
    {
        BOOL isHaveSomeURL = NO;
        for (DataDownload* dataDownload in self.arrayOfDataDownload)
        {
            isHaveSomeURL = isHaveSomeURL || [dataDownload.urlString isEqualToString:urlString];
        }
        if (!isHaveSomeURL)
        {
            DataDownload* download = [[DataDownload alloc] init];
            download.urlString = urlString;
            [array addObject:download];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray* arrayOfIndexs = [NSMutableArray array];
        for (int i = 0; i < [array count]; i++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [arrayOfIndexs addObject:indexPath];
        }
        NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [array count])];
        [self.arrayOfDataDownload insertObjects:array atIndexes:indexSet];
        [self.tableView insertRowsAtIndexPaths:arrayOfIndexs withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView reloadData];
        
        [[CoreDataManager sharedManager] save:nil];
    });
}

-(void) errorWithSearchString:(NSString *)string
{
    [UIView animateWithDuration:0.3f animations:^{
        self.searchField.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished){
        self.searchField.backgroundColor = nil;
    }];
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
    
    [self reSetupCell:cell];
    
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
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.maximumZoomScale = 20;
        self.webView.scrollView.minimumZoomScale = 1;

        NSURL* localURL = [NSURL URLWithString:dataDownload.localURL];
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:localURL];
        [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:localURL];
        
        [self.navigationController pushViewController:viewController animated:YES];
        dataDownload.isComplate = YES;
        dataDownload.isDownloading = NO;
    }
    else if (!dataDownload.isDownloading)
    {
        ProgressBlock progressBlock = ^(double progress,int identifier,NSString* totalString)
        {
            dataDownload.progress = progress;
            dataDownload.downloaded = totalString;
        };
        ComplateBlock complateBlock = ^(int identifier, NSURL* url)
        {
            dataDownload.progress = 1.0f;
            dataDownload.isComplate = YES;
            dataDownload.isDownloading = NO;
            NSURL* localURL = [NSURL URLWithString:dataDownload.localURL];
            [[NSFileManager defaultManager] moveItemAtURL:url toURL:localURL error:nil];
        };
        ErrorBlock errorBlock = ^(NSError* error)
        {
            dataDownload.downloaded = error.localizedFailureReason;
        };
 
        dataDownload.downloadTask = [self.downloadManager downloadWithURL:dataDownload.urlString
                                                         progressDownload:progressBlock
                                                            complateBlock:complateBlock
                                                               errorBlock:errorBlock];
                                     
        dataDownload.identifier = (int16_t)dataDownload.downloadTask.taskIdentifier;
        dataDownload.isDownloading = YES;
    }
    else if (dataDownload.isDownloading)
    {
        if (dataDownload.downloadTask.state == NSURLSessionTaskStateRunning)
        {
            [dataDownload.downloadTask suspend];
            dataDownload.isPause = YES;
        }
        else if (dataDownload.downloadTask.state == NSURLSessionTaskStateSuspended)
        {
            [dataDownload.downloadTask resume];
            dataDownload.isPause = NO;
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
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        //fix for bug with undelete observer
        dataDownload.progress = -100.f;
        
        dataDownload = nil;
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(NSURLRequest* )request
 navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL isExternalResource = [request.URL.scheme rangeOfString:@"http"].location != NSNotFound;
       
    if ((navigationType == UIWebViewNavigationTypeLinkClicked)&&isExternalResource)
    {
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString* html = @"<html><body><head><h1>Error with open File</h1></head></body></html>";
    [webView loadHTMLString:html baseURL:nil];
}

#pragma mark - DZNEmptyDataSetSource & DZNEmptyDataSetDelegate

- (UIImage* )imageForEmptyDataSet:(UIScrollView* )scrollView
{
    return [UIImage imageNamed:@"emptyPlaceholder.png"];
}

//The attributed string for the title of the empty state
- (NSAttributedString* )titleForEmptyDataSet:(UIScrollView* )scrollView
{
    NSString* text = @"Please trying search something";
    
    NSDictionary* attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//The attributed string for the description of the empty state
- (NSAttributedString* )descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString* text = @"Program trying search this in Google like pdf and u can download it and watch.";
    
    NSMutableParagraphStyle* paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary* attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
-(void)emptyDataSet:(UIScrollView* )scrollView didTapView:(UIView* )view
{
    [self.searchBar resignFirstResponder];
}


@end
