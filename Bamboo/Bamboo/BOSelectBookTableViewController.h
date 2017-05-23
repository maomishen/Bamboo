//
//  BOSelectBookTableViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/15.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import <ChameleonFramework/Chameleon.h>
#import <AVOSCloud/AVOSCloud.h>
#import "UIView+Toast.h"
#import "MJRefresh.h"

@interface BOSelectBookTableViewController : UITableViewController

@property AVObject *book;

@end
