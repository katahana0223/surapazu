//
//  firstViewController.m
//  surapazu
//
//  Created by 津川 on 2016/02/10.
//  Copyright (c) 2016年 津川. All rights reserved.
//

#import "firstViewController.h"
#import "ChooseViewController.h"

@interface firstViewController ()

@end

@implementation firstViewController

-(IBAction)backbutton:(id)sender
{
    ChooseViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"happyhappyme"];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //3つのボタンの背景に使う色
    UIColor *color = [UIColor colorWithRed:116/255.0 green:186/255.0 blue:208/155.0 alpha:1.0];
    
   //背景の色を"color"にする
    button1.backgroundColor = color;
    button2.backgroundColor = color;
    button3.backgroundColor = color;
    
    //３つのボタンの文字に使う色
    UIColor *mojiColor = [UIColor whiteColor];
    
    //文字の色を指定する
    [button1 setTitleColor:mojiColor forState:UIControlStateNormal ];
    [button2 setTitleColor:mojiColor forState:UIControlStateNormal ];
    [button3 setTitleColor:mojiColor forState:UIControlStateNormal ];
    
    //フォントとサイズ
    UIFont *font  = [UIFont fontWithName:@"スマートフォンUI" size:25];
    
    //フォントとサイズを指定
    button1.titleLabel.font = font;
    button2.titleLabel.font = font;
    button3.titleLabel.font = font;
    
    
    //NavoigationVarの色を変える
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:116/255.0 green:186/255.0 blue:208/155.0 alpha:1.0];
    
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
