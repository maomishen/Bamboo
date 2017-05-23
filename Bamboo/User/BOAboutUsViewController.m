//
//  BOAboutUsViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/18.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOAboutUsViewController.h"

@interface BOAboutUsViewController ()

@end

@implementation BOAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    self.version.text = [NSString stringWithFormat:@"Version %@ (%@)", info[@"CFBundleShortVersionString"], info[@"CFBundleVersion"]];
}

@end
