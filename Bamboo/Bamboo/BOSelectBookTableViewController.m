//
//  BOSelectBookTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/15.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOSelectBookTableViewController.h"

@interface BOSelectBookTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property NSMutableArray<AVObject *> *books;
@property int skip;
@property int limit;
@property int indexRow;
@property NSString* emptyString;

@end

@implementation BOSelectBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.books = [[NSMutableArray alloc] init];
    self.emptyString = @"";
    self.skip = 0;
    self.limit = 20;
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];// 取消选中
}

#pragma mark - loadData
- (void)loadNewData {
    self.emptyString = @"";
    [self.tableView reloadEmptyDataSet];
    self.skip = 0;
    AVQuery *query = [AVQuery queryWithClassName:@"Book"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query whereKey:@"done" equalTo:@NO];
    query.limit = self.limit; // 最多返回 self.limit 条结果
    query.skip = self.skip;  // 跳过 self.skip 条结果
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            self.emptyString = @"网络错误，点我再试试";
            [self.tableView reloadEmptyDataSet];
            [self.tableView.mj_header endRefreshing];
            return;
        }
        if (objects.count == 0) {
            self.emptyString = @"没数据啦，点我再试试";
            [self.tableView reloadEmptyDataSet];
            [self.tableView.mj_header endRefreshing];
            return;
        }
        [self.books removeAllObjects];
        for (AVObject *object in objects) {
            [self.books addObject:object];
        }
        self.book = self.books[0];
        if (!self.tableView.mj_footer && objects.count == 20) {
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
        self.skip += 20;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    AVQuery *query = [AVQuery queryWithClassName:@"Book"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query whereKey:@"done" equalTo:@(NO)];
    query.limit = self.limit; // 最多返回 self.limit 条结果
    query.skip = self.skip;  // 跳过 self.skip 条结果
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [self.view makeToast:@"网络开小差啦，再试试" duration:2.0 position:CSToastPositionCenter];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        if (objects.count == 0) {
            self.tableView.mj_footer = nil;
            [self.tableView.mj_footer endRefreshing];
            [self.view makeToast:@"您已浏览到最后啦" duration:2.0 position:CSToastPositionCenter];
            return;
        }
        for (AVObject *object in objects) {
            [self.books addObject:object];
        }
        self.skip += 20;
        [self.tableView.mj_footer endRefreshing];
        if (objects.count != 20) {
            self.tableView.mj_footer = nil;
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifierForFirstRow = @"UITableViewCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifierForFirstRow];
    
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifierForFirstRow];
        
    }
    int index = (int)indexPath.row;
    cell.textLabel.text = self.books[index][@"title"];
    cell.textLabel.textColor = [UIColor flatBlackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexRow = (int)indexPath.row;
    self.book = self.books[self.indexRow];
    [tableView reloadData];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.indexRow){
        return UITableViewCellAccessoryCheckmark;
    }
    else{
        return UITableViewCellAccessoryNone;
    }
}


#pragma mark - Empty Data Source & Delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"main_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    //TODO: i18n
    NSString *text = @"载入中";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    //TODO: i18n
    NSString *text = @"正在从网络中载入数据，请稍候";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor flatWhiteColor];
}

#pragma mark - Empty Data Delegate

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - date
- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma mark - Navigation

- (IBAction)doneButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"unwindSegueToPublishBambooViewControllerFromList" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"BookInfoPushSegue"]) {
//        BOBookInfoViewController *dvc = [segue destinationViewController];
//        dvc.book = self.book;
//    }
}
@end
