//
//  WebViewController.m
//  QRCodeScanner
//
//  Created by Mac on 15/9/1.
//  Copyright (c) 2015年 wjhg. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic,strong)UIWebView *web;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(20, 24, 30, 24);
    [back setImage:[UIImage imageNamed:@"bar_back"] forState:UIControlStateNormal];
    [back setBackgroundColor:[UIColor colorWithRed:0.85 green:0.22 blue:0.18 alpha:1]];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL  URLWithString:_url]]];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
