//
//  DownloadCell.h
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataDownload;

@interface DownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *sizeProgressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pauseImageView;

@property (nonatomic,weak) DataDownload* dataDownload;


@end
