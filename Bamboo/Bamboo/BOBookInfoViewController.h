//
//  BOBookInfoViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/6.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BOBookInfoViewController : UIViewController

@property AVObject *book;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end
