//
//  LoginViewController.m
//
//  Created by aDu on 16/2/23.
//  Copyright © 2016年 DuKaiShun. All rights reserved.
//

#import "LoginViewController.h"
#import "MainPageViewController.h"
#import "LeftSortsViewController.h"
#import "PersonViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "SBJson.h"

//toast尺寸设置
#define aiScreenWidth [UIScreen mainScreen].bounds.size.width
#define aiScreenHeight [UIScreen mainScreen].bounds.size.height
#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TAB_BAR_HEIGHT self.tabBarController.tabBar.frame.size.height

@interface LoginViewController (){
    
    UIButton *_btn;
    //登录按钮
    UIImageView *buttonView;
    UILabel *login;
    NSDictionary *resultDic2;
    //用户名
    UIImageView *userView;
    UITextField  *UserName;
    
    //密码
    UIImageView *passwordView;
    UITextField  *UserPaw;
    
    //记住密码
    UIButton *rempsdbtn;
    
    //自动登录
    UIButton *autologinbtn;
    UIView * myView;
    UIButton * myButton;
    BOOL isMan;
    NSURL *url;

}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //背景
    UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    bgView.frame = CGRectMake(0.0f,0.0f,self.view.bounds.size.width,self.view.bounds.size.height);
    [self.view addSubview:bgView];
    
    //登录按钮
    buttonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button.png"]];
    buttonView.frame = CGRectMake(35, self.view.frame.size.height*2/3-30, self.view.frame.size.width - 80, 40);
    buttonView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(login:)];
    [buttonView addGestureRecognizer:singleTap];
    [self.view addSubview:buttonView];
    
    login = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-35, self.view.frame.size.height*2/3-20, buttonView.frame.size.width-100, 20)];
    login.font = [UIFont fontWithName:@"Arial" size:26.0f];
    login.textColor = [UIColor whiteColor];
    login.text = @"登 录";
    [self.view addSubview:login];
    
    //记住密码
    rempsdbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rempsdbtnRect = CGRectMake(buttonView.frame.origin.x, buttonView.frame.origin.y-30, 15, 15);
    [rempsdbtn setFrame:rempsdbtnRect];
    [rempsdbtn setImage:[UIImage imageNamed:@"notchoose.png"] forState:UIControlStateNormal];
    [rempsdbtn setImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
    [rempsdbtn addTarget:self action:@selector(rempsdbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rempsdbtn];
    
    UILabel *rempsd = [[UILabel alloc] initWithFrame:CGRectMake(rempsdbtn.frame.origin.x+15, rempsdbtn.frame.origin.y, 80, 15)];
    rempsd.font = [UIFont fontWithName:@"Arial" size:15.0f];
    rempsd.textColor = [UIColor grayColor];
    rempsd.text = @"记住密码";
    [self.view addSubview:rempsd];
    
    //自动登录
    autologinbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect autologinbtnRect = CGRectMake(rempsdbtn.frame.origin.x+buttonView.frame.size.width-80, rempsdbtn.frame.origin.y, 15, 15);
    [autologinbtn setFrame:autologinbtnRect];
    [autologinbtn setImage:[UIImage imageNamed:@"notchoose.png"] forState:UIControlStateNormal];
    [autologinbtn setImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateSelected];
    [autologinbtn addTarget:self action:@selector(autologinbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autologinbtn];
    
    UILabel *autologin = [[UILabel alloc] initWithFrame:CGRectMake(autologinbtn.frame.origin.x+15, autologinbtn.frame.origin.y, 80, 15)];
    autologin.font = [UIFont fontWithName:@"Arial" size:15.0f];
    autologin.textColor = [UIColor grayColor];
    autologin.text = @"自动登录";
    [self.view addSubview:autologin];
    
    //密码
    passwordView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login3.png"]];
    passwordView.frame = CGRectMake(buttonView.frame.origin.x,rempsdbtn.frame.origin.y-60, buttonView.frame.size.width, 40);
    [self.view addSubview:passwordView];
    
    UserPaw = [[UITextField alloc]initWithFrame:CGRectMake(passwordView.frame.origin.x+40, passwordView.frame.origin.y, buttonView.frame.size.width-40, 40)];
    UserPaw.font = [UIFont fontWithName:@"Arial" size:18.0f];
    UserPaw.clearButtonMode = UITextFieldViewModeAlways;
    UserPaw.returnKeyType = UIReturnKeyDone;
    UserPaw.secureTextEntry = YES;
    UserPaw.placeholder = @"密码";
    [UserPaw addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:UserPaw];
    
    //用户名
    userView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login2.png"]];
    userView.frame = CGRectMake(buttonView.frame.origin.x,passwordView.frame.origin.y-50,buttonView.frame.size.width, 40);
    [self.view addSubview:userView];
    
    UserName = [[UITextField alloc]initWithFrame:CGRectMake(userView.frame.origin.x+40, userView.frame.origin.y, buttonView.frame.size.width-40, 40)];
    UserName.font = [UIFont fontWithName:@"Arial" size:18.0f];
    UserName.clearButtonMode = UITextFieldViewModeAlways;
    UserName.returnKeyType = UIReturnKeyDone;
    UserName.placeholder = @"请输入账号";
    [UserName addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:UserName];
    
    //用户类型
    myButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    myButton.frame = CGRectMake(buttonView.frame.origin.x, userView.frame.origin.y-50, buttonView.frame.size.width, 40);
    [myButton setBackgroundImage:[UIImage imageNamed:@"login1.png"] forState:UIControlStateNormal];
    [myButton setTitle:@"请选择用户类型"  forState:(UIControlStateNormal)];
    [myButton setTitleColor:[UIColor grayColor]  forState:(UIControlStateNormal)];
    myButton.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    myButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [myButton addTarget:self action:@selector(myButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:myButton];
    myView = [[UIView alloc] initWithFrame:(CGRectMake(myButton.frame.origin.x, myButton.frame.origin.y+40, myButton.frame.size.width, 80))];
    myView.backgroundColor = [UIColor whiteColor];
    UIButton * button1 = [[UIButton alloc] initWithFrame:(CGRectMake(40, 0, myView.frame.size.width-40, 40))];
    [button1 setTitle:@"管理用户" forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor grayColor]  forState:(UIControlStateNormal)];
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [button1 addTarget:self action:@selector(button1Action) forControlEvents:(UIControlEventTouchUpInside)];
    UIButton * button2 = [[UIButton alloc] initWithFrame:(CGRectMake(40, 40, myView.frame.size.width-40, 40))];
    [button2 setTitle:@"普通用户" forState:(UIControlStateNormal)];
    [button2 setTitleColor:[UIColor grayColor]  forState:(UIControlStateNormal)];
    button2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [button2 addTarget:self action:@selector(button2Action) forControlEvents:(UIControlEventTouchUpInside)];
    [myView addSubview:button1];
    [myView addSubview:button2];
    myView.hidden = YES;
    [self.view addSubview:myView];
    
    //头像
    UIImageView * headicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headimage.png"]];
    headicon.frame = CGRectMake(self.view.bounds.size.width/2-50,myButton.frame.origin.y/2-50,100,100);
    [self.view addSubview:headicon];

}
- (void)myButtonAction
{
    if (myView.hidden == YES) {
        myView.hidden = NO;
    } else {
        myView.hidden = YES;
    }
}
- (void)button1Action
{
    [myButton setTitle:@"管理用户" forState:(UIControlStateNormal)];
    isMan = YES;
    myView.hidden = YES;
    
}
- (void)button2Action
{
    [myButton setTitle:@"普通用户" forState:(UIControlStateNormal)];
    isMan = NO;
    myView.hidden = YES;
}

//Toast实现
- (void) addToastWithString:(NSString *)string inView:(UIView *)view {
    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    CGRect rect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 32);
    UILabel* label = [[UILabel alloc] initWithFrame:initRect];
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:0.9 alpha:0.6];
    [view addSubview:label];
    //弹出label
    [UIView animateWithDuration:0.5 animations:^{
        label.frame = rect;
    } completion:^ (BOOL finished){
        //弹出后持续1s
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeToastWithView:) userInfo:label repeats:NO];
    }];
}

