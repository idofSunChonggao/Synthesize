//
//  ScanVC.m
//  Veryfit Test
//
//  Created by 孙崇高 on 2017/1/23.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import "ScanVC.h"
#import "SharePeripheral.h"
#import "FuncVC.h"

@interface ScanVC ()
{
    NSMutableArray *dataArray;
    NSInteger connectIndex;
    BOOL canStopSearch;
    BOOL isSearchFail;
    UIAlertController *myAlert;
    UIImageView *navBarHairlineImageView;

}
@end

@implementation ScanVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    connectIndex = NSNotFound;
    dataArray = [NSMutableArray array];
    [self hideView];
    
#pragma mark 获取扫描到的设备
    [[SharePeripheral sharePeripheral]setCallBackDataBack:^(NSMutableArray *perArray) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:perArray];
        [_myTableView reloadData];
        [self drawView];
    }];
#pragma mark 显示绑定按钮
    [[SharePeripheral sharePeripheral]setCallBackJump:^{
        self.BindButton.hidden = NO;
    }];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

#pragma mark 正在扫描
- (void)hideView
{
    self.BindButton.hidden = YES;
    _Search.text = @"设备搜寻中";
    self.myTableView.hidden = YES;
    [_ActivityIndicator startAnimating];
    canStopSearch = YES;
    isSearchFail = YES;
    [_ScanButton setTitle:@"停止" forState:UIControlStateNormal];
    [self performSelector:@selector(SearchFail) withObject:nil afterDelay:5.0f];
    
}
#pragma mark 扫描完成
- (void)drawView
{
    self.ScanButton.hidden = NO;
    self.myTableView.hidden = NO;
    [_ActivityIndicator stopAnimating];
    _ActivityIndicator.hidden = YES;
    [_ScanButton setTitle:@"刷新" forState:UIControlStateNormal];
    isSearchFail = NO;
    canStopSearch = NO;
}
#pragma mark 扫描失败
- (void)SearchFail
{
    if(isSearchFail)
    {
        self.ScanButton.hidden = NO;
        _Search.text = @"扫描失败";
        [_ScanButton setTitle:@"刷新" forState:UIControlStateNormal];
        canStopSearch = NO;
        isSearchFail = NO;
        [_ActivityIndicator stopAnimating];
        myAlert = [UIAlertController alertControllerWithTitle:@"未扫描到设备" message:@" 如蓝牙已连接,请忽略设备后重试" preferredStyle:  UIAlertControllerStyleAlert];
        [myAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
        [self presentViewController:myAlert animated:true completion:nil];
        
    }
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    connectIndex = indexPath.row;
    [_myTableView reloadData];
    PeripheralModel *model = dataArray[indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:model.name forKey:kBLE_NAME];
    [[SharePeripheral sharePeripheral]SendConnectDevice:model.UUID];
    [self showAlert:@"正在连接"];
    
}
#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *scan = @"scan";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scan];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:scan];
    }
    if (dataArray.count>0) {
        PeripheralModel *model = dataArray[indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%ld", model.RSSI];
    }
    if (indexPath.row==connectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ScanDevice:(id)sender {
    if ([ShareDataSdk shareInstance].bleMAnager.manager.state != CBCentralManagerStatePoweredOn) {
        [self showAlert:@"蓝牙未打开"];
        return;
    }
    if(canStopSearch)
    {
        [[SharePeripheral sharePeripheral]stopScanDevice];
        [self SearchFail];
        
    }
    else
    {
        connectIndex = NSNotFound;
        [_myTableView reloadData];
        [self hideView];
        [[SharePeripheral sharePeripheral]ScanDevice];
    }
    
}

- (IBAction)BindDevice:(id)sender {
   myAlert = [UIAlertController alertControllerWithTitle:nil message:@"正在绑定" preferredStyle:  UIAlertControllerStyleAlert];
    [self presentViewController:myAlert animated:true completion:nil];
    [self performSelector:@selector(bindFail) withObject:nil afterDelay:10.0f];
    ASDKSetting *ASDG = [[ASDKSetting alloc] init];
    [ASDG ASDKSendDeviceBindingWithCMDType:ASDKDeviceBinding withUpdateBlock:^(int errorCode) {
            if (errorCode==0) {
                [BINDINGED setBOOLValue:YES];
                [myAlert dismissViewControllerAnimated:YES completion:nil];
                myAlert =NULL;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(bindFail) object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
    }];
    
}
- (void)showAlert:(NSString *)_message{
    myAlert = [UIAlertController alertControllerWithTitle:nil message:_message preferredStyle:  UIAlertControllerStyleAlert];
    [self performSelector:@selector(timerFireMethod) withObject:nil afterDelay:2.0f];
    [self presentViewController:myAlert animated:true completion:nil];
}
- (void)bindFail
{
    [myAlert dismissViewControllerAnimated:YES completion:nil];
    myAlert =NULL;
    myAlert = [UIAlertController alertControllerWithTitle:nil message:@"绑定失败，请重试" preferredStyle:  UIAlertControllerStyleAlert];
    [myAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
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
