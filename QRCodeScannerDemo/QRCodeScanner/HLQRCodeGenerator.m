//
//  HLQRCodeGenerator.m
//  QRCodeScanner
//
//  Created by Han liu on 15/9/7.
//  Copyright © 2015年 wjhg. All rights reserved.
//

#import "HLQRCodeGenerator.h"
#import <AssetsLibrary/AssetsLibrary.h>

//设备宽/高/坐标
#define kDeviceWidth    [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight   [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame    [UIScreen mainScreen].bounds

#define kQRCodeScaleRate 20

@interface HLQRCodeGenerator ()<UIActionSheetDelegate>

@property (strong,nonatomic)UITextField * textField;
@property (strong,nonatomic)UIButton    * generatorBtn;
@property (strong,nonatomic)UIImageView * QRCodeImgV;
@property (strong,nonatomic)UISlider    * slider;
@property (strong,nonatomic)CIImage     * qrcodeImg;
@end

@implementation HLQRCodeGenerator

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self initView];
}

//创建一个类似导航栏
- (void)initNav{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    if (self.color) {
        bgView.backgroundColor = self.color;
        
    }else{
        bgView.backgroundColor = [UIColor colorWithRed:0.22 green:0.67 blue:0.94 alpha:1];
    }
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth/2-50, 24, 100, 30)];
    title.text = @"生成二维码";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    [bgView addSubview:title];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20, 28, 60, 24);
    [back setImage:[UIImage imageNamed:@"bar_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(cancelQRCodeGenerating) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:back];
    
    [self.view addSubview:bgView];
    
}

- (void)initView{
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 200, 30)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.placeholder = @"填上你想要转换的文字";
    [self.view addSubview:self.textField];
    
    self.generatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.generatorBtn.frame = CGRectMake(CGRectGetMaxX(self.textField.frame)+10, 100, 80, 30);
    [_generatorBtn setBackgroundColor:[UIColor colorWithRed:0.98 green:0.82 blue:0.1 alpha:1]];
    [_generatorBtn setTitle:@"Go!" forState:UIControlStateNormal];
    [_generatorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_generatorBtn addTarget:self action:@selector(generateQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.generatorBtn];
    
    self.QRCodeImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth/2-100, CGRectGetMaxY(self.textField.frame)+50, 200, 200)];
    self.QRCodeImgV.image = [UIImage imageNamed:@"我的二维码"];
    
    self.QRCodeImgV.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveQRCodeImage:)];
    [self.QRCodeImgV addGestureRecognizer:longPress];
    [self.view addSubview:self.QRCodeImgV];
    
    
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(self.QRCodeImgV.frame)+50, 250, 10)];
    self.slider.hidden = YES;
    [self.view addSubview:self.slider];
}

- (void)generateQRCode{
    
    [self.textField resignFirstResponder];
    
    if ([self.textField.text isEqualToString:@""]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //self.slider.hidden = !self.slider.hidden;
    if (self.qrcodeImg == nil) {
 
        NSData * data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
        CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
        
        self.qrcodeImg = [filter outputImage];
        self.QRCodeImgV.image = [self resizeQRCodeImage];
        [self.generatorBtn setTitle:@"Clear" forState:UIControlStateNormal];
        
    }else{
        
        self.QRCodeImgV.image = nil;
        self.qrcodeImg = nil;
        [self.generatorBtn setTitle:@"Go!" forState:UIControlStateNormal];
        self.slider.hidden = YES;
        
    }
}



- (UIImage *)resizeQRCodeImage{
    CGFloat scaleX = self.QRCodeImgV.frame.size.width / self.qrcodeImg.extent.size.width;
    CGFloat scaleY = self.QRCodeImgV.frame.size.height / self.qrcodeImg.extent.size.height;
    CIImage * transformedImg = [self.qrcodeImg imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    self.qrcodeImg = transformedImg;
    UIImage * imageOut = [UIImage imageWithCIImage:transformedImg];
    return imageOut;
}


- (void)saveQRCodeImage:(UILongPressGestureRecognizer *)gesture{
    //LongPress手势注意这里它是分了状态的
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet * actSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"保存到相册", nil];
        [actSheet showInView:self.view];
        NSLog(@"......");
    }
    
}

#pragma mark -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        [self saveImage];
    }
}

- (void)saveImage{
    NSLog(@"保存到相册");
    __block NSString *msg =nil;
    NSLog(@"%@",self.QRCodeImgV.image);
    CIContext * context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@YES}];
    CGImageRef cgimg = [context createCGImage:self.qrcodeImg fromRect:[self.qrcodeImg extent] ];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgimg metadata:[self.qrcodeImg properties] completionBlock:^(NSURL *assetURL, NSError *error) {
    
        if(error != NULL){
            msg = @"保存图片失败" ;
        }else{
            NSLog(@"%@",assetURL);
            msg = @"保存图片成功" ;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
    }];
    
}

- (void)cancelQRCodeGenerating{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
