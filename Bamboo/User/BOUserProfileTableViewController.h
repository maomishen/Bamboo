//
//  BOUserProfileTableViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BOUserProfileTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;

@end