- (void) removeToastWithView:(NSTimer *)timer {
    UILabel* label = [timer userInfo];
    CGRect initRect = CGRectMake(0, STATUS_BAR_HEIGHT + 44, aiScreenWidth, 0);
    //    label消失
    [UIView animateWithDuration:0.5 animations:^{
        label.frame = initRect;
    } completion:^(BOOL finished){
        [label removeFromSuperview];
    }];
}

- (void)autologinbtn:(UIButton *)sender
{
    //sender.selected=!sender.selected;
    if(!rempsdbtn.selected) {
        if(!sender.selected){
            rempsdbtn.selected = !rempsdbtn.selected;
            sender.selected=!sender.selected;
        }
        else{
            sender.selected=!sender.selected;
        }
    }
    else if(rempsdbtn.selected){
        rempsdbtn.selected = rempsdbtn.selected;
        sender.selected=!sender.selected;
    }
}

- (void)rempsdbtn:(UIButton *)sender
{
    sender.selected=!sender.selected;
}

- (void)login:(UIGestureRecognizer *)gestureRecognizer
{
    if(isMan==YES)
    {
         url = [NSURL URLWithString:[NSString stringWithFormat: @"http://114.215.27.226/zzwz/adminLoginGet?username=%@&password=%@&user1=1",UserName.text,UserPaw.text]];
        if ([[self validate:url over: @"message"] isEqualToString:@"用户名为空"])
        {
            [self addToastWithString:@"请输入用户名" inView:self.view];
        }
        if ([[self validate:url over: @"message"] isEqualToString:@"该用户不存在"])
        {
             [self logInFail:@"该用户不存在"];
        }
        else if ([[self validate:url over: @"message"] isEqualToString:@"密码错误！"]){
            [self logInFail:@"密码错误！"];
        }
        else if ([[self validate:url over: @"message"] isEqualToString:@"成功"])//管理员
        {
            [self addToastWithString:@"登录成功（管理员）" inView:self.view];
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(logInOK) userInfo:nil repeats:NO];
            
            //登录请求 如果成功 保存
            [[NSUserDefaults standardUserDefaults]setValue:UserName.text forKey:@"user"];
            [[NSUserDefaults standardUserDefaults]setValue:UserPaw.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setValue:[self validate:url over:@"data" over: @"manId"] forKey:@"manId"];
            [[NSUserDefaults standardUserDefaults]setValue:[self validate:url over:@"data" over: @"manName"] forKey:@"manName"];
             [[NSUserDefaults standardUserDefaults]setValue:@"isMan" forKey:@"userType"];
            if (rempsdbtn.selected) {
                [[NSUserDefaults standardUserDefaults]setValue:@"rememberpw" forKey:@"rememberpw"];
                
            }
            else if(!rempsdbtn.selected){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            }
            
            if (autologinbtn.selected) {
                [[NSUserDefaults standardUserDefaults]setValue:@"autologin" forKey:@"autologin"];
                
            }
            else if(!autologinbtn.selected){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            }
        }

    
    }
    else if(isMan==NO)
    {
        url = [NSURL URLWithString:[NSString stringWithFormat: @"http://114.215.27.226/zzwz/adminLoginGet?username=%@&password=%@&user1=2",UserName.text,UserPaw.text]];
        if ([[self validate:url over: @"message"] isEqualToString:@"用户名为空"])
        {
            [self addToastWithString:@"请输入用户名" inView:self.view];
        }
        else if ([[self validate:url over: @"message"] isEqualToString:@"该用户不存在"])
        {
            [self logInFail:@"该用户不存在"];
        }
        else if ([[self validate:url over: @"message"] isEqualToString:@"密码错误！"]){
            [self logInFail:@"密码错误！"];
        }
        else if ([[self validate:url over: @"message"] isEqualToString:@"成功"])//普通用户
        {
            [self addToastWithString:@"登录成功（普通用户）" inView:self.view];
            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(logInOK) userInfo:nil repeats:NO];
            
            //登录请求 如果成功 保存
            [[NSUserDefaults standardUserDefaults]setValue:UserName.text forKey:@"user"];
            [[NSUserDefaults standardUserDefaults]setValue:UserPaw.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setValue:[self validate:url over:@"userdata" over: @"manId"] forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]setValue:[self validate:url over:@"userdata" over: @"manName"] forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setValue:@"notMan" forKey:@"userType"];
            if (rempsdbtn.selected) {
                [[NSUserDefaults standardUserDefaults]setValue:@"rememberpw" forKey:@"rememberpw"];
                
            }
            else if(!rempsdbtn.selected){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            }
            
            
            if (autologinbtn.selected) {
                [[NSUserDefaults standardUserDefaults]setValue:@"autologin" forKey:@"autologin"];
                
            }
            else if(!autologinbtn.selected){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            }
        }
    }
    

}
//登录失败
-(void)logInFail:(NSString *)str {
    [self addToastWithString:str inView:self.view];
}

