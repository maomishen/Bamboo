//
//  BOMainTableViewCell.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/1.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASProgressPopUpView.h"
#import <ChameleonFramework/Chameleon.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BOMainTableViewCell : UITableViewCell <ASProgressPopUpViewDelegate, ASProgressPopUpViewDataSource>

@property (weak, nonatomic) IBOutlet ASProgressPopUpView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *completeBg;

- (void) setUserHeaderImage:(NSString *) url;
- (void) setProgress:(int) page withPages:(int) pages;

@end
