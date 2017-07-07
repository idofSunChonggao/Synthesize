//
//  PersonViewController.m
//  枣矿集团应急救援综合平台
//
//  Created by Air on 2017/3/1.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import "PersonViewController.h"
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import "LoginViewController.h"
#import "PowerViewController.h"
#import "AppDelegate.h"
#import "KxMenu.h"

@interface PersonViewController ()

@end

@implementation PersonViewController
{
    
    UIButton *_btn;
    UIImageView *navBarHairlineImageView;
    UIView * myView;
    
}
@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人领用情况";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //[[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"title.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
//    _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _btn.frame = CGRectMake(5, 80, 50, 50);
//    _btn.titleLabel.font = [UIFont systemFontOfSize: 15.0];
//    [_btn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
//    [_btn setTitle:@"注销" forState:UIControlStateNormal];
//    [_btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn];

    UIImageView *setbar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgtop.jpg"]];
    setbar.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 80);
    setbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    [self.view addSubview:setbar];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0f, setbar.frame.origin.y+80,self.view.bounds.size.width,self.view.bounds.size.height-setbar.frame.size.height)];
    [self.view addSubview:self.webView];
    NSURL *url = [[NSURL alloc]initWithString:@"http://114.215.27.226/zzwz/admin/toDetailProduct"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    //[webView stringByEvaluatingJavaScriptFromString:meta];
    
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
    if (myView.hidden == YES) {
        myView.hidden = NO;
    } else {
        myView.hidden = YES;
    }
}

- (void) pushMenuItem:(id)sender
{
    //AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PowerViewController *power = [[PowerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:power];
    self.view.window.rootViewController = nav;
    //[tempAppDelegate.mainNavigationController pushViewController:power animated:NO];
}

//- (void) exitApplication:(id)sender
//{
//    
//    [UIView beginAnimations:@"exitApplication" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationDelegate:self];
//    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
//    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.window cache:NO];
//    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
//    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
//    self.window.bounds = CGRectMake(0, 0, 0, 0);
//    [UIView commitAnimations];
//}
//
//- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
//{
//    if ([animationID compare:@"exitApplication"] == 0) {
//        exit(0);
//    }
//}

- (void)logout:(id)sender
{
    /**
     * 第一种方法
     */
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.view.window.rootViewController = nav;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
