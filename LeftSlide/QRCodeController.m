//
//  QRCodeController.m
//  eCarry
//  依赖于AVFoundation
//  Created by whde on 15/8/14.
//  Copyright (c) 2015年 Joybon. All rights reserved.
//

#import "QRCodeController.h"
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

#define AUTH_ALERT_TAG (int)281821
#define  ScreenHeight  self.view.bounds.size.height
#define  ScreenWidth   self.view.bounds.size.width
@interface QRCodeController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    int line_tag;
    UIView *highlightView;
    UIImageView *navBarHairlineImageView;
    UILabel *label;
    UIButton *rescan;
    
    UIImageView *leftView;
    UIImageView *rightView;
    UIImageView *upView;
    UIImageView *downView;
    UIImageView *centerView;
    UIImageView *line;
    UILabel *msg;
    UIImageView *setbar;
}
@end

@implementation QRCodeController

/**
 *  @author Whde
 *
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self instanceDevice];
    self.title = @"扫一扫";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    rescan = [[UIButton alloc]initWithFrame:CGRectMake(35, self.view.frame.size.height/2, self.view.frame.size.width - 80, 40)];
    [rescan setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [rescan setTitle:@"重新扫描"  forState:(UIControlStateNormal)];
    [rescan setTitleColor:[UIColor whiteColor]  forState:(UIControlStateNormal)];

    [rescan addTarget:self action:@selector(rescan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rescan];
    rescan.hidden = YES;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10,100, self.view.frame.size.width - 80, 40)];
    label.text = @"  ";
    [self.view addSubview:label];
    
    setbar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgtop.jpg"]];
    setbar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 80);
    setbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    [self.view addSubview:setbar];
    setbar.hidden = YES;
}

- (void)rescan
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    QRCodeController *BarVC = [[QRCodeController alloc] init];
    
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:BarVC];
    
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    tempAppDelegate.LeftSlideVC = self.LeftSlideVC;
    self.window.rootViewController = self.LeftSlideVC;
    [self.window makeKeyAndVisible];
    
}
/**
 *  @author Whde
 *
 *  配置相机属性
 */
- (void)instanceDevice{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    line_tag = 1872637;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView];
    
    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始捕获
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  监听扫码状态-修改扫描动画
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

/**
 *  @author Whde
 *
 *  获取扫码结果
 *
 *  @param captureOutput
 *  @param metadataObjects
 *  @param connection
 */

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //获取到信息后停止扫描:
        [session stopRunning];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1256);
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        //_scanLineImageView.hidden = YES;
        //输出扫描字符串:
        label.text = metaDataObject.stringValue;
        NSLog(@"%@", metaDataObject.stringValue);
        upView.hidden = YES;
        downView.hidden = YES;
        leftView.hidden = YES;
        rightView.hidden = YES;
        centerView.hidden = YES;
        line.hidden = YES;
        msg.hidden = YES;
        setbar.hidden = NO;
        rescan.hidden = NO;
        //移除扫描视图:
        AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.view.layer sublayers] objectAtIndex:0];
        [layer removeFromSuperlayer];
    }
}

/**
 *  @author Whde
 *
 *  未识别(其他)的二维码提示点击"好",继续扫码
 *
 *  @param alertView
 */
- (void)alertViewCancel:(UIAlertView *)alertView{
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  didReceiveMemoryWarning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  @author Whde
 *
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
    //左侧的view
    leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, ScreenHeight)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
    rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 0, 30, ScreenHeight)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
    upView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, ScreenWidth-60, (self.view.center.y-(ScreenWidth-60)/2))];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
    downView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (self.view.center.y+(ScreenWidth-60)/2), (ScreenWidth-60), (ScreenHeight-(self.view.center.y-(ScreenWidth-60)/2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, ScreenWidth-60)];
    centerView.center = self.view.center;
    centerView.image = [UIImage imageNamed:@"scanframe.png"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(upView.frame), ScreenWidth-60, 2)];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"bar.png"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    msg = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(downView.frame), ScreenWidth-60, 60)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:16];
    msg.text = @"将条形码／二维码放入框内,即可自动扫描";
    [self.view addSubview:msg];
}

/**
 *  @author Whde
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    UIView *line2 = [self.view viewWithTag:line_tag];
    line2.hidden = NO;
    CABasicAnimation *animation = [QRCodeController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:ScreenWidth-60-2] rep:OPEN_MAX];
    [line2.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line2 = [self.view viewWithTag:line_tag];
    [line2.layer removeAnimationForKey:@"LineAnimation"];
    line2.hidden = YES;
}

/**
 *  @author Whde
 *
 *  扫码取消button方法
 *
 *  @return
 */
- (void)dismissOverlayView:(id)sender{
    [self selfRemoveFromSuperview];
}

/**
 *  @author Whde
 *
 *  从父视图中移出
 */
- (void)selfRemoveFromSuperview{
    [session removeObserver:self forKeyPath:@"running" context:nil];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"leftlist");
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
        NSLog(@"menubutton");
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
        NSLog(@"menubutton2");
    }
    
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    navBarHairlineImageView.hidden = NO;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    navBarHairlineImageView.hidden = YES;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}

@end
