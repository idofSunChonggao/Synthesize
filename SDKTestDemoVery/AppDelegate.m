//
//  AppDelegate.m
//  Veryfit Test
//
//  Created by 孙崇高 on 2017/1/11.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import "AppDelegate.h"
#import "SharePeripheral.h"
#import "Singleton.h"
#import <VeryfitSDK/VeryfitSDK.h>
#import "PowerViewController.h"
#import "LoginViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()
@end

@implementation AppDelegate
@synthesize powerLevel = powerLevel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Override point for customization after application launch.
    ASDKShareFunction *asdk = [[ASDKShareFunction alloc] init];
    [SharePeripheral sharePeripheral];
    //本地通知注册
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        UIUserNotificationSettings* settings=[UIUserNotificationSettings
                                              settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound
                                              categories:nil];
        [application registerUserNotificationSettings:settings];
        
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];   //设置通用背景颜色
    [self.window makeKeyAndVisible];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    self.nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = self.nav;
    
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"title.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    [self bleManager];
    if(timer)
    {
        [timer invalidate];
        timer = nil;
        count = 0;
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
UIBackgroundTaskIdentifier taskId;
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        //结束指定的任务
        [application endBackgroundTask:taskId];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerCheck) name:@"UIDeviceBatteryLevelDidChangeNotification" object:nil];
    }];
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
     [self bleManagerbg];
}
int count = 0;
- (void)timerAction:(NSTimer *)timer {
    
        count++;
        if (count % 500 == 0) {
            UIApplication *application = [UIApplication sharedApplication];
            //结束旧的后台任务
            [application endBackgroundTask:taskId];
            //开启一个新的后台
            taskId = [application beginBackgroundTaskWithExpirationHandler:NULL];
        }
    }

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self bleManager];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://114.215.27.226/zzwz/admin/addshutdowninfo?userid=%@&username=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"manId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"manName"]]];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}
#pragma mark 回调
- (void)bleManager{
    [Protocol_model shareProtocolModel].pncBlock = ^(VBUS_EVT_TYPE type){
        if(type == VBUS_EVT_APP_BLE_TO_APP_FIND_PHONE_START){
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1005);
        }
        else if(type == VBUS_EVT_APP_BLE_TO_APP_ONEKEY_SOS_START){
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"15219467040"];
            //            NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        else if (type==VBUS_EVT_APP_BLE_TO_APP_ANTI_LOST_START) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            AudioServicesPlaySystemSound(1005);
        }
    };
}
- (void)bleManagerbg{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) {
        return;
    }
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 0;
    localNotif.hasAction = NO;
    [Protocol_model shareProtocolModel].pncBlock = ^(VBUS_EVT_TYPE type){
        if(type == VBUS_EVT_APP_BLE_TO_APP_FIND_PHONE_START){
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            localNotif.alertBody = [NSString stringWithFormat:@"寻找手机"];
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
        }
        else if(type == VBUS_EVT_APP_BLE_TO_APP_ONEKEY_SOS_START){
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"15219467040"];
            //            NSLog(@"str======%@",str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
        else if (type==VBUS_EVT_APP_BLE_TO_APP_ANTI_LOST_START) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            localNotif.alertBody = [NSString stringWithFormat:@"手环已远离手机"];
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
        }
    };
}
#pragma mark 低电量提醒
-(void)powerCheck{
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    int level = (int)([myDevice batteryLevel]*100);
    if(level==[[NSUserDefaults standardUserDefaults]valueForKey:@"power"]||level==10||level<=5){
        ASDKSetting *ASDG = [[ASDKSetting alloc] init];
        for(int i=0;i<=5;i++)
            [ASDG ASDKSendDeviceBindingWithCMDType:ASDKDeviceBinding withUpdateBlock:^(int errorCode) {}];
        NSLog(@"LowPower");
    }
    NSLog(@"PowerCheck %d",level);
}
#pragma mark 发送心跳包
- (void)connectToServer
{
    [Singleton sharedInstance].socketHost = @"192.168.0.82";// host设定
    [Singleton sharedInstance].socketPort = 49215;// port设定
    // 在连接前先进行手动断开
    [Singleton sharedInstance].socket.userData = SocketOfflineByUser;
    [[Singleton sharedInstance] cutOffSocket];
    // 确保断开后再连，如果对一个正处于连接状态的socket进行连接，会出现崩溃
    [Singleton sharedInstance].socket.userData = SocketOfflineByServer;
    [[Singleton sharedInstance] socketConnectHost];
}


@end
