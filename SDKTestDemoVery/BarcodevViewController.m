//
//  BarcodevViewController.m
//  枣矿集团应急救援综合平台
//
//  Created by Air on 2017/4/11.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import "BarcodeViewController.h"
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface BarcodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UILabel *label;
    UIImageView *navBarHairlineImageView;
    AVCaptureVideoPreviewLayer *layer;
}
@end
@implementation BarcodeViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- 开始扫描
- (void)startScanWithSize:(CGFloat)sizeValue
{
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _scanLineImageView.hidden = NO;
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //判断输入流是否可用
    if (input) {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理,在主线程里刷新,注意此时self需要签AVCaptureMetadataOutputObjectsDelegate协议
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //初始化连接对象
        self.session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        //扫描区域大小的设置:(这部分也可以自定义,显示自己想要的布局)
        layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = CGRectMake((self.view.bounds.size.width - sizeValue) / 2.0, (self.view.bounds.size.height - sizeValue)/4.0, sizeValue, sizeValue);
        [self.view.layer insertSublayer:layer atIndex:0];
        //开始捕获图像:
        [_session startRunning];
    }
}
#pragma mark -- 调用扫描方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关机人员信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    UIImageView *setbar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgtop.jpg"]];
    setbar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 80);
    setbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    [self.view addSubview:setbar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //300为正方形扫描区域边长
    [self startScanWithSize:200];
    label = [[UILabel alloc] initWithFrame:CGRectMake(10,50, self.view.frame.size.width - 80, 40)];
    label.text = @"  ";
    [self.view addSubview:label];
    if (!_scanLineImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar.png"]];
        imageView.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, layer.frame.size.width, 3);
        [self.view addSubview:imageView];
        
        _scanLineImageView = imageView;
    }
    [self animationScan];

}
#pragma mark - 扫描结果在这个代理方法里获取到
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //获取到信息后停止扫描:
        [_session stopRunning];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1256);
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        _scanLineImageView.hidden = YES;
        //输出扫描字符串:
        label.text = metaDataObject.stringValue;
        NSLog(@"%@", metaDataObject.stringValue);
        //移除扫描视图:
        AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.view.layer sublayers] objectAtIndex:0];
        [layer removeFromSuperlayer];
    }
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

#pragma mark -/** * 扫描动画 */
- (void)animationScan
{
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateScanLineFrame) userInfo:nil repeats:YES];
}
bool upMove;/** * 更新线的坐标 */
- (void)updateScanLineFrame
{
    if (self.scanLineImageView.frame.origin.y <=200)
    { //向下移动
        upMove = NO;
    }
    else if(self.scanLineImageView.frame.origin.y >= 400)
    { //向上移动
        upMove = YES;
    }
    CGRect frame = self.scanLineImageView.frame;
    if (upMove)
    {
        frame.origin.y--;
    }
    else
    {
        frame.origin.y++;
    }
    //重新修改坐标
    self.scanLineImageView.frame = frame;
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
