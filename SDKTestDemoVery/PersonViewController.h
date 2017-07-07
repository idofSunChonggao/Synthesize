//
//  PersonViewController.h
//  枣矿集团应急救援综合平台
//
//  Created by Air on 2017/3/1.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewController : UIViewController
{
    UIWebView *webView;
}
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;

@property(strong ,nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIWindow *window;

@end
