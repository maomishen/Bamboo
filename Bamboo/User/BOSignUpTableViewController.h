//
//  BOSignUpTableViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"

@interface BOSignUpTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *displayNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;


@end
