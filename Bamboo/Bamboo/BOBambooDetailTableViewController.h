//
//  BOBambooDetailTableViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "ASProgressPopUpView.h"
#import <ChameleonFramework/Chameleon.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "BOBookInfoViewController.h"

@import GoogleMobileAds;

@interface BOBambooDetailTableViewController : UITableViewController <ASProgressPopUpViewDataSource>

@property AVObject *bamboo;

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView;
@property (weak, nonatomic) IBOutlet GADNativeExpressAdView *adView;

@end
