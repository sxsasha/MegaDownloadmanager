//
//  DownloadCell.m
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell

#pragma mark - Some Main methods

//-(void) prepareForReuse
//{
//    [self removeAllObserver];
//}
//
//- (void) setDataDownload:(DataDownload *)dataDownload
//{
//    __weak id weakId = dataDownload;
//    _dataDownload = weakId;
//    
//    [self addObserver:self forKeyPath:@"dataDownload.progress" options:NSKeyValueObservingOptionNew context:nil];
//    [self addObserver:self forKeyPath:@"dataDownload.downloaded" options:NSKeyValueObservingOptionNew context:nil];
//    [self addObserver:self forKeyPath:@"dataDownload.isComplate" options:NSKeyValueObservingOptionNew context:nil];
//    [self addObserver:self forKeyPath:@"dataDownload.isPause" options:NSKeyValueObservingOptionNew context:nil];
//}
//
//- (void)dealloc
//{
//    [self removeAllObserver];
//}
//
//
//#pragma mark - remove observer than delete dataDownload
//- (void) removeAllObserver
//{
//    if (self.observationInfo)
//    {
//        [self removeObserver:self forKeyPath:@"dataDownload.progress"];
//        [self removeObserver:self forKeyPath:@"dataDownload.downloaded"];
//        [self removeObserver:self forKeyPath:@"dataDownload.isComplate"];
//        [self removeObserver:self forKeyPath:@"dataDownload.isPause"];
//    }
//}

#pragma mark - Update cell
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"dataDownload.progress"])
    {
        double progress = [((NSNumber*)[change valueForKey: NSKeyValueChangeNewKey]) doubleValue];
        if (progress <= -100.f)
        {
          //  [self removeAllObserver];
            return;
        }
        double percent = (((progress*100) < 0)||((progress*100) > 100)) ? 0.f: progress*100;
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.progressLabel.text = [NSString stringWithFormat:@"%.2f",percent];
            [self.progressView setProgress:progress animated:NO];
        });
    }
    else if([keyPath isEqualToString:@"dataDownload.downloaded"])
    {
        id text = [change objectForKey:NSKeyValueChangeNewKey];
        if ([text isKindOfClass:[NSString class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               self.sizeProgressLabel.text = text;
                           });
        }
    }
    else if(([keyPath isEqualToString:@"dataDownload.isComplate"])&&([((NSNumber*)[change valueForKey: NSKeyValueChangeNewKey]) boolValue]))
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.progressLabel.text = [NSString stringWithFormat:@"%.2f",100.f];
            [self.progressView setProgress:1.f animated:NO];
        });
    }
    else if([keyPath isEqualToString:@"dataDownload.isPause"])
    {
        BOOL isPause = [((NSNumber*)[change valueForKey: NSKeyValueChangeNewKey]) boolValue];
        dispatch_async(dispatch_get_main_queue(), ^
                    {
                        if (isPause)
                        {
                            [self.pauseImageView setHidden:NO];
                        }
                        else
                        {
                            [self.pauseImageView setHidden:YES];
                        }
                    });
    }
}

@end
