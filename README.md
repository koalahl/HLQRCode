#HLQRCodeViewController
##A QRCode Scanner using AVFoundation

###Usage:
    1.Add AVFoundation framework.\<br>
    2.Add source files.

```Objective-C
- (IBAction)captureQRCode:(id)sender {
    HLQRCodeViewController * qrcodeVC = [[HLQRCodeViewController alloc]init];
    qrcodeVC.qrReadSuccess = ^(HLQRCodeViewController *qrVC,NSString *result){
        [qrVC dismissViewControllerAnimated:YES completion:^{
        }];
        self.resultLabel.text = result;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    };
    qrcodeVC.qrReadFailure = ^(HLQRCodeViewController *qrVC){
        [qrVC dismissViewControllerAnimated:YES completion:nil];
        self.resultLabel.text = @"读取失败";
    };
    qrcodeVC.qrReadCancel = ^(HLQRCodeViewController *qrVC){
        [qrVC dismissViewControllerAnimated:YES completion:nil];
        self.resultLabel.text = @"取消读取~";
    };
    [self presentViewController:qrcodeVC animated:YES completion:nil];
}
```
