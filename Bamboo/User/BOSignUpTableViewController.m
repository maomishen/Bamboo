//
//  BOSignUpTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOSignUpTableViewController.h"

@interface BOSignUpTableViewController () <UITextFieldDelegate>

@property NSString *username;
    
@end

@implementation BOSignUpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordAgainTextField.delegate = self;
    self.displayNameTextField.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 1;
    }
}

#pragma mark - button click

- (IBAction)signUpButtonClick:(id)sender {
    [self hideTheKeyboard];
    
    NSString *email = self.emailTextField.text;// 设置邮箱
    if (email == nil || [email isEqualToString:@""]) {
        [self alertNilMessage:@"邮箱不可为空" withTextField:self.emailTextField];
        return;
    }
    self.username = self.displayNameTextField.text;// 设置用户名
    if (self.username == nil || [self.username isEqualToString:@""]) {
        [self alertNilMessage:@"用户名不可为空" withTextField:self.displayNameTextField];
        return;
    }
    NSString *password = self.passwordTextField.text;// 设置密码
    if (password == nil || [password isEqualToString:@""]) {
        [self alertNilMessage:@"密码不可为空" withTextField:self.passwordTextField];
        return;
    }
    if (self.passwordAgainTextField.text == nil || [self.passwordAgainTextField.text isEqualToString:@""]) {
        [self alertNilMessage:@"确认密码不可为空" withTextField:self.passwordAgainTextField];
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.passwordAgainTextField.text]) {
        [self alertNilMessage:@"两次密码不相同" withTextField:self.passwordAgainTextField];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在注册，请稍候"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                                 if (user != nil) {
                                     [self upgradeUserName];
                                 } else {
                                     [SVProgressHUD dismiss];
                                     // 失败的原因可能有多种，常见的是用户名已经存在。
                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                                     [alertController addAction:okAction];
                                     [self presentViewController:alertController animated:YES completion:nil];
                                 }
     }];
}
    
- (void) upgradeUserName {
    FIRUser *user = [FIRAuth auth].currentUser;
    FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
    
    changeRequest.displayName = self.username;
    [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功，但用户名注册失败，您可以在设置中重新设置"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [self performSegueWithIdentifier:@"unwindSegueFromSignUpToMain" sender:self];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [self performSegueWithIdentifier:@"unwindSegueFromSignUpToMain" sender:self];
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
        if (self.displayNameTextField == textField) {
            [self.emailTextField becomeFirstResponder];
        } else if (self.emailTextField == textField) {
            [self.passwordTextField becomeFirstResponder];
        } else if (self.passwordTextField == textField) {
            [self.passwordAgainTextField becomeFirstResponder];
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
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordAgainTextField resignFirstResponder];
    [self.displayNameTextField resignFirstResponder];
}

@end
