//
//  PowerViewController.m
//  LeftSlide
//
//  Created by Air on 2017/1/23.
//  Copyright © 2017年 单文昊. All rights reserved.
//

#import "PowerViewController.h"
#import "LoginViewController.h"
#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import <VeryfitSDK/VeryfitSDK.h>
#import "AppDelegate.h"
#import "KxMenu.h"

@interface PowerViewController ()
{
    UILabel *label;
    UIImageView *buttonView;
    UITextField *powerInput;
    UILabel *button;
    UIButton *_btn;
    UIAlertController *myAlert;
    UIImageView *navBarHairlineImageView;

}

@end

@implementation PowerViewController
+(PowerViewController *)sharedInstance
{
    static PowerViewController *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    // Do any additional setup after loading the view.
    self.title = @"低电量提醒";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    UIImageView *setbar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgtop.jpg"]];
    setbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
    [self.view addSubview:setbar];
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    //确定按钮
    buttonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button.png"]];
    buttonView.frame = CGRectMake(35, self.view.frame.size.height*2/3-10, self.view.frame.size.width - 80, 40);
    //打开用户交互
    buttonView.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPowerLevel:)];
    //为图片添加手势
    [buttonView addGestureRecognizer:singleTap];
    [self.view addSubview:buttonView];
    
    button = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-35, self.view.frame.size.height*2/3, buttonView.frame.size.width-100, 20)];
    button.font = [UIFont fontWithName:@"Arial" size:26.0f];
    button.textColor = [UIColor whiteColor];
    button.text = @"确 定";
    [self.view addSubview:button];
    
    //输入
    powerInput = [[UITextField alloc] initWithFrame:CGRectMake(35, buttonView.frame.origin.y-100, buttonView.frame.size.width, buttonView.frame.size.height)];
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"power"])
        powerInput.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"power"];
    else
        powerInput.text = @"20";
    powerInput.clearButtonMode = UITextFieldViewModeAlways;
    powerInput.returnKeyType = UIReturnKeyDone;
    [powerInput addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:powerInput];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(powerInput.frame.origin.x, powerInput.frame.origin.y+powerInput.frame.size.height+1, buttonView.frame.size.width, 1)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    //提示
    label = [[UILabel alloc] initWithFrame:CGRectMake(35, powerInput.frame.origin.y-30, self.view.frame.size.width - 80, 40)];
    label.font = [UIFont fontWithName:@"Arial" size:15.0f];
    label.textColor = [UIColor grayColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = @"请设置低电量值";
    
    label.numberOfLines = 0;//表示label可以多行显示
    label.lineBreakMode = UILineBreakModeCharacterWrap;//换行模式，与上面的计算保持一致
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);//保持原来Label的位置和宽度，只是改变高度。
    [self.view addSubview:label];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sorry_img.png"]];
    image.frame = CGRectMake(self.view.bounds.size.width/2-75,label.frame.origin.y-160,150,155);
    [self.view addSubview:image];



}
- (void) setPowerLevel:(UIGestureRecognizer *)gestureRecognizer{
    [[NSUserDefaults standardUserDefaults]setValue:powerInput.text forKey:@"power"];
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    appDelegate.powerLevel = self.powerLevel;
//    NSLog(@"%@", appDelegate.powerLevel);
    [self showAlert:@"设置成功"];
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

- (IBAction) backgroundTap:(id)sender
{
    [powerInput resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
- (void)showAlert:(NSString *)_message{
    myAlert = [UIAlertController alertControllerWithTitle:nil message:_message preferredStyle:  UIAlertControllerStyleAlert];
    [self performSelector:@selector(timerFireMethod) withObject:nil afterDelay:2.0f];
    [self presentViewController:myAlert animated:true completion:nil];
}
- (void)timerFireMethod{
    [myAlert dismissViewControllerAnimated:YES completion:nil];
    myAlert =NULL;
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

@end
