//
//  BOLoginTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOLoginTableViewController.h"

@interface BOLoginTableViewController () <UITextFieldDelegate>

@end

@implementation BOLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [self.signUpButton setBackgroundImage:[self imageWithColor:[UIColor flatBlueColorDark]] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[self imageWithColor:[UIColor flatGreenColor]] forState:UIControlStateHighlighted];
    [self.forgetButton setBackgroundImage:[self imageWithColor:[UIColor flatRedColor]] forState:UIControlStateHighlighted];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

#pragma mark - cell button click

- (IBAction)loginButtonClick:(id)sender {
    [self hideTheKeyboard];
    
    NSString *email = self.emailTextField.text;// 设置邮箱
    if (email == nil || [email isEqualToString:@""]) {
        [self alertNilMessage:@"邮箱不可为空" withTextField:self.emailTextField];
        return;
    }
    NSString *password = self.passwordTextField.text;// 设置用户名
    if (password == nil || [password isEqualToString:@""]) {
        [self alertNilMessage:@"密码不可为空" withTextField:self.passwordTextField];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在登录"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [AVUser logInWithUsernameInBackground:email password:password block:^(AVUser *user, NSError *error) {
        [SVProgressHUD dismiss];
        if (user != nil) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (IBAction)signUpButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"SignUpPushSegue" sender:self];
}

- (IBAction)forgetPasswordButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"FindPasswordPushSegue" sender:self];
}

#pragma mark - text field

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType==UIReturnKeyNext){       //显示下一个
        if (self.emailTextField == textField) {
            [self.passwordTextField becomeFirstResponder];
        }
    } else {
        [self hideTheKeyboard];
    }
    return YES;
}

- (void)hideTheKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - alert

- (void) alertNilMessage:(NSString *)errorMessage withTextField:(UITextField*) textField{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请填写完整" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [textField becomeFirstResponder];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - private
//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
