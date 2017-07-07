//
//  SharePeripheral.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/25.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    acceptModelUnknow,
    // 日志输出报告未完成
    acceptModelReport,
    // 日志输出报告完成
    acceptModelReportFinish,
}acceptModelTYPE;

@interface SharePeripheral : NSObject
+ (SharePeripheral *)sharePeripheral;

/*  peripheralNew
 *
 *  连接的设备，目前是单例，唯一的
 */
@property (nonatomic,copy) void(^callBackJump)();

@property (nonatomic,copy) void(^callBackDataBack)(NSMutableArray *);

@property (strong,nonatomic) ASDKBleModule *asdkBleModule;

@property (nonatomic,assign)BOOL needToJump;

@property (nonatomic,assign)acceptModelTYPE accepType;
//扫描设备
- (void)ScanDevice;
//停止扫描
- (void)stopScanDevice;
//连接设备
- (void)SendConnectDevice:(NSString *)uuidString;
//发现服务
- (void)DiscoerService;
- (void)sendDeviceReport;
@end
