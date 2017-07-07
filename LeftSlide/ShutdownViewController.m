//
//  ShutdownViewController.m
//  枣矿集团应急救援综合平台
//
//  Created by 孙崇高 on 2017/3/1.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import "ShutdownViewController.h"
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import "LoginViewController.h"
#import "PowerViewController.h"
#import "AppDelegate.h"
#import "KxMenu.h"

@interface ShutdownViewController ()

@end
@implementation ShutdownViewController{
    
    UIButton *_btn;
    
}
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关机人员信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn.frame = CGRectMake(5, 80, 30, 30);
    _btn.titleLabel.font = [UIFont systemFontOfSize: 24.0];
    [_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [_btn setTitle:@"+" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0f,0.0f,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:self.webView];
    NSURL *url = [[NSURL alloc]initWithString:@"http://115.159.49.73/zzwz/admin/shutdowninfo"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
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

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"应急号码"
                    image:nil
                   target:self
                   action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"修改密码"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"低电量提醒"
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:@"注销登录"
                     image:nil
                    target:self
                    action:@selector(logout:)],
      
      [KxMenuItem menuItem:@"退出"
                     image:nil
                    target:self
                    action:@selector(exitApplication:)],
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    //AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PowerViewController *power = [[PowerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:power];
    self.view.window.rootViewController = nav;
    //[tempAppDelegate.mainNavigationController pushViewController:power animated:NO];
}

- (void) exitApplication:(id)sender
{
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

- (void)logout:(id)sender
{
    /**
     * 第一种方法
     */
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.view.window.rootViewController = nav;
    
    /**
     * 第二种方法
     
     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     self.view.window.rootViewController = appDelegate.nav;
     */
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}

//几个网页代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    NSLog(@"webViewDidFinishLoad");
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    NSLog(@"DidFailLoadWithError");
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
