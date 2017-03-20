//
//  AFBrowserTxtViewController.m
//  AHFastWeather
//
//  Created by Rainer on 16/8/8.
//  Copyright © 2016年 ahqxfw. All rights reserved.
//

#import "AFBrowserTxtViewController.h"

@interface AFBrowserTxtViewController ()

@end

@implementation AFBrowserTxtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSStringEncoding *useEncodeing = nil;
    
    //带编码头的如utf-8等，这里会识别出来
    
    NSString *body = [NSString stringWithContentsOfFile:self.docName usedEncoding:useEncodeing error:nil];
    
    //识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
    
    if (!body) {
        
        body = [NSString stringWithContentsOfFile:self.docName encoding:0x80000632 error:nil];
        
        NSLog(@"%@",body);
        
    }
    
    //还是识别不到，按GB18030编码再解码一次.
    
    if (!body) {
        
        body = [NSString stringWithContentsOfFile:self.docName encoding:0x80000631 error:nil];
        
        NSLog(@"%@",body);
        
    }
    
    //展现
    
    if (body) {
        
        NSLog(@"%@",body);
    
    }
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64)];
    textView.text = body;
    textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textView];
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
