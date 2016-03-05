//
//  HLQRCodeViewController.h
//  QRCodeScanner
//
//  Created by Mac on 15/9/1.
//  Copyright (c) 2015年 wjhg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLQRCodeScanner;

typedef void(^QRCodeReadCancel) (HLQRCodeScanner *);
typedef void(^QRCodeReadSuccess)(HLQRCodeScanner *,NSString *);
typedef void(^QRCodeReadFailure)(HLQRCodeScanner *);

@interface HLQRCodeScanner : UIViewController

@property (nonatomic,copy)QRCodeReadCancel  qrReadCancel;
@property (nonatomic,copy)QRCodeReadSuccess qrReadSuccess;
@property (nonatomic,copy)QRCodeReadFailure qrReadFailure;

/**
 *  自定义二维码框下方的提示文字
 */
@property (nonatomic,strong)NSString *tipText;
/**
 *  自定义整个二维码视图的颜色
 */
@property (nonatomic,strong)UIColor  *color;

@end
