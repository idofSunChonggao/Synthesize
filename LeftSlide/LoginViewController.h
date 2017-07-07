//
//  LoginViewController.h
//  LoginDemo
//
//  Created by aDu on 16/2/23.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "AppDelegate.h"

@interface LoginViewController : UIViewController // UIResponder <UIApplicationDelegate>

@property (nonatomic,strong) UIImageView *imageView;
- (void)login:(UIGestureRecognizer *)gestureRecognizer;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property (nonatomic, strong) UINavigationController *nav;

@end
