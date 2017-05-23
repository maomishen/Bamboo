//
//  BOUpdatePasswordTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/3.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOUpdatePasswordTableViewController.h"

@interface BOUpdatePasswordTableViewController () <UITextFieldDelegate>

@end

@implementation BOUpdatePasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.oldPasswordTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    self.PasswordAgainTextField.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma mark - button click

- (IBAction)doneButtonClick:(id)sender {
    [self hideTheKeyboard];
    if (self.oldPasswordTextField.text == nil || [self.oldPasswordTextField.text isEqualToString:@""]) {
        [self alertNilMessage:@"密码不可为空" withTextField:self.oldPasswordTextField];
        return;
    }
    if (self.PasswordTextField.text == nil || [self.PasswordTextField.text isEqualToString:@""]) {
        [self alertNilMessage:@"新密码不可为空" withTextField:self.PasswordTextField];
        return;
    }
    if (self.PasswordAgainTextField.text == nil || [self.PasswordAgainTextField.text isEqualToString:@""]) {
        [self alertNilMessage:@"确认密码不可为空" withTextField:self.PasswordAgainTextField];
        return;
    }
    if (![self.PasswordTextField.text isEqualToString:self.PasswordAgainTextField.text]) {
        [self alertNilMessage:@"两次密码不相同" withTextField:self.PasswordAgainTextField];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在修改，请稍候"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [[AVUser currentUser] updatePassword:self.oldPasswordTextField.text newPassword:self.PasswordTextField.text block:^(id object, NSError *error) {
        [self hideTheKeyboard];
        [SVProgressHUD dismiss];
        if (error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失败" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - alert

- (void) alertNilMessage:(NSString *)errorMessage withTextField:(UITextField*) textField{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"额···" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [textField becomeFirstResponder];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - TextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField.returnKeyType==UIReturnKeyNext){//显示下一个
        if (self.oldPasswordTextField == textField) {
            [self.PasswordTextField becomeFirstResponder];
        } else if (self.PasswordTextField == textField) {
            [self.PasswordAgainTextField becomeFirstResponder];
        }
    } else {
        [self hideTheKeyboard];
    }
    return YES;
}

#pragma mark - keyboard

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideTheKeyboard];
}

- (void)hideTheKeyboard {
    [self.oldPasswordTextField resignFirstResponder];
    [self.PasswordTextField resignFirstResponder];
    [self.PasswordAgainTextField resignFirstResponder];
}

@end
