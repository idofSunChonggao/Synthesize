//
//  MainPageViewController.h
//  LeftSlide
//
//  Created by 单文昊 on 17/1/14.
//  Copyright 2017年 单文昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface MainPageViewController : UIViewController
{
    UIWebView *webView;
}

- (void) openOrCloseLeftList;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;

@property (strong, nonatomic) UIWindow *window;
@property (strong ,nonatomic) UIWebView *webView;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (nonatomic, strong) UINavigationController *nav;


@end