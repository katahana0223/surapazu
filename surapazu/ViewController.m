//
//  ViewController.m
//  surapazu
//
//  Created by 津川 on 2015/06/17.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "firstViewController.h"
#import "JTAlertView.h"
#import "StartViewController.h"

static NSInteger const kNumberOfRows = 4;
static NSInteger const kNumberOfColumns = 4;
static NSInteger const kNumberOfPieces = kNumberOfColumns * kNumberOfRows - 1;


@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseImageButton;
@property (weak, nonatomic) IBOutlet UIButton *StartButton;

//③
@property (weak, nonatomic) UIImageView *imageView;
//⑩
@property(strong,nonatomic)NSArray *pieceViews;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)NSDate  *startDate;
@property(assign,nonatomic)CGPoint pointOfBlank;


@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)musibutton:(id)sender
{
    AppDelegate *appDelegete = [[UIApplication sharedApplication] delegate];
    UIImage *sampleImage = appDelegete.selectedImage;
    
    JTAlertView *alertView = [[JTAlertView alloc] initWithTitle:@"" andImage:sampleImage];
    alertView.size = CGSizeMake(280, 280);
    alertView.backgroundShadow = false;
    alertView.titleShadow = false;
    alertView.overlayColor = [UIColor clearColor];
    
    [alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
        [alertView hide];
    }];
    
    [alertView show];
}

-(IBAction)backbutton:(id)sender
{
    firstViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"first"];
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //角丸
    start2ImageButton.layer.masksToBounds = true;
    start2ImageButton.layer.cornerRadius = 5;
    
    // Do any additional setup after loading the view.
    //分割した画像を表示するためのビューを格納する配列
    //11
    NSMutableArray *pieceViews = [NSMutableArray array];
    for (NSInteger i = 0; i < kNumberOfPieces; i++) {
        
        //UIImageViewのインスタンスを作成
        UIImageView *pieceView = [[UIImageView alloc] init];
        
        //mainViewのサブビューとして追加
        [self.mainView addSubview:pieceView];
        
        //配列に追加
        [pieceViews addObject:pieceView];
    }
    
    self.pieceViews = pieceViews;
    
    //④
    [self.view layoutIfNeeded];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.mainView.frame];
    [self.mainView addSubview:imageView];
    self.imageView = imageView;
    
    [self giveMeImage];
}


//⑦
- (void)giveMeImage{
    AppDelegate *appDelegete = [[UIApplication sharedApplication] delegate];
    UIImage *image = appDelegete.selectedImage;
    self.imageView.image = image;
    
    //分割したピースの幅と高さを計算
    CGFloat width = image.size.width / kNumberOfColumns;
    CGFloat height = image.size.height / kNumberOfRows;
    
    for (NSInteger i = 0; i < kNumberOfPieces; i++) {
        //画像を切り出す為の矩形情報を計算
        //12
        CGFloat x = (i % kNumberOfColumns) * width;
        CGFloat y = (i / kNumberOfColumns) * height;
        CGRect rect = CGRectMake(x, y, width, height);
        
        //画像を切り出す(クラス内に書くパターン)
        UIImage *croppedImage = [self cutImage:image withRect:rect];
        
        
        //分割後の画像を設定する為のビューを取得
        UIImageView *pieceView = self.pieceViews[i];
        
        //ビューの座標を設定
        pieceView.frame = [self pieceFrameAtIndex:i];
        
        //ビューに分割後の画像を設定
        pieceView.image = croppedImage;
        
        //ビューの現在位置の表すインデックスをタグをして保持
        pieceView.tag = i;
        
        pieceView.frame = self.imageView.frame;
    }
    
    self.PointOfBlank=CGPointMake(kNumberOfColumns - 1,kNumberOfColumns);
    self.StartButton.hidden = NO;
    
    //UIImagePickerControllerを閉じる
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//②
- (IBAction)performStartButtonAction:(id)sender
{
    //ゲーム中の場合は何もせずに終了
    if ([self isPlaying]) {
        return;
    }
    
    //手前の画像をフェードアウト
    [UIView animateWithDuration:0.5f animations:^{
        //ビューのalpha値をアニメーションさせる事でフェードアウトする
        self.imageView.alpha = 0;
    } completion:^(BOOL finished) {
        //フェードアウトのアニメーション完了後に隠す
        self.imageView.hidden = YES;
    }];
    
    //乱数のシードを設定
    srand (time(0) );
    //ランダムにピースを動かす
    for (NSInteger i = 0; i < 100; i++) {
        NSInteger index = rand() % kNumberOfPieces;
        CGPoint point = [self pointFromIndex:index];
        [self movePieceFromPoint:point withAnimation:NO];
    }
    
    //ゲーム開始時間を保持
    self.startDate = [NSDate date];
    
    //念のためタイマーを止める
    [self.timer invalidate];
    
    //タイマーを作成・作動させて保持する
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(updateTimeLabel)
                                                userInfo:nil
                                                 repeats:YES];
    
    start2ImageButton.hidden = true;
}


