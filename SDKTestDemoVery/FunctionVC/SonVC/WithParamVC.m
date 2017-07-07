//
//  WithParamVC.m
//  SDKTestDemoVery
//
//  Created by aiju_huangjing1 on 16/8/17.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "WithParamVC.h"

@interface WithParamVC ()<UITextFieldDelegate>

@end

@implementation WithParamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
   

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 设置UI
- (void)createUI{
    
    _theTextField.delegate = self;
    switch (_type) {
        case 1:
        {
            _switchB.hidden = YES;
            _switchLabel.hidden = YES;
            self.title = @"按日期获取运动睡眠心率";
        }
            break;
        case 2:
        {
            _switchB.hidden = YES;
            _switchLabel.hidden = YES;
            self.title = @"按日期获取周月年数据";
        }
            break;
        case 3:
        {
            ASDKFounctionOrder* ASDG = [[ASDKFounctionOrder alloc] init];
            IntelligentRemindModel*inteModel = [ASDG ASDKGetIntelligentRemindModel ];
            if (!inteModel) {
                inteModel = [[IntelligentRemindModel alloc] init];
            }

            _theFuncBtn.hidden = YES;
            _theTextField.placeholder = @"延迟时间 例：5";
            _switchB.on = inteModel.IntelligentRemindCallRemind;
            self.title = @"设置来电提醒";
        }
            break;
        case 4:{
            ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
            ProtocolFindPhoneModel *find = [ASDG ASDKDetFindPhoneModel];
            _theFuncBtn.hidden = YES;
            _theTextField.hidden = YES;
            _switchB.on = find.is_open;
            self.title = @"设置寻找手机";

            
        }
            break;
        case 5:{
            ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
            ProtocolHandGestureModel *find = [ASDG ASDKGetHandGestureModel];
            _theFuncBtn.hidden = YES;
            _switchB.on = find.isOpen;
            self.title = @"设置抬腕识别";
            
            
        }
            break;
        case 6:{
            ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
            ProtocolLostFindModel *find = [ASDG ASDKGetLostFindModel];
            _theFuncBtn.hidden = YES;
            _theTextField.hidden =YES;
            _switchB.on = find.lost_type;
            self.title = @"设置防丢提醒";
        }
            break;
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)func_cliclk_with_param:(id)sender {
    switch (_type) {
        case 1:
        {           
            [self obtainTheDateData];
        }
            break;
        case 2:
        {
          
            [self obtainWeekDYData];
        }
            break;
        default:
            break;
    }
}
#pragma mark 按日期获取运动睡眠心率
- (void)obtainTheDateData{
    if (_theTextField.text.length<=0) {
        _theTextView.text = @"输入为空，或不符合规则";
        return;
    }
    NSString *be = _theTextField.text;
    ASDKGetHandringData* ASDG = [[ASDKGetHandringData alloc] init];
    ProtocolSportDataModel *sport = [ASDG ASDKSendGetSportData:be AndDevicePkId:[ShareDataSdk shareInstance].smart_device_id];
    ProtocolSleepDataModel *sleep = [ASDG ASDKSendGetSleepData:be AndDevicePkId:[ShareDataSdk shareInstance].smart_device_id];
    ProtocolHeartRateModel *heartRate = [ASDG ASDKSendGetHeartrateData:be AndDevicePkId:[ShareDataSdk shareInstance].smart_device_id];
    NSString *descrip = [NSString stringWithFormat:@"运动：\n%@\n%@\n 睡眠：\n%@\n%@\n 心率：%@\n%@\n",[sport description],[sport.sportItem description],[sleep description],[sleep.SleepItemArray description],[heartRate description],[heartRate.HeartRateArray description]];
    _theTextView.text = descrip;
}
#pragma mark 按日期获取周月年数据
- (void)obtainWeekDYData{
    if (_theTextField.text.length<=0) {
        _theTextView.text = @"输入为空，或不符合规则";
        return;
    }
    NSString *be = _theTextField.text;
    NSDateFormatter *datefor = [[NSDateFormatter alloc] init];
    [datefor setDateFormat:@"yyyyMMdd"];
    NSDate *date = [datefor dateFromString:be];
    
    ASDKGetHandringData* ASDG = [[ASDKGetHandringData alloc] init];
    
    ProtocolWeekModel *week = [ASDG ASDKCalculateWeekDataWithDate:date ];
    
    ProtocolMonthModel *month = [ASDG ASDKCalculateMonthDataForWithDate:date];
    
    ProtocolYearModel *year = [ASDG ASDKCalculateYearDataForWithDate:date];
    
    NSString *descrip = [NSString stringWithFormat:@"周：\n%@\n%@\n 月：\n%@\n%@\n 年：%@\n%@\n",[week description],[week.sportDic  description],[month description],[month.sportDic description],[year description],[year.monthDataArray description]];
    
    _theTextView.text = descrip;
}
#pragma mark 设置来电提醒
- (void)SetCallRemind:(BOOL)isOpen{
    ASDKFounctionOrder *ASDG= [[ASDKFounctionOrder alloc] init];
    [ASDG ASDKSendSetCallRemind:isOpen AndDelay:[_theTextField.text intValue] WithUpdateBlock:^(id object, int errorCode) {
        if (isOpen) {
            _theTextView.text = @"on";
            [self performSelector:@selector(checkNotify) withObject:nil afterDelay:20.0f];
        }
        else{
            _theTextView.text = @"off";
        }
    }];
    
}
#pragma mark 查询总开关状态
- (void)checkNotify{
    if (!([ShareDataSdk shareInstance].peripheral.state == CBPeripheralStateConnected)) {
        return;
    }
    ASDKFounctionOrder *ASDG_FUN= [[ASDKFounctionOrder alloc] init];
    [ASDG_FUN ASDKSendGetCenterSwitchState:^(id object, int errorCode) {
          BOOL switch_on = [object boolValue];
        if (switch_on) {
            _theTextView.text = @"设置成功";
        }
        
    }];
}
#pragma mark 设置寻找手机
- (void)SetFindPhone:(BOOL)is_open{
    ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
    [ASDG ASDKSendSetFindPhoneType:is_open withUpdateBlock:^(id object, int errorCode) {
        if (errorCode==0) {
            _theTextView.text = @"设置成功";
        }
        
    }];
}
#pragma mark 设置抬腕识别
- (void)SetHandGesture:(BOOL)isOpen{
    ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
    [ASDG ASDKSetHandsup:isOpen ShowSecond:[_theTextField.text intValue] WithUpdateBlock:^(id object, int errorCode) {
        if (errorCode==0) {
            _theTextView.text = @"设置成功";
        }
    }];
}
#pragma mark 设置防丢提醒
- (void)SetLostFind:(BOOL)isOpen{
    ASDKFounctionOrder *ASDG = [[ASDKFounctionOrder alloc] init];
    ProtocolLostFindModel *model = [[ProtocolLostFindModel alloc] init];
    model.lost_type = isOpen;
    [ASDG ASDKSendLostWithUpdateBlockState:model WithUpdateBlock:^(id object, int errorCode) {
        if (errorCode==0){
            _theTextView.text = @"设置成功";
        }
        
    }];
}


#pragma mark UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(obtainLiveData) object:nil];
}
- (IBAction)switch_change_click:(id)sender {
    [_theTextField resignFirstResponder];
    UISwitch *switchC =sender;
    BOOL isOpen = switchC.on;
    switch (_type) {
            /* 设置来电提醒*/
        case 3:
        {
            [self SetCallRemind:isOpen];
        }
            break;
            /* 设置寻找手机*/
        case 4:
        {
            [self SetFindPhone:isOpen];
        }
            break;
            /* 设置抬腕识别*/
        case 5:{
            [self SetHandGesture:isOpen];
        }
            break;
        /* 设置防丢提醒*/
        case 6:{
            [self SetLostFind:isOpen];
        }
            break;

        default:
            break;
    }
}
@end