-(void)logInOK{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:81.0/255 green:194.0/255 blue:251.0/255 alpha:1.0]];
     
    PersonViewController *mainVC = [[PersonViewController alloc] init];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.LeftSlideVC = self.LeftSlideVC;
    self.window.rootViewController = self.LeftSlideVC;
    NSLog(@"leftslide");
    [self.window makeKeyAndVisible];
}
-(id)validate:(NSURL *) Url over: (NSString *)key
{
    NSString *str = nil;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:Url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(!data)
    {
        [self addToastWithString:@"服务器错误" inView:self.view];
    }
    else
    {
        NSMutableString *dataStr = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [dataStr deleteCharactersInRange:NSMakeRange([dataStr length]-1, 1)];
        [dataStr deleteCharactersInRange:NSMakeRange(0, 1)];
        NSString *character = nil;
        for (int i = 0; i < dataStr.length; i ++) {
            character = [dataStr substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\\"])
                [dataStr deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        NSLog(@"str-%@",dataStr);
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dict = [jsonParser objectWithString:dataStr];
        str = [dict objectForKey:key];
        
        NSLog(@"%@",str);
    }
    
    return str;
}
-(id)validate:(NSURL *) Url over: (NSString *)key1 over: (NSString *)key2
{
    NSString *str =nil;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:Url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(!data)
    {
        [self addToastWithString:@"服务器错误" inView:self.view];
    }
    else
    {
        NSMutableString *dataStr = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [dataStr deleteCharactersInRange:NSMakeRange([dataStr length]-1, 1)];
        [dataStr deleteCharactersInRange:NSMakeRange(0, 1)];
        NSString *character = nil;
        for (int i = 0; i < dataStr.length; i ++) {
            character = [dataStr substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\\"])
                [dataStr deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        NSLog(@"str-%@",dataStr);
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSDictionary *dict = [jsonParser objectWithString:dataStr];
        str = [[dict objectForKey:key1]objectForKey:key2] ;
        
        NSLog(@"%@",str);
  
    }
    return str;
}


- (IBAction) backgroundTap:(id)sender
{
    [UserName resignFirstResponder];
    [UserPaw resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"user"]) {
        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"rememberpw"]) {
            NSLog(@"记住密码");
            UserName.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"user"];
            UserPaw.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"password"];
            rempsdbtn.selected=YES;
            if([[[NSUserDefaults standardUserDefaults]valueForKey:@"userType"] isEqualToString:@"isMan"])
                isMan = YES;
            else
                isMan = NO;
            
            if (([[NSUserDefaults standardUserDefaults]valueForKey:@"autologin"])) {
                NSLog(@"自动登录");
                autologinbtn.selected=YES;
                [self login:nil];
            }
            
        }
    }
}



@end
