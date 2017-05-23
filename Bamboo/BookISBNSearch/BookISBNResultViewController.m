//
//  BookISBNResultViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/3.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BookISBNResultViewController.h"

@interface BookISBNResultViewController ()

@property int isBook;
@property NSDictionary *bookDetail;

@end

@implementation BookISBNResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBook = 0;
    [self getBookInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - get book information
- (void)getBookInformation {
    NSString *urlStr=[NSString stringWithFormat:@"https://api.douban.com/v2/book/isbn/%@",self.isbnString];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            [self.loading setHidden:YES];
            [self.bookNameLabel setText:@"好像没有网络，请检查后重新扫描"];
            [self.bookNameLabel setHidden:NO];
            self.isBook = 2;
            return;
        }
        NSError *error;
        NSDictionary *bookDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            [self.loading setHidden:YES];
            [self.bookNameLabel setText:@"网络有点差，请检查后重新扫描"];
            [self.bookNameLabel setHidden:NO];
            self.isBook = 2;
        } else {
            [self setData:bookDic];
        }
    }];
}

#pragma mark - set view

- (void)setData:(NSDictionary *)bookDic {
    [self.loading setHidden:YES];
    
    if ([bookDic objectForKey:@"code"] && 6000 == [[bookDic objectForKey:@"code"] intValue]) {
        [self.bookNameLabel setText:@"很抱歉，没有找到图书。"];
        [self.bookNameLabel setHidden:NO];
        self.isBook = 2;
        return;
    }
    
    [self.bookImageView sd_setImageWithURL:[bookDic objectForKey:@"image"]];
    [self.bookImageView setHidden:NO];
    
    [self.bookNameLabel setText:[bookDic objectForKey:@"title"]];
    [self.bookNameLabel setHidden:NO];
    
    [self.authorNameLabel setText:[bookDic objectForKey:@"author"][0]];
    [self.authorNameLabel setHidden:NO];
    
    self.bookDetail = bookDic;
    self.isBook = 1;
}

#pragma mark - button click

- (IBAction)doneButtonClick:(id)sender {
    switch (self.isBook) {
        case 0:
            [self.view makeToast:@"正在获取图书数据，请稍候···" duration:2.0 position:CSToastPositionCenter];
            break;
        case 1:
            [self uploadBook];
            break;
        case 2:
            [self.view makeToast:@"很抱歉，没有找到图书。" duration:2.0 position:CSToastPositionCenter];
            break;
        default:
            break;
    }
}

#pragma mark - upload book

- (void)uploadBook {
    self.book = [AVObject objectWithClassName:@"Book"];
    [self.book setObject:[self.bookDetail objectForKey:@"pages"] forKey:@"pages"];
    [self.book setObject:[self.bookDetail objectForKey:@"title"] forKey:@"title"];
    [self.book setObject:[self.bookDetail objectForKey:@"image"] forKey:@"image"];
    [self.book setObject:[self.bookDetail objectForKey:@"author"][0] forKey:@"author"];
    [self.book setObject:self.isbnString forKey:@"isbn"];
    [self.book setObject:[AVUser currentUser] forKey:@"user"];
    [self.book setObject:@NO forKey:@"done"];
    [SVProgressHUD showWithStatus:@"正在保存，请稍候"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [self.book saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [SVProgressHUD dismiss];
        if (succeeded) {
            [self performSegueWithIdentifier:@"unwindSegueToPublishBambooViewController" sender:self];
        } else {
            [self.view makeToast:@"保存失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

@end