-(void)updateTimeLabel
{
    if(![self isPlaying])
        return;
    
    //開始時間から現在までの経過時間を秒単位を習得
    NSUInteger time = (NSUInteger)[[NSDate date] timeIntervalSinceDate:self.startDate];
    
    NSUInteger hour = time /(60 * 60);
    NSUInteger minute = (time % (60 * 60)) /60;
    NSUInteger second = (time % (60 * 60)) % 60;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hour,minute,second];
}


-(BOOL)isSolved
{
    for(NSInteger i = 0; i < kNumberOfPieces; i++){
        UIImageView *pieceView = self.pieceViews[i];
        if(i != pieceView.tag)
            return NO;
    }
    return YES;
}

//②⑤
-(IBAction)performChooseImageButton:(id)sender
{
    if([self isPlaying])
        return;
    
    //⑥
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
    
    
    
}

//13
-(CGPoint)pointFromIndex:(NSInteger)index
{
    return CGPointMake(index % kNumberOfColumns,index / kNumberOfColumns);
}

-(NSInteger)indexFromPoint:(CGPoint)point
{
    return point.y * kNumberOfColumns + point.x;
    
}

-(CGRect)pieceFrameAtIndex:(NSInteger)index
{
    CGPoint point = [self pointFromIndex:index];
    CGFloat width = self.mainView.frame.size.width / kNumberOfColumns;
    CGFloat height = self.mainView.frame.size.width / kNumberOfRows;
    return CGRectMake(point.x * width,point.y * height, width, height);
}
//⑧
-(UIImage *)cutImage:(UIImage *)image withRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage,rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}
-(BOOL)canMovePieceFromPoint:(CGPoint)point
{
    if (CGPointEqualToPoint(self.pointOfBlank, point))
        return NO;
    
    return self.pointOfBlank.x == point.x || self.pointOfBlank.y == point.y;
}

-(void)movePieceFromPoint:(CGPoint)point withAnimation:(BOOL)animation
{
    if (![self canMovePieceFromPoint:point]) {
        return;
    }
    
    // MARK: - 計算あってるかたしかめる
    //移動方向を決定する
    NSInteger step;
    if (self.pointOfBlank.x == point.x)
        step = self.pointOfBlank.y > point.y ? kNumberOfColumns : -kNumberOfColumns;
    else
        step = self.pointOfBlank.x > point.x ? 1 : -1;
    
    //移動対象のピースを格納する配列
    NSMutableArray *targetPieceViews = [NSMutableArray array];
    
    NSInteger indexOfBlank = [self indexFromPoint:self.pointOfBlank];
    NSInteger index = [self indexFromPoint:point];
    
    //移動対象のピースを抽出する
    while (index != indexOfBlank){
        for (UIImageView *pieceView in self.pieceViews){
            if (pieceView.tag == index){
                [targetPieceViews addObject:pieceView];
                break;
            }
            
            NSLog(@"pieceView");
        }
        index += step;
        
    }
    //移動対象のピースを実際に動かす
    //アニメーションが必要な場合は0.2秒かけてアニメーションさせる
    //アニメーションが不要な場合はアニメーション時間を0秒にすることで即座に反映させる
    [UIView animateWithDuration: animation ? 0.2f : 0 animations:^{
        //このブロック内でアニメーション対象のプロパティを変更すると、
        //指定した時間でアニメーションする
        for (UIImageView *pieceView in targetPieceViews){
            pieceView.tag += step;
            pieceView.frame = [self pieceFrameAtIndex:pieceView.tag];
        }
    }];
    self.pointOfBlank = point;
}

- (CGPoint)pointFromIndexpointFromIndex:(NSInteger)index
{
    return CGPointMake(index % kNumberOfColumns, index / kNumberOfColumns);
}

- (BOOL)isPlaying
{
    return self.imageView.hidden;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(![self isPlaying])
        return;
    //タッチを示すオブジェクトを取得
    UITouch *touch = [touches anyObject];
    
    //タッチ情報からタッチ座標を取得
    CGPoint location =[touch locationInView:self.mainView];
    
    //タッチ座標がmain
    if (CGRectContainsPoint(self.mainView.bounds, location)){
        //タッチ座標かr
        CGFloat width = self.mainView.frame.size.width / kNumberOfColumns;
        CGFloat height = self.mainView.frame.size.width / kNumberOfColumns;
        CGPoint point = CGPointMake((int)(location.x / width), (int)(location.y / height));
        
        
        [self movePieceFromPoint:point withAnimation:YES];
        
        if([self isSolved]) {
            self.imageView.hidden = NO;
            [UIView animateWithDuration:0.5f animations:^{
                
                self.imageView.alpha = 1;
            }completion:^(BOOL finished){
                NSString *title = @"ゲームクリア！";
                NSString *message = [NSString stringWithFormat:
                                     @"タイムは %@ です", self.timeLabel.text];
                [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }];
            
            [self.timer invalidate];
            self.timer = nil;
            
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    StartViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"startstart"];
    [self presentViewController:vc animated:YES completion:nil];
    

    
}
@end


