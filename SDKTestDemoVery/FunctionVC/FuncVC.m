//
//  FuncVC.m
//  Veryfit Test
//
//  Created by 孙崇高 on 2017/1/23.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import "FuncVC.h"
#import "ScanVC.h"
#import "Singleton.h"
#import "AppDelegate.h"
#import "LeftSortsViewController.h"
@interface FuncVC ()
{
    UIImageView *navBarHairlineImageView;
}

@end

@implementation FuncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self SetHandGesture:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerCheck) name:@"UIDeviceBatteryLevelDidChangeNotification" object:nil];
    //[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(powerCheck) userInfo:nil repeats:YES];
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)checkConnectState{
    if ([ShareDataSdk shareInstance].peripheral.state ==CBPeripheralStateConnected) {
        _connectLabel.text = @"手环已连接";
    }
    else if([ShareDataSdk shareInstance].peripheral.state ==CBPeripheralStateDisconnected){
        _connectLabel.text = @"手环已断开";
    }
    if([BINDINGED getBOOLValue]){
        _toScanVCButton.hidden = YES;
         _myTableView.hidden = NO;
           [self obtainMacAddress];
    }
    else{
        _toScanVCButton.hidden = NO;
        _macdressLabel.text = nil;
        _myTableView.hidden = YES;
        _connectLabel.text = @"手环已断开";
    }
        
    [self performSelector:@selector(checkConnectState) withObject:nil afterDelay:1.0f];
}
- (void)viewWillAppear:(BOOL)animated{
    [self checkConnectState];
    [self SetCallRemind:YES];
    [self SetFindPhone:YES];
    [self SetLostFind:YES];
    navBarHairlineImageView.hidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkConnectState) object:nil];
    navBarHairlineImageView.hidden = NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)toScanVC:(id)sender {
    [BINDINGED setBOOLValue:NO];
    [kBLE_UUID setObjectValue:@""];
    if ([ShareDataSdk shareInstance].peripheral.state ==CBPeripheralStateConnected) {
        [[SharePeripheral sharePeripheral].asdkBleModule ASDKSendDisConnectDevice:[ShareDataSdk shareInstance].peripheral];
    }
    [[SharePeripheral sharePeripheral]ScanDevice];
    [self performSegueWithIdentifier:@"next" sender:self];

}
#pragma mark 解绑
- (IBAction)unBindDevice:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"要删除设备吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ASDKSetting *ASDG = [[ASDKSetting alloc] init];
        [ASDG ASDKSendDeviceBindingWithCMDType:ASDKDeviceUnbundling withUpdateBlock:^(int errorCode) {
            if (errorCode==0) {
                [BINDINGED setBOOLValue:NO];
                [self checkConnectState];
            }
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}]];
    [self presentViewController:alert animated:true completion:nil];
}
#pragma mark 获取mac地址
- (void)obtainMacAddress{
    ASDKGetHandringData *ASDG = [[ASDKGetHandringData alloc] init];
    [ASDG ASDKGetServiceMacWithUpdateBlock:^(id object, int errorCode) {
            MacAddModel *model = object;
            _macdressLabel.text = [@"Mac地址:  " stringByAppendingString:model.MacString];
    }];
}
#pragma mark 低电量提醒
-(void)powerCheck{
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    int level = (int)([myDevice batteryLevel]*100);
    if(level==20||level==10||level<=5){
        ASDKSetting *ASDG = [[ASDKSetting alloc] init];
        for(int i=0;i<=5;i++)
        [ASDG ASDKSendDeviceBindingWithCMDType:ASDKDeviceBinding withUpdateBlock:^(int errorCode) {}];
        NSLog(@"LowPower ");
        }
    NSLog(@"PowerCheck %d",level);
    
}
#pragma mark 发送心跳包
- (IBAction)connectToServer:(id)sender
{
    [Singleton sharedInstance].socketHost = nil;// host设定
    [Singleton sharedInstance].socketPort = 0;// port设定
    // 在连接前先进行手动断开
    [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
    [[Singleton sharedInstance] cutOffSocket];
    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    [Singleton sharedInstance].socket.userData = SocketOfflineByServer;
    [[Singleton sharedInstance] socketConnectHost];
}
#pragma mark 设置来电提醒
- (void)SetCallRemind:(BOOL)isOpen{
    ASDKFounctionOrder *ASDG= [[ASDKFounctionOrder alloc] init];
    [ASDG ASDKSendSetCallRemind:isOpen AndDelay:5 WithUpdateBlock:^(id object, int errorCode) {
        if (isOpen) {
            [self performSelector:@selector(checkNotify) withObject:nil afterDelay:20.0f];
        }
    }];
    
}
#pragma mark 查询总开关状态
- (void)checkNotify{
    if (!([ShareDataSdk shareInstance].peripheral.state == CBPeripheralStateConnected)) {
        return;
    }
    ASDKFounctionOrder *ASDG_FUN= [[ASDKFounctionOrder alloc] init];
    [ASDG_FUN ASDKSendGetCenterSwitchState:^(id object, int errorCode) {
        BOOL switch_on = [object boolValue];
        if (switch_on) {
            
        }
        
    }];
}
#pragma mark 设置寻找手机
- (void)SetFindPhone:(BOOL)is_open{
    ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
    [ASDG ASDKSendSetFindPhoneType:is_open withUpdateBlock:^(id object, int errorCode){}];
}
#pragma mark 设置抬腕识别
- (void)SetHandGesture:(BOOL)isOpen{
    ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
    [ASDG ASDKSetHandsup:isOpen ShowSecond:2 WithUpdateBlock:^(id object, int errorCode){}];
}
#pragma mark 设置防丢提醒
- (void)SetLostFind:(BOOL)isOpen{
    ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
    ProtocolLostFindModel *model = [[ProtocolLostFindModel alloc] init];
    model.lost_type = isOpen;
    [ASDG ASDKSendLostWithUpdateBlockState:model WithUpdateBlock:^(id object, int errorCode){}];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    return cell;
}

@end
