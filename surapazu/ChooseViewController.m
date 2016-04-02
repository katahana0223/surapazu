//
//  ChooseViewController.m
//  surapazu
//
//  Created by 津川 on 2016/02/17.
//  Copyright (c) 2016年 津川. All rights reserved.
//

#import "ChooseViewController.h"
#import "level0ViewController.h"
#import "AppDelegate.h"
#import "firstViewController.h"

@interface ChooseViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) UIImage *selectedImage;


@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//画像選ぶボタン
- (IBAction)choosePhoto:(id)sender {
    //⑥
    //アルバムを開く
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
    

    /*UIImagePickerControllerSourceType sourceType
    = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:NULL];
    }*/
}

//写真を選択した時に呼ばれる
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //えらんだ画像をimageに入れる
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    AppDelegate *appDelegete = [[UIApplication sharedApplication] delegate];
    appDelegete.selectedImage = image;
    
    //UIImagePickerControllerを閉じる
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    firstViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"first"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
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
