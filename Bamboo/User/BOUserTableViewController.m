//
//  BOUserTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/6.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOUserTableViewController.h"

@interface BOUserTableViewController ()

@end

@implementation BOUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            self.userNameLabel.text = user.displayName;
            [self.userHeaderImageView sd_setImageWithURL:user.photoURL];
            
            self.doneNumberLabel.text = @"";
            self.bambooNumberLabel.text = @"";
            self.readingNumberLabel.text = @"";
        } else {
            // No user is signed in.
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];// 取消选中
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    } else {
        return 2;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ReadingBookPushSegue"]) {
        BOBookListTableViewController *dvc = [segue destinationViewController];
        dvc.isDone = NO;
    } else if ([segue.identifier isEqualToString:@"FinishBookPushSegue"]) {
        BOBookListTableViewController *dvc = [segue destinationViewController];
        dvc.isDone = YES;
    }
}

@end
