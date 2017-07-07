//
//  AppDelegate.h
//  Veryfit Test
//
//  Created by 孙崇高 on 2017/1/11.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *powerLevel;
    NSTimer *timer;
    int  count;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (nonatomic, strong) UINavigationController *nav;
@property (assign ,nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (strong,nonatomic) NSString *powerLevel;



@end

