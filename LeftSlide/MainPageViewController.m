//
//  MainPageViewController.m
//  LeftSlide
//
//  Created by 单文昊 on 17/1/14.
//  Copyright 2017年 单文昊. All rights reserved.
//

#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "KxMenu.h"
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import "PowerViewController.h"
#import "LoginViewController.h"
#import "SGTopScrollMenu.h"
#import "TestOneVC.h"
#import "TestTwoVC.h"
#import "TestThreeVC.h"

#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名

@interface MainPageViewController ()<SGTopScrollMenuDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SGTopScrollMenu *topScrollMenu;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *titles;


@end

@implementation MainPageViewController{
    
    UIButton *_btn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主页";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    //[self.view addSubview:_btn];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 1.添加所有子控制器
    [self setupChildViewController];
    
    self.titles = @[@"精选", @"电视剧", @"电影"];
    
    self.topScrollMenu = [SGTopScrollMenu topScrollMenuWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    _topScrollMenu.titlesArr = [NSArray arrayWithArray:_titles];
    _topScrollMenu.topScrollMenuDelegate = self;
    [self.view addSubview:_topScrollMenu];
    
    // 创建底部滚动视图
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _titles.count, 0);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    // 开启分页
    _mainScrollView.pagingEnabled = YES;
    // 没有弹簧效果
    _mainScrollView.bounces = NO;
    // 隐藏水平滚动条
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    TestOneVC *oneVC = [[TestOneVC alloc] init];
    [self.mainScrollView addSubview:oneVC.view];
    
    [self.view insertSubview:_mainScrollView belowSubview:_topScrollMenu];

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
      ];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    /*//AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PowerViewController *power = [[PowerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:power];
    self.view.window.rootViewController = nav;
    //[tempAppDelegate.mainNavigationController pushViewController:power animated:NO];*/
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    
    PowerViewController *power = [[PowerViewController alloc] init];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:power];
    
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    tempAppDelegate.LeftSlideVC = self.LeftSlideVC;
    self.window.rootViewController = self.LeftSlideVC;
    NSLog(@"leftslide");
    [self.window makeKeyAndVisible];
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
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    /**
     * 第二种方法
     
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.view.window.rootViewController = appDelegate.nav;
     */
}

- (void)SGTopScrollMenu:(SGTopScrollMenu *)topScrollMenu didSelectTitleAtIndex:(NSInteger)index{
    
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}

// 添加所有子控制器
- (void)setupChildViewController {
    // 精选
    TestOneVC *oneVC = [[TestOneVC alloc] init];
    [self addChildViewController:oneVC];
    
    // 电视剧
    TestTwoVC *twoVC = [[TestTwoVC alloc] init];
    [self addChildViewController:twoVC];
    
    // 电影
    TestThreeVC *threeVC = [[TestThreeVC alloc] init];
    [self addChildViewController:threeVC];

    
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    // 2.把对应的标题选中
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:@(index) userInfo:nil];
    
    // 2.把对应的标题选中
    UILabel *selLabel = self.topScrollMenu.allTitleLabel[index];
    
    [self.topScrollMenu selectLabel:selLabel];
    
    // 3.让选中的标题居中
    //[self.topScrollMenu setupTitleCenter:selLabel];
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

@end
