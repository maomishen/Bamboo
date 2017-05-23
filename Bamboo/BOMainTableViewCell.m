//
//  BOMainTableViewCell.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/1.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOMainTableViewCell.h"

@implementation BOMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.progressView.delegate = self;
    self.progressView.dataSource = self;
    self.progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:12];
    self.progressView.popUpViewAnimatedColors = @[[UIColor flatRedColor], [UIColor flatOrangeColor], [UIColor flatGreenColor]];
    self.progressView.popUpViewCornerRadius = 6.0;
    [self.progressView showPopUpViewAnimated:YES];
}

- (void) setUserHeaderImage:(NSString *) url {
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void) setProgress:(int) page withPages:(int) pages {
    self.progressView.progress = (float) page / pages;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    [self.completeBg setHidden:YES];
    //TODO: i18n
    if (progress < 0.1) {
        s = @"刚刚开始";
    } else if (progress > 0.48 && progress < 0.52) {
        s = @"接近一半了";
    } else if (progress > 0.95 && progress < 1.0) {
        s = @"快完成了";
    } else if (progress >= 1.0) {
        s = @"成功";
        [self.completeBg setHidden:NO];
    }
    return s;
}

- (void)progressViewWillDisplayPopUpView:(ASProgressPopUpView *)progressView;
{
    [self.superview bringSubviewToFront:self];
}

- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return NO;
}

@end
