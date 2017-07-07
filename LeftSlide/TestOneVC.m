//
//  TestOneVC.m
//  SGTopScrollMenu
//
//  Created by Sorgle on 16/8/15.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "TestOneVC.h"
#import "AppDelegate.h"

@interface TestOneVC ()

@end

@implementation TestOneVC

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor yellowColor];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,109,self.view.bounds.size.width,self.view.bounds.size.height)];
    [self.view addSubview:self.webView];
    NSURL *url = [[NSURL alloc]initWithString:@"https://m.baidu.com/?tn=&from=1086k"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
