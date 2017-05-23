//
//  BOMyBambooTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/7.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOMyBambooTableViewController.h"

@interface BOMyBambooTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property NSMutableArray<AVObject *> *bamboos;
@property int skip;
@property int limit;
@property int indexRow;
@property NSString* emptyString;
@property AVObject *bamboo;

@end

@implementation BOMyBambooTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bamboos = [[NSMutableArray alloc] init];
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
    AVQuery *query = [AVQuery queryWithClassName:@"Bamboo"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query includeKey:@"user"];
    [query includeKey:@"book"];
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
        [self.bamboos removeAllObjects];
        for (AVObject *object in objects) {
            [self.bamboos addObject:object];
        }
        if (!self.tableView.mj_footer && objects.count == 20) {
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        }
        self.skip += 20;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    AVQuery *query = [AVQuery queryWithClassName:@"Bamboo"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query includeKey:@"user"];
    [query includeKey:@"book"];
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
            [self.bamboos addObject:object];
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
    return self.bamboos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MainIdentifier = @"MainTableCellIdentifier";
    
        BOMainTableViewCell *cell = (BOMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MainIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BOMainTableViewCell" owner:self options:nil];
            for(id oneObject in nib){
                if([oneObject isKindOfClass:[BOMainTableViewCell class]]){
                    cell = (BOMainTableViewCell *)oneObject;
                }
            }
        }
        int index = (int)indexPath.row;
        cell.userName.text = self.bamboos[index][@"user"][@"displayName"];
        [cell setUserHeaderImage:self.bamboos[index][@"user"][@"headerUrl"]];
        cell.bookName.text = self.bamboos[index][@"book"][@"title"];
        cell.publishTime.text = [self stringFromDate:self.bamboos[index].createdAt];
        [cell setProgress:[self.bamboos[index][@"page"] intValue] withPages:[self.bamboos[index][@"book"][@"pages"] intValue]];
        
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexRow = (int)indexPath.row;
    self.bamboo = self.bamboos[self.indexRow];
    [self performSegueWithIdentifier:@"BambooDetailPushSegue" sender:self];
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
    NSString *text = @"载入中，请稍候";
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BambooDetailPushSegue"]) {
        BOBambooDetailTableViewController *dvc = [segue destinationViewController];
        dvc.bamboo = self.bamboo;
    }
}

#pragma mark - unwind

- (IBAction)unwindSegueToMyBambooViewController:(UIStoryboardSegue *)segue {}

@end
