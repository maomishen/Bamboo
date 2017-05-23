//
//  BOBookInfoViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/6.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOBookInfoViewController.h"

@interface BOBookInfoViewController ()

@end

@implementation BOBookInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bookNameLabel.text = self.book[@"title"];
    self.authorLabel.text = self.book[@"author"];
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:self.book[@"image"]]];
}

@end
