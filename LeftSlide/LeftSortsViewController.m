//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by 单文昊 on 17/1/14.
//  Copyright 2017年 单文昊. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "otherViewController.h"
#import "MainPageViewController.h"
#import "PersonViewController.h"
#import "FuncVC.h"
#import "ShutdownViewController.h"
#import "PowerViewController.h"
#import "GoodsViewController.h"
#import "BarcodeViewController.h"
#import "QRCodeController.h"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.backgroundColor = [UIColor colorWithRed:64 green:172 blue:250 alpha:1];
    
    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    UIImageView * headicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headimage.png"]];
    headicon.frame = CGRectMake(self.view.bounds.size.width/3-50,tableview.frame.origin.y/2+40,100,100);
    //headicon.layer.borderWidth = 2.5;
    //headicon.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:headicon];
    
    UILabel *user = [[UILabel alloc] init];
    user.frame = CGRectMake(headicon.frame.origin.x-20, headicon.frame.origin.y+105, 140, 20);
    user.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"manName"];
    user.textColor =[UIColor whiteColor];
    user.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:user];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        /*cell.imageView.image= [UIImage imageNamed:@"cellimage.png"];
        CGSize itemSize = CGSizeMake(cell.imageView.image.size.width *2/3, cell.imageView.image.size.height *2/3);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();*/
        
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
//        label.backgroundColor = [UIColor clearColor];
//        label.text = @"  应急物资系统";
//        label.textColor = [UIColor whiteColor];
//        [cell.contentView addSubview:label];
        cell.textLabel.text = @"库存情况查询";
        cell.imageView.image= [UIImage imageNamed:@"goods.png"];
        CGSize itemSize = CGSizeMake(cell.imageView.image.size.width *2/3, cell.imageView.image.size.height *2/3);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if([[[NSUserDefaults standardUserDefaults]valueForKey:@"userType"] isEqualToString:@"notMan"])
        {
            cell.hidden = YES;
        }
        
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"个人领用情况";
        cell.imageView.image= [UIImage imageNamed:@"person.png"];
        CGSize itemSize = CGSizeMake(cell.imageView.image.size.width *2/3, cell.imageView.image.size.height *2/3);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else if (indexPath.row == 2) {
        cell.imageView.image= [UIImage imageNamed:@"smart.png"];
        CGSize itemSize = CGSizeMake(cell.imageView.image.size.width *2/3, cell.imageView.image.size.height *2/3);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.textLabel.text = @"手环管理";
    }
    else if (indexPath.row == 3) {
        cell.imageView.image= [UIImage imageNamed:@"power.png"];
        CGSize itemSize = CGSizeMake(cell.imageView.image.size.width *2/3, cell.imageView.image.size.height *2/3);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.textLabel.text = @"低电量提醒";
    }
    else if (indexPath.row == 4) {
        cell.imageView.image= [UIImage imageNamed:@"shutdown.png"];
        CGSize itemSize = CGSizeMake(cell.imageView.image.size.width *2/3, cell.imageView.image.size.height *2/3);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.textLabel.text = @"关机人员信息";
    }
    else if (indexPath.row == 5) {
        cell.imageView.image= [UIImage imageNamed:@"logout.png"];
        CGSize itemSize = CGSizeMake(cell.imageView.image.size.width *2/3, cell.imageView.image.size.height *2/3);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.textLabel.text = @"注销登录";
    }
    else if(indexPath.row == 6)
    {
        cell.imageView.image= [UIImage imageNamed:@"logout.png"];
        CGSize itemSize = CGSizeMake(cell.imageView.image.size.width *2/3, cell.imageView.image.size.height *2/3);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.textLabel.text = @"扫描条形码";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(indexPath.row == 0){
        //个人领用情况
        /*//MainPageViewController *main = [[MainPageViewController alloc] init];
        //self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:main];
        MainPageViewController *main = [[MainPageViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
        self.view.window.rootViewController = nav;
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧
        [tempAppDelegate.mainNavigationController pushViewController:main animated:NO];*/
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54.0/255 green:187.0/255 blue:252.0/255 alpha:1.0]];
        
        GoodsViewController *goodsVC = [[GoodsViewController alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:goodsVC];
        
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        tempAppDelegate.LeftSlideVC = self.LeftSlideVC;
        self.window.rootViewController = self.LeftSlideVC;
        [self.window makeKeyAndVisible];
    }
    else if(indexPath.row == 1){
        //应急物资管理
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54.0/255 green:187.0/255 blue:252.0/255 alpha:1.0]];
        
        PersonViewController *personVC = [[PersonViewController alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:personVC];
        
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        tempAppDelegate.LeftSlideVC = self.LeftSlideVC;
        self.window.rootViewController = self.LeftSlideVC;
        [self.window makeKeyAndVisible];

    }
    else if(indexPath.row == 2){
        //手环管理
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54.0/255 green:187.0/255 blue:252.0/255 alpha:1.0]];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FuncVC *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"mainVC"];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        self.window.rootViewController = self.LeftSlideVC;
        [self.window makeKeyAndVisible];
    }
    else if(indexPath.row == 3){
        //低电量提醒设置
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54.0/255 green:187.0/255 blue:252.0/255 alpha:1.0]];
        
        PowerViewController *power = [[PowerViewController alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:power];
        
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        tempAppDelegate.LeftSlideVC = self.LeftSlideVC;
        self.window.rootViewController = self.LeftSlideVC;
        NSLog(@"leftslide");
        [self.window makeKeyAndVisible];
        
    }
    
    else if(indexPath.row == 4){
        //关机人员信息
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:54.0/255 green:187.0/255 blue:252.0/255 alpha:1.0]];
        
        ShutdownViewController *shutVC = [[ShutdownViewController alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:shutVC];
        
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        tempAppDelegate.LeftSlideVC = self.LeftSlideVC;
        self.window.rootViewController = self.LeftSlideVC;
        [self.window makeKeyAndVisible];
        
    }
    else if(indexPath.row == 5)
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.view.window.rootViewController = nav;
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(indexPath.row == 6)
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        
        QRCodeController *BarVC = [[QRCodeController alloc] init];
        
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:BarVC];
        
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        tempAppDelegate.LeftSlideVC = self.LeftSlideVC;
        self.window.rootViewController = self.LeftSlideVC;
        [self.window makeKeyAndVisible];
    }
//    else{
//        /*//otherViewController *ph = [[otherViewController alloc] init];
//        //self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:ph];
//        otherViewController *other = [[otherViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:other];
//        self.view.window.rootViewController = nav;
//        //tempAppDelegate.mainNavigationController =self.mainNavigationController;
//        //[tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧
//        [tempAppDelegate.mainNavigationController pushViewController:other animated:NO];*/
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.window.backgroundColor = [UIColor whiteColor];
//        [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
//        
//        otherViewController *other = [[otherViewController alloc] init];
//        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:other];
//        
//        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
//        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
//        tempAppDelegate.LeftSlideVC = self.LeftSlideVC;
//        self.window.rootViewController = self.LeftSlideVC;
//        [self.window makeKeyAndVisible];
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
@end
