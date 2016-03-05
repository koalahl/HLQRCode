//
//  HLQRCodeViewController.m
//  QRCodeScanner
//
//  Created by Mac on 15/9/1.
//  Copyright (c) 2015年 wjhg. All rights reserved.
//

#import "HLQRCodeScanner.h"
#import <AVFoundation/AVFoundation.h>

//设备宽/高/坐标
#define kDeviceWidth    [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight   [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame    [UIScreen mainScreen].bounds


#define kQRCodeReaderMinY   120
#define kQRCodeReaderMaxY   360
#define kQRCodeReaderWidth  240
#define kQRCodeReaderHeight 240

@interface HLQRCodeScanner ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic,strong)AVCaptureSession * session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer * previewLayer;

@end

@implementation HLQRCodeScanner

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initQRCodeReader];
    [self setQRReaderPickScope];
    [self startQRCodeReading];
}
//创建一个类似导航栏
- (void)initNav{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    if (self.color) {
        bgView.backgroundColor = self.color;

    }else{
        bgView.backgroundColor = [UIColor colorWithRed:0.85 green:0.23 blue:0.18 alpha:1];
    }
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth/2-50, 24, 100, 30)];
    title.text = @"扫描二维码";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    [bgView addSubview:title];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20, 28, 60, 24);
    [back setImage:[UIImage imageNamed:@"bar_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(cancelQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:back];
    
    [self.view addSubview:bgView];
    
}
- (void)initQRCodeReader{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureInput  *input  = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }
    
    //增加了条形码
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code]];
    //设置读取可视范围
    [output setRectOfInterest:CGRectMake(kQRCodeReaderMinY/KDeviceHeight, (kDeviceWidth - kQRCodeReaderWidth)/2/kDeviceWidth, kQRCodeReaderHeight/KDeviceHeight, kQRCodeReaderWidth/kDeviceWidth)];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _previewLayer.frame = KDeviceFrame;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
}

- (void)setQRReaderPickScope{
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kQRCodeReaderMinY-64)];//80
    upView.alpha = 0.4;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kQRCodeReaderMinY, (kDeviceWidth - kQRCodeReaderWidth) / 2.0, kQRCodeReaderHeight)];
    leftView.alpha = 0.4;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - CGRectGetMaxX(leftView.frame), kQRCodeReaderMinY, CGRectGetMaxX(leftView.frame), kQRCodeReaderHeight)];
    rightView.alpha = 0.4;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    CGFloat space_h = KDeviceHeight - kQRCodeReaderMaxY;
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kQRCodeReaderMaxY, kDeviceWidth, space_h)];
    downView.alpha = 0.4;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    //扫描范围的View
    UIView *scanCropView = [[UIView alloc] initWithFrame:CGRectMake((kDeviceWidth-kQRCodeReaderWidth)/2,kQRCodeReaderMinY,kQRCodeReaderWidth, kQRCodeReaderHeight)];
    
    if (self.color) {
        scanCropView.layer.borderColor = self.color.CGColor;
    }else{
        scanCropView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.23 blue:0.18 alpha:1].CGColor;
    }
    scanCropView.layer.borderWidth = 2.0;
    [self.view addSubview:scanCropView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth/2-120, CGRectGetMaxY(scanCropView.frame)+20, 240, 24)];
    NSString *tip;
    if (_tipText) {
        tip = _tipText;
    }else{
        tip = @"将二维码置于框中即可快速扫描";
    }
    tipLabel.text = tip;
    
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tipLabel];
}
#pragma mark - 开始/停止/取消读取二维码
- (void)startQRCodeReading{
    [self.session startRunning];
}
- (void)stopQRCodeReading{
    [self.session stopRunning];
}
- (void)cancelQRCodeReading{
    [self stopQRCodeReading];
    if (self.qrReadCancel) {
        self.qrReadCancel(self);
    }
}


#pragma mark - 读取结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if ([metadataObjects count]) {
        [self stopQRCodeReading];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        if (stringValue && stringValue.length>0 && ![stringValue isEqualToString:@""]) {
            if (self.qrReadSuccess) {
                self.qrReadSuccess(self,stringValue);
            }
        }else{
            if (self.qrReadFailure) {
                self.qrReadFailure(self);
            }
        }
    }else{
        if (self.qrReadFailure) {
            self.qrReadFailure(self);
        }
    }
}

- (void)dealloc{
    self.session = nil;
    self.previewLayer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
