//
//  BOUpdatePasswordTableViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/3.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "UIView+Toast.h"

@interface BOUpdatePasswordTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordAgainTextField;

@end
