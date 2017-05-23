//
//  BOMainTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/1.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOMainTableViewController.h"

@interface BOMainTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property NSMutableArray<AVObject *> *bamboos;
@property int skip;
@property int limit;
@property int indexRow;
@property NSString* emptyString;
@property AVObject *bamboo;

@property GADNativeExpressAdView *adView;

@end

@implementation BOMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAd];
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

#pragma mark - ad
- (void)setAd {
    self.adView = [[GADNativeExpressAdView alloc]
                   initWithAdSize:GADAdSizeFullWidthPortraitWithHeight(100.0)];
    self.adView.rootViewController = self;
    
    //TODO: 发布时的ID：ca-app-pub-1252972631413140/8823702317
    //测试ID：ca-app-pub-3940256099942544/2562852117
    self.adView.adUnitID = @"ca-app-pub-1252972631413140/8823702317";
    [self.adView loadRequest:[GADRequest request]];
}

#pragma mark - loadData
- (void)loadNewData {
    self.emptyString = @"";
    [self.tableView reloadEmptyDataSet];
    self.skip = 0;
    AVQuery *query = [AVQuery queryWithClassName:@"Bamboo"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query includeKey:@"book"];
    query.limit = self.limit; // 最多返回 self.limit 条结果
    query.skip = self.skip;  // 跳过 self.skip 条结果
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)loadMoreData {
    AVQuery *query = [AVQuery queryWithClassName:@"Bamboo"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query includeKey:@"book"];
    query.limit = self.limit; // 最多返回 self.limit 条结果
    query.skip = self.skip;  // 跳过 self.skip 条结果
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int adCount = 0;
    if (self.bamboos.count != 0) {
        adCount = (int)ceilf(self.skip / 20);
    }
    return self.bamboos.count + adCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MainIdentifier = @"MainTableCellIdentifier";
    static NSString *AdmobCellIdentifier = @"AdmobTableViewCellIdentifier";
    if (indexPath.row % 21 == 0 || indexPath.row == 0) {
        BOMainAdTableViewCell *cell = (BOMainAdTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AdmobCellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BOMainAdTableViewCell" owner:self options:nil];
            for(id oneObject in nib){
                if([oneObject isKindOfClass:[BOMainAdTableViewCell class]]){
                    cell = (BOMainAdTableViewCell *)oneObject;
                }
            }
        }
        [cell.AdView addSubview:self.adView];
        return cell;
    } else {
        BOMainTableViewCell *cell = (BOMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MainIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BOMainTableViewCell" owner:self options:nil];
            for(id oneObject in nib){
                if([oneObject isKindOfClass:[BOMainTableViewCell class]]){
                    cell = (BOMainTableViewCell *)oneObject;
                }
            }
        }
        int adCount = (int)ceilf(indexPath.row / 21) + 1;
        int index = (int)indexPath.row - adCount;
        cell.userName.text = self.bamboos[index][@"user"][@"displayName"];
        [cell setUserHeaderImage:self.bamboos[index][@"user"][@"headerUrl"]];
        cell.bookName.text = self.bamboos[index][@"book"][@"title"];
        cell.publishTime.text = [self stringFromDate:self.bamboos[index].createdAt];
        [cell setProgress:[self.bamboos[index][@"page"] intValue] withPages:[self.bamboos[index][@"book"][@"pages"] intValue]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 21 == 0 || indexPath.row == 0) {
        return;
    }
    int adCount = (int)ceilf(indexPath.row / 20) + 1;
    self.indexRow = (int)indexPath.row - adCount;
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

#pragma mark - Navigation Item

- (IBAction)navigationItemAddClick:(id)sender {
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        [self performSegueWithIdentifier:@"PublishProgressPushSegue" sender:self];
    } else {
        //TODO: i18n
        [self.view makeToast:@"需要先登录" duration:2.0 position:CSToastPositionCenter];
    }
}

- (IBAction)navigationItemUserClick:(id)sender {
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        [self performSegueWithIdentifier:@"UserPushSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"LoginPushSegue" sender:self];
    }
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

- (IBAction)unwindSegueToMainTableViewController:(UIStoryboardSegue *)segue {
    [self.tableView.mj_header beginRefreshing];
}

@end
