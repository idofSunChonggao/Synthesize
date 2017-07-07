//
//  PowerViewController.h
//  LeftSlide
//
//  Created by Air on 2017/1/23.
//  Copyright © 2017年 单文昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface PowerViewController : UIViewController
{
       NSString *powerLevel;
}

- (void) openOrCloseLeftList;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (nonatomic, strong) UINavigationController *nav;
+ (PowerViewController *)sharedInstance;

@end
