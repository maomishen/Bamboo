//
//  BOBambooDetailTableViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/2.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOBambooDetailTableViewController.h"

@interface BOBambooDetailTableViewController ()

@end

@implementation BOBambooDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAd];
    self.progressView.dataSource = self;
    self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:12];
    self.progressView.popUpViewAnimatedColors = @[[UIColor flatRedColor], [UIColor flatOrangeColor], [UIColor flatGreenColor]];
    self.progressView.popUpViewCornerRadius = 6.0;
    [self.progressView showPopUpViewAnimated:YES];
    
    self.userName.text = self.bamboo[@"user"][@"displayName"];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:self.bamboo[@"user"][@"headerUrl"]]];
    self.bookName.text = self.bamboo[@"book"][@"title"];
    self.time.text = [self stringFromDate:self.bamboo.createdAt];
    [self setProgress:[self.bamboo[@"page"] intValue] withPages:[self.bamboo[@"book"][@"pages"] intValue]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];// 取消选中
}

#pragma mark - ad load
- (void) loadAd {
    //TODO: 发布时的ID：ca-app-pub-1252972631413140/1300435514
    //测试ID：ca-app-pub-3940256099942544/2562852117
    self.adView.adUnitID = @"ca-app-pub-1252972631413140/1300435514";
    self.adView.rootViewController = self;
    [self.adView loadRequest:[GADRequest request]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"BookInfoPushSegue"]) {
        BOBookInfoViewController *bvc = [segue destinationViewController];
        bvc.book = self.bamboo[@"book"];
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

#pragma mark - ASProgressPopUpViewDelegate & ASProgressPopUpViewDataSource

- (void) setProgress:(int) page withPages:(int) pages {
    self.progressView.progress = (float) page / pages;
}

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    //TODO: i18n
    if (progress < 0.1) {
        s = @"刚刚开始";
    } else if (progress > 0.48 && progress < 0.52) {
        s = @"接近一半了";
    } else if (progress > 0.95 && progress < 1.0) {
        s = @"快完成了";
    } else if (progress >= 1.0) {
        s = @"成功";
    }
    return s;
}

- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}

@end
