//
//  BOPublishBambooTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/3.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOPublishBambooTableViewController.h"

@interface BOPublishBambooTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property NSMutableArray<AVObject *> *books;
@property int pageCount;
@property Boolean canUpload;

@end

@implementation BOPublishBambooTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageCount = 0;
    self.canUpload = NO;
    self.books = [[NSMutableArray alloc] init];
    [self.pageCountPickerView setDataSource:self];
    [self.pageCountPickerView setDelegate:self];
    [self reloadView];
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated {
    [SVProgressHUD dismiss];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];// 取消选中
}

#pragma mark - reload view
- (void)reloadView {
    if (self.book) {
        [self.bookNameLabel setText:self.book[@"title"]];
        [self getPageCount];
    }
}

#pragma mark - get data
- (void)getData {
    AVQuery *query = [AVQuery queryWithClassName:@"Book"];
    [query whereKey:@"done" equalTo:@NO];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (error) {
            [self.view makeToast:@"网络有点小问题，请检查后重试" duration:2.0 position:CSToastPositionCenter];
            return;
        }
        if (objects.count == 0) {
            [self.view makeToast:@"暂无图书，请点击右上角添加" duration:2.0 position:CSToastPositionCenter];
            self.books = nil;
        } else {
            for (AVObject *object in objects) {
                [self.books addObject:object];
            }
            self.book = self.books[0];
            [self reloadView];
        }
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)getPageCount {
    AVQuery *query = [AVQuery queryWithClassName:@"Bamboo"];
    [query whereKey:@"book" equalTo:self.book];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (error) {
            self.pageCount = 0;
            self.canUpload = YES;
            [self.pageCountPickerView reloadAllComponents];
            return;
        }
        if (object) {
            self.canUpload = YES;
            self.pageCount = [object[@"page"] intValue];
            [self.pageCountPickerView reloadAllComponents];
        }
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - pickerView 
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.book) {
        return [self.book[@"pages"] intValue] - self.pageCount;
    } else {
        return 0;
    }
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld", row + 1 + self.pageCount];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - button click

- (IBAction)publishButtonClick:(id)sender {
    if (!self.canUpload) {
        [self.view makeToast:@"请稍等，数据还未接收完。" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    int pageCount = (int)[self.pageCountPickerView selectedRowInComponent:0] + self.pageCount + 1;
    
    AVObject *bamboo = [AVObject objectWithClassName:@"Bamboo"];
    [bamboo setObject:@(pageCount) forKey:@"page"];
    [bamboo setObject:self.book forKey:@"book"];
    [bamboo setObject:[AVUser currentUser] forKey:@"user"];
    [SVProgressHUD showWithStatus:@"正在保存，请稍候"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [bamboo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [SVProgressHUD dismiss];
        if (succeeded) {
            if (pageCount >= [self.book[@"pages"] intValue]) {
                [self.book setObject:@YES forKey:@"done"];
                [self.book saveInBackground];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.view makeToast:@"保存失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - unwind

- (IBAction)unwindSegueToPublishBambooViewController:(UIStoryboardSegue *)segue {
    if ([[segue identifier] isEqualToString:@"unwindSegueToPublishBambooViewController"]) {
        BookISBNResultViewController *isbnVC = [segue sourceViewController];
        self.book = isbnVC.book;
        [self reloadView];
    } else if ([[segue identifier] isEqualToString:@"unwindSegueToPublishBambooViewControllerFromList"]){
        BOSelectBookTableViewController *isbnVC = [segue sourceViewController];
        self.book = isbnVC.book;
        [self reloadView];
    }
}

@end
