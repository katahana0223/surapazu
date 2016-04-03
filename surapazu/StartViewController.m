//
//  UIViewController+StartViewController.m
//  surapazu
//
//  Created by AuraOtsuka on 2016/04/03.
//  Copyright © 2016年 AuraOtsuka. All rights reserved.
//

#import "StartViewController.h"
#import "AURUnlockSlider-Swift.h"

@interface StartViewController () <AURUnlockSliderDelegate>

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AURUnlockSlider *unlockSlider = [[AURUnlockSlider alloc] init];
    unlockSlider.frame = CGRectMake(50, 0, self.view.frame.size.width-30, 50);
    unlockSlider.center = CGPointMake(self.view.frame.size.width/2, 50);
    unlockSlider.delegate = self;
    
    //テキストの色
    unlockSlider.sliderTextColor = [UIColor whiteColor];
    //テキスト
    unlockSlider.sliderText = @"スライド";
    //スライダーの色
    unlockSlider.sliderColor = [UIColor redColor];
    //スライダー背景の色
    unlockSlider.sliderBackgroundColor = [UIColor blueColor];
    
    
    
    [self.view addSubview:unlockSlider];

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

