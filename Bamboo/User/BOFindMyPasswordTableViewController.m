//
//  BOFindMyPasswordTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOFindMyPasswordTableViewController.h"

@interface BOFindMyPasswordTableViewController ()

@end

@implementation BOFindMyPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (IBAction)findPasswordButtonClick:(id)sender {
    
    [SVProgressHUD showWithStatus:@"正在发送邮件"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [AVUser requestPasswordResetForEmailInBackground:self.emailTextField.text block:^(BOOL succeeded, NSError *error) {
        [SVProgressHUD dismiss];
        if (succeeded) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发送成功" message:@"邮件已发送成功，请根据邮件重新设置密码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"邮件发送失败" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

@end
