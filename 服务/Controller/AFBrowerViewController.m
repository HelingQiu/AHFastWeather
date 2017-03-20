//
//  AFBrowerViewController.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/14.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFBrowerViewController.h"

@interface AFBrowerViewController ()

@end

@implementation AFBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64)];
    [self.view addSubview:webView];
    
    [self loadDocument:self.docName inView:webView];
}

-(void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:documentName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
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
