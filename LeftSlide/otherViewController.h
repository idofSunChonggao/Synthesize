//
//  otherViewController.h
//  LGDeckViewController
//
//  Created by 单文昊 on 17/1/14.
//  Copyright 2017年 单文昊. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface otherViewController : UIViewController
{
    UIWebView *webView;
}
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;

@property(strong ,nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIWindow *window;

@end
