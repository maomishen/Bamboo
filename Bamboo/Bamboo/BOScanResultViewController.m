//
//  BOScanResultViewController.m
//  Bamboo
//
//  Created by Luna Gao on 16/7/3.
//  Copyright © 2016年 luna.gao. All rights reserved.
//

#import "BOScanResultViewController.h"

@interface BOScanResultViewController ()

@property NSString *reslutString;
@property LBXScanViewStyle *style;

@end

@implementation BOScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.style = [self notSquare];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self drawScanView];
    //不延时，可能会导致界面黑屏并卡住一会
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LBXScanViewStyle*)notSquare
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 4;
    style.photoframeAngleW = 28;
    style.photoframeAngleH = 16;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineStill;
    style.animationImage = [self createImageWithColor:[UIColor redColor]];
    //非正方形
    //设置矩形宽高比
    style.whRatio = 4.3/2.18;
    //离左边和右边距离
    style.xScanRetangleOffset = 30;
    
    return style;
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)showError:(NSString*)str
{
    [self.view makeToast:str duration:2.0 position:CSToastPositionCenter];
}

- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        
        [self.view addSubview:_qRScanView];
    }
    [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
}

//启动设备
- (void)startScan
{
    if ( ![self cameraPemission] )
    {
        [_qRScanView stopDeviceReadying];
        
        [self showError:@"   请到设置隐私中开启本程序相机权限   "];
        return;
    }
    
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
    __weak __typeof(self) weakSelf = self;
    
    
    if (!self.scanObj)
    {
        CGRect cropRect = CGRectZero;
        cropRect = [LBXScanView getScanRectWithPreView:self.view style:_style];
        
        NSString *strCode = AVMetadataObjectTypeQRCode;
        self.scanObj = [[LBXScanNative alloc]initWithPreView:videoView ObjectType:@[strCode] cropRect:cropRect success:^(NSArray<LBXScanResult *> *array) {
            
            [weakSelf scanResultWithArray:array];
        }];
        [self.scanObj setNeedCaptureImage:NO];
    }
    [self.scanObj startScan];
    
    [self.qRScanView stopDeviceReadying];
    [self.qRScanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString* strResult = scanResult.strScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
//    
//    //震动提醒
//    [LBXScanWrapper systemVibrate];
//    //声音提醒
//    [LBXScanWrapper systemSound];
//    
    [self showNextVCWithScanResult:scanResult];
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    [self.view makeToast:strResult duration:2.0 position:CSToastPositionCenter];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    self.reslutString = strResult.strScanned;
    [self performSegueWithIdentifier:@"BookDetailPushSegue" sender:self];
}

- (BOOL)cameraPemission
{
    
    BOOL isHavePemission = YES;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                isHavePemission = NO;
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    return isHavePemission;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BookISBNResultViewController *vc = [segue destinationViewController];
    vc.isbnString = self.reslutString;
}

@end
