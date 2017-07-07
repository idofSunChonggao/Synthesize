//
//  LeftSortsViewController.h
//  LGDeckViewController
//
//  Created by 单文昊 on 17/1/14.
//  Copyright 2017年 单文昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface LeftSortsViewController : UIViewController
@property (nonatomic,strong) UITableView *tableview;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UIWindow *window;

@end
