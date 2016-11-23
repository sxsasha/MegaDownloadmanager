//
//  DownloadCell.h
//  MegaDownloadManager
//
//  Created by admin on 04.11.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDownload.h"

@interface DownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *sizeProgressLabel;
<<<<<<< HEAD
=======
@property (weak, nonatomic) IBOutlet UIImageView *pauseImageView;
>>>>>>> Beta

@property (weak, nonatomic) DataDownload* dataDownload;

- (void) removeAllObserver;

@end
