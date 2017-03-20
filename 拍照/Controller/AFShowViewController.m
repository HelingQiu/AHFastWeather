//
//  AFShowViewController.m
//  AHFastWeather
//
//  Created by Rainer on 15/12/21.
//  Copyright © 2015年 ahqxfw. All rights reserved.
//

#import "AFShowViewController.h"
#import "NSDateFormatter+Category.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "AFPlayVideoViewController.h"

@interface AFShowViewController ()
{
    UILabel *labAddress;
    UILabel *labTime;
    UILabel *labLatLng;
}
@end

@implementation AFShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initlizeBaseView];
}

- (void)initlizeBaseView
{
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0 * 2)];
    [imgView setImage:self.image];
    [imgView setUserInteractionEnabled:YES];
    [self.view addSubview:imgView];
    
    if (self.videoUrl != nil) {
        [imgView setImage:[self getImage]];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setCenter:CGPointMake(UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT_64/3.0)];
        [imageView setImage:ImageNamed(@"ic_video_play")];
        [imageView setUserInteractionEnabled:YES];
        [imgView addSubview:imageView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
        [imgView addGestureRecognizer:tapRecognizer];
        [imageView addGestureRecognizer:tapRecognizer];
    }
    
    UIView *middleView = [[UIView alloc] init];
    [middleView setFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2)];
    [middleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:middleView];
    
    labAddress = [[UILabel alloc] init];
    [labAddress setFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2/2)];
    [labAddress setFont:BoldLabelTextSize(16)];
    [labAddress setTextAlignment:NSTextAlignmentCenter];
    [labAddress setTextColor:mRGB(132, 127, 127)];
    [labAddress setText:self.model.address];
    [middleView addSubview:labAddress];
    
    labTime = [[UILabel alloc] init];
    [labTime setFrame:CGRectMake(0, CGRectGetMaxY(labAddress.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2/2/2)];
    [labTime setFont:LabelTextSize(12)];
    [labTime setTextAlignment:NSTextAlignmentCenter];
    [labTime setTextColor:mRGB(210, 207, 207)];
    [labTime setText:self.model.time];
    [middleView addSubview:labTime];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [labTime setText:dateString];
    
    labLatLng = [[UILabel alloc] init];
    [labLatLng setFrame:CGRectMake(0, CGRectGetMaxY(labTime.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT_64/3.0/2/2/2)];
    [labLatLng setFont:LabelTextSize(12)];
    [labLatLng setTextAlignment:NSTextAlignmentCenter];
    [labLatLng setTextColor:mRGB(210, 207, 207)];
    [labLatLng setText:[NSString stringWithFormat:@"经度：%@  纬度：%@",self.model.lng,self.model.lng]];
    [middleView addSubview:labLatLng];
    
}

- (UIImage *)getImage
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
    
}

- (void)playVideo:(id)sender
{
    AFPlayVideoViewController *playViewController = [[AFPlayVideoViewController alloc] init];
    [playViewController setVideoUrl:self.videoUrl];
    [self presentViewController:playViewController animated:YES completion:nil];
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
