//
//  UIViewController+StartViewController.m
//  surapazu
//
//  Created by AuraOtsuka on 2016/04/03.
//  Copyright © 2016年 AuraOtsuka. All rights reserved.
//

#import "StartViewController.h"
#import "AURUnlockSlider-Swift.h"
#import "ChooseViewController.h"

@interface StartViewController () <AURUnlockSliderDelegate>

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AURUnlockSlider *unlockSlider = [[AURUnlockSlider alloc] init];
    unlockSlider.frame = CGRectMake(50, 0, self.view.frame.size.width-40, 50);
    unlockSlider.center = CGPointMake(self.view.frame.size.width/2, 200);
    unlockSlider.delegate = self;
    
    //テキストの色
    unlockSlider.sliderTextColor = [UIColor colorWithRed:1 green: 1 blue:1.0 alpha:1.0];
    //テキスト
    unlockSlider.sliderText = @"> Slide to Start";
    //フォント
    unlockSlider.sliderTextFont = [UIFont fontWithName:@"HelveticaNeue-Thin"size:20];
    //スライダーの色
    unlockSlider.sliderColor = [UIColor clearColor];
    //スライダー背景の色
    unlockSlider.sliderBackgroundColor = [UIColor clearColor];
    
    
    
    [self.view addSubview:unlockSlider];

}

//スライドされた時
- (void) unlockSliderDidUnlock: (AURUnlockSlider *)slider {
    ChooseViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"happyhappyme"];
    [self presentViewController:vc animated:YES completion:nil];
    
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

