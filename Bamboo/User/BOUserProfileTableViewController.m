//
//  BOUserProfileTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOUserProfileTableViewController.h"

@interface BOUserProfileTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

    @property NSString *oldHeaderUrlString;
    @property FIRUser *currentUser;
    
@end

@implementation BOUserProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            self.currentUser = user;
            [self loadData];
        } else {
            // No user is signed in.
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];// 取消选中
}

#pragma mark - load data

- (void) loadData {
    self.displayNameLabel.text = self.currentUser.displayName;
    self.userNameLabel.text = self.currentUser.email;
    [self.userHeaderImageView sd_setImageWithURL:self.currentUser.photoURL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 1;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 1) {
//        if ([AVUser currentUser][@"headerUrl"] != nil && ![[AVUser currentUser][@"headerUrl"] isEqualToString:@""]) {
//            self.oldHeaderUrlString = [AVUser currentUser][@"headerUrl"];
//        }
//        //实例化照片选择控制器
//        UIImagePickerController *pickControl=[[UIImagePickerController alloc]init];
//        //设置照片源
//        [pickControl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//        //设置协议
//        [pickControl setDelegate:self];
//        //设置编辑
//        [pickControl setAllowsEditing:YES];
//        //选完图片之后回到的视图界面
//        [self presentViewController:pickControl animated:YES completion:nil];
//    }
}

#pragma mark - button

- (IBAction)logoutButtonClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出" message:@"确定退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSError *error;
        [[FIRAuth auth] signOut:&error];
        if (!error) {
            [self performSegueWithIdentifier:@"unwindSegueFromProfileToMain" sender:self];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登出失败" message:@"登出失败，请重新尝试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *logoutfail = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:logoutfail];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - photo

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    //FIXIT: 调整图像大小崩溃
//    UIImage *image=info[@"UIImagePickerControllerEditedImage"];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
//    [SVProgressHUD showProgress:0 status:@"正在上传，请稍候···"];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            [self saveUser:imageFile.url];
//        } else {
//            [SVProgressHUD dismiss];
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传失败" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//        }
//    } progressBlock:^(NSInteger percentDone) {
//        [SVProgressHUD showProgress:percentDone / 100.0 status:@"正在上传，请稍候···"];
//    }];
}

- (void) saveUser:(NSString *) url {
//    [AVUser currentUser][@"headerUrl"] = url;
//    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        [SVProgressHUD dismiss];
//        if (succeeded) {
//            [self.view makeToast:@"您的头像上传成功" duration:1.0 position:CSToastPositionCenter];
//            if (self.oldHeaderUrlString != nil && ![self.oldHeaderUrlString isEqualToString:@""]) {
//                AVFile *file = [AVFile fileWithURL:self.oldHeaderUrlString];
//                [file deleteInBackgroundWithBlock:nil];
//            }
//            [self loadData];
//        } else {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传失败" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
//        }
//    }];
}

@end
