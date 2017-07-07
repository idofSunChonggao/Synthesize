
#ifndef ASDKApi_h
#define ASDKApi_h
#ifdef __OBJC__
#import "error_ios.h"
#import "protocol.h"
#import "Protocol_model.h"
#import "error.h"
#import "vbus.h"
#import "debug.h"
#import "protocol_util.h"
#import "protocol_sync_config.h"
#import "protocol_health.h"
#import "protocol_set_alarm.h"

#include "protocol_health_resolve_sport.h"
#include "protocol_health_resolve_sleep.h"
#include "protocol_health_resolve_heart_rate.h"
#import "ShareDataSdk.h"
#import "ASDKSetting.h"
#import "ASDKGetHandringData.h"
#import "ASDKDeviceEnum.h"
#import "ASDKFounctionOrder.h"
#import "ASDKShareFunction.h"
#import "ASDKBleModule.h"
#import "ASDKCommonOrder.h"
#import "ASDKBLTUUID.h"
#import "AlarmModel.h"
#import "PeripheralModel.h"
#import "DateModelAJ.h"
#import "Protocol_model.h"
#import "ProtocolSportDataModel.h"
#import "ProtocolSleepDataModel.h"
#import "ProtocolHeartRateModel.h"
#import "ProtocolSetAlarmModel.h"
#import "ProtocolSetLongSitModel.h"
#import "ProtocolUserInfoModel.h"
#import "ProtocolLostFindModel.h"
#import "ProtocolUnitModel.h"
#import "ProtocolNoticeModel.h"
#import "IntelligentRemindModel.h"
#import "ProtocolHandGestureModel.h"
#import "ProtocolFindPhoneModel.h"
#import "ProtocolWeekModel.h"
#import "ProtocolMonthModel.h"
#import "ProtocolYearModel.h"
#import "ProtocolComModel.h"
#import "ProtocolUserDeviceModel.h"
#import "ProtocolHRModeModel.h"
#import "ASDKShareControl.h"
#import "ProtocolSOSModel.h"
#import "ProtocolLandsacpeModel.h"
#import "DateTools.h"
#endif


#define SINGLEBANK @"singleBank"
#define SINGLEBANKUPDATASTATE @"singleBankUpdataState"
//升级成功
#define UPDATESUCCESS @"updataSuccess"
//重新升级成功通知
#define REUPDATESUCCESS @"REUPDATESUCCESS"

#endif /* ASDKApi_h */