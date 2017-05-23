//
//  BOModifyDisplayNameTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOModifyDisplayNameTableViewController.h"

@interface BOModifyDisplayNameTableViewController ()

@end

@implementation BOModifyDisplayNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.displayNameTextField.text = [AVUser currentUser][@"displayName"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - button click

- (IBAction)doneButtonClick:(id)sender {
    [self hideTheKeyboard];
    [[AVUser currentUser] setObject:self.displayNameTextField.text forKey:@"displayName"];
    [[AVUser currentUser] saveInBackground];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - keyboard

- (void)hideTheKeyboard {
    [self.displayNameTextField resignFirstResponder];
}

@end
