//
//  BookISBNResultViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/3.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BookISBNResultViewController : UIViewController

@property NSString *isbnString;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loading;
@property AVObject *book;

@end
