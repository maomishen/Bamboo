//
//  BOUserTableViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/6.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "BOBookListTableViewController.h"
@import FirebaseAuth;

@interface BOUserTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bambooNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneNumberLabel;

@end
