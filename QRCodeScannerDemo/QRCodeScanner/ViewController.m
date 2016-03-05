//
//  ViewController.m
//  QRCodeScanner
//
//  Created by Mac on 15/9/1.
//  Copyright (c) 2015年 wjhg. All rights reserved.
//

#import "ViewController.h"
#import "HLQRCodeScanner.h"
#import "HLQRCodeGenerator.h"

#import "WebViewController.h"

#define kScannerMaxY 110
#define kGeneratorMinY 320
#define kDownHeight 200
#define SCREEN_BOUNDS self.view.bounds
#define kScreenWidth SCREEN_BOUNDS.size.width
#define kScreenHeight SCREEN_BOUNDS.size.height

@interface ViewController ()
@property (nonatomic,strong) UIButton * QRCodeScan;
@property (nonatomic,strong) UIButton * QRCodeGenerate;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView * backgroudImg = [[UIImageView alloc]initWithFrame:self.view.frame];
    backgroudImg.image = [UIImage imageNamed:@"星空.jpg"];
    [self.view addSubview:backgroudImg];
    
    self.QRCodeScan                         = [UIButton buttonWithType:UIButtonTypeCustom];
    self.QRCodeScan.frame                   = CGRectMake(kScreenWidth/2-130, -110, 100, 100);
    self.QRCodeScan.backgroundColor         = [UIColor colorWithRed:0.98 green:0.31 blue:0.31 alpha:1];
    self.QRCodeScan.layer.cornerRadius      = self.QRCodeScan.frame.size.width/2;
    self.QRCodeScan.layer.masksToBounds     = YES;
    self.QRCodeScan.backgroundColor         = [UIColor clearColor];
    [self.QRCodeScan setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [self.QRCodeScan addTarget:self action:@selector(captureQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.QRCodeScan];
    
    self.QRCodeGenerate                     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.QRCodeGenerate.frame               = CGRectMake(kScreenWidth/2+50, -110, 100, 100);
    self.QRCodeGenerate.backgroundColor     = [UIColor colorWithRed:0.19 green:0.51 blue:0.85 alpha:1];
    self.QRCodeGenerate.layer.cornerRadius  = self.QRCodeGenerate.frame.size.width/2;
    self.QRCodeGenerate.layer.masksToBounds = YES;
    self.QRCodeGenerate.backgroundColor     = [UIColor clearColor];
    [self.QRCodeGenerate setTitle:@"生成二维码" forState:UIControlStateNormal];
    [self.QRCodeGenerate addTarget:self action:@selector(generateQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.QRCodeGenerate];
    
    
    CGRect frame1 = self.QRCodeScan.frame;
    frame1.origin.y = kDownHeight;
    
    NSLog(@"%@",NSStringFromCGRect(frame1));
    
    [UIView animateWithDuration:3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.QRCodeScan.frame = frame1;
    } completion:^(BOOL finished) {
       
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame2 = self.QRCodeGenerate.frame;
        frame2.origin.y = kDownHeight;
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.QRCodeGenerate.frame = frame2;
            
        } completion:^(BOOL finished) {
            
        }];
    });
   
}

//读取二维码
- (void)captureQRCode:(id)sender {
    HLQRCodeScanner * qrcodeVC = [[HLQRCodeScanner alloc]init];
    qrcodeVC.qrReadSuccess = ^(HLQRCodeScanner *qrVC,NSString *result){
        [qrVC dismissViewControllerAnimated:YES completion:^{}];
        if ([result hasPrefix:@"http"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];

        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"%@",result);
        }
    };
    qrcodeVC.qrReadFailure = ^(HLQRCodeScanner *qrVC){
        [qrVC dismissViewControllerAnimated:YES completion:nil];
    };
    qrcodeVC.qrReadCancel = ^(HLQRCodeScanner *qrVC){
        [qrVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:qrcodeVC animated:YES completion:nil];
}
//生成二维码
- (void)generateQRCode:(id)sender {
    HLQRCodeGenerator * qrcodeGVC = [[HLQRCodeGenerator alloc]init];
    [self presentViewController:qrcodeGVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
