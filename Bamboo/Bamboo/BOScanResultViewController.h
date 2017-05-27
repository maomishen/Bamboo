//
//  BOScanResultViewController.h
//  Bamboo
//
//  Created by Luna Gao on 16/7/3.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "LBXScanViewStyle.h"
#import <ChameleonFramework/Chameleon.h>
#import "BookISBNResultViewController.h"
#import "LBXScanNative.h"
#import "LBXScanView.h"

@interface BOScanResultViewController : UIViewController

@property (nonatomic,strong) LBXScanView* qRScanView;

@property (nonatomic,strong) LBXScanNative* scanObj;

@end
