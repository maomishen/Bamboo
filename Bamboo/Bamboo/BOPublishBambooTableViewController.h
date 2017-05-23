//
//  BOPublishBambooTableViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/3.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBXScanView.h"
#import <ChameleonFramework/Chameleon.h>
#import "BOScanResultViewController.h"
#import "BookISBNResultViewController.h"
#import "BOSelectBookTableViewController.h"

@interface BOPublishBambooTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIPickerView *pageCountPickerView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;

@property AVObject *book;


@end
