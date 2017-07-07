//
//  SharePeripheral.m
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/3/25.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "SharePeripheral.h"
#import <VeryfitSDK/VeryfitSDK.h>
@interface SharePeripheral()<AsdkBleModuleDelegate>
{
    NSMutableArray *peripheralArray;//扫描到的设备数组
}
@end

@implementation SharePeripheral
@synthesize asdkBleModule;
static SharePeripheral*sharePeripheral = nil;
+ (SharePeripheral*)sharePeripheral{
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        sharePeripheral = [[self alloc] init];
    });
    return sharePeripheral;
}
- (id)init{
    self = [super init];
    if (self) {
        peripheralArray =[NSMutableArray array];
        asdkBleModule  = [[ASDKBleModule alloc] init];
        asdkBleModule.delegate = self;
    }
    return self;
}
//扫描设备
- (void)ScanDevice{
    [peripheralArray removeAllObjects];
    NSArray *connectedArray = [[ShareDataSdk shareInstance].bleMAnager.manager retrieveConnectedPeripheralsWithServices:@[[ASDKBLTUUID uartServiceUUID]]];
    if (connectedArray.count>0) {
        for (CBPeripheral *ware in connectedArray) {
            PeripheralModel *model = [[PeripheralModel alloc] init];
            model.name = ware.name;
            model.UUID = ware.identifier.UUIDString;
            model.RSSI = 0;
            [peripheralArray addObject:model];
        }
    }
    [asdkBleModule ASDKSendScanDevice];
    [self performSelector:@selector(stopScanDevice) withObject:nil afterDelay:5.0f];
}

//停止扫描
- (void)stopScanDevice{
    [asdkBleModule ASDKSendStopScanDevice];
}
//连接设备
- (void)SendConnectDevice:(NSString *)uuidString{
    if (uuidString.length>2) {
        [asdkBleModule ASDKSendConnectDevice:uuidString];
    }
    
}
//发现服务
- (void)DiscoerService{
    [asdkBleModule ASDKSendDiscoverServices:[ShareDataSdk shareInstance].peripheral];
}

#pragma mark AsdkBleModuleDelegate
#pragma mark 中央状态更新
- (void)callBackBleManagerState:(CBCentralManagerState)powerState{

}
#pragma mark 发现设备
- (void)ASDKBLEManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    PeripheralModel *model = [[PeripheralModel alloc] init];
    if (ABS([RSSI integerValue])<80&&[[advertisementData objectForKey:@"kCBAdvDataLocalName"] length]>0) {
        for (PeripheralModel *pm in peripheralArray) {
            if ([pm.UUID isEqualToString:peripheral.identifier.UUIDString]) {
                return;
            }
        }
        //  model.peripheral = peripheral;
        model.UUID = peripheral.identifier.UUIDString;
        model.RSSI =ABS([RSSI integerValue]);
        model.name = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
        [peripheralArray addObject:model];
        [self quiteSort:0 and:peripheralArray.count - 1];
        if (_callBackDataBack) {
            _callBackDataBack(peripheralArray);
        }
    }
}
#pragma mark 按远近排序
- (void)quiteSort:(NSInteger)left and:(NSInteger)right {
    if (left >= right) {
        return;
    }
    for (int i = 0; i < peripheralArray.count - 1; i++)
    {
        for (int j = 0; j < peripheralArray.count - 1 - i; j++)
        {
            PeripheralModel *model1 = peripheralArray[j];
            PeripheralModel *model2 = peripheralArray[j +1];
            
            if (model1.RSSI > model2.RSSI)
            {
                PeripheralModel *temp = peripheralArray[j];
                peripheralArray[j] = peripheralArray[j + 1];
                peripheralArray[j + 1] = temp;
            }
        }
    }
}

#pragma mark 连接状态
- (void)ASDKBLEManagerConnectWithState:(BOOL)success andCBCentral:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (success) {
        [self DiscoerService];
    }
    else{
        NSLog(@"连接失败");
    }
}
#pragma mark 断开连接
- (void)ASDKBLEManagerDisConnectWithCBCentral:(CBCentralManager *)central didDisConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (SUCCESS) {
        NSLog(@"断开连接成功");
    }
}
#pragma mark 发现服务
- (void)ASDKBLEManagerDisCoverServices:(BOOL)success Peripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    if (success) {
        for (CBService *service in peripheral.services)
        {
            NSLog(@"Service found with UUID: %@", service.UUID);  //查找特征
            [asdkBleModule ASDKSendDiscoverCharcristic:peripheral];
            
        }
    }
    else{
        NSLog(@"%@",@"发现服务失败");
    }
}
#pragma mark 发现特征
- (void)ASDKBLEManagerDisCoverCharacteristics:(BOOL)success Peripheral:(CBPeripheral *)peripheral service:(CBService *)service error:(NSError *)error{
    if (success) {
        if (![BINDINGED getBOOLValue]) {
             [SharePeripheral sharePeripheral].callBackJump();
        }
    }
}
 
- (void)ASDKBLEManagerHaveReceivedData:(BOOL)success Peripheral:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)charac error:(NSError *)error{
    if (success) {
        
    }
    else{
        NSLog(@"%@",@"获取失败");
    }
}
- (void)callBackReconect:(NSString *)uuidString{
    [self SendConnectDevice:uuidString];
}
- (void)sendDeviceReport{
    UInt8 val[2] = {0x21,0x06};
    NSData *sData = [[NSData alloc] initWithBytes:val length:2];
    [self senderDataToPeripheral:sData];
    
    
}
- (void)writeDataToFile:(NSString *)className fileType:(NSString *)name{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path=documentsDirectory; // 要列出来的目录
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    
    NSString *fiaeNameStr = [NSString stringWithFormat:@"/%ld%ld-%@.txt",[NSDate date].month,[NSDate date].day,name];
    NSString *filePath = [documentsDirectory stringByAppendingString:fiaeNameStr];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //列举目录内容，可以遍历子目录
    
    NSMutableArray *pathArray = [NSMutableArray array];
    
    while((path=[myDirectoryEnumerator nextObject])!=nil)
    {
        if ([path hasSuffix:@".txt"]) {
            [pathArray addObject:path];
        }
    }
    if (pathArray.count>21) {
        for (int i= 0;i<3;i++) {
            [fileManager removeItemAtPath:pathArray[i] error:nil];
        }
    }
    
    if(![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }else {
        NSData *Data = [fileManager contentsAtPath:filePath];
        NSMutableData *write = [NSMutableData dataWithData:Data];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *timeString = [NSString stringWithFormat:@"[%@]:%@", dateString,className];
        [write appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [write appendData:[timeString dataUsingEncoding:NSUTF8StringEncoding]];
        [write writeToFile:filePath atomically:YES];
    }
}

- (void)senderDataToPeripheral:(NSData *)data{
    UInt8 val[20] = {0};
    [data getBytes:&val length:data.length];
    
    NSString *string = [NSString stringWithFormat:@"send %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x %2x", val[0], val[1], val[2], val[3], val[4], val[5], val[6], val[7], val[8], val[9], val[10], val[11], val[12], val[13], val[14], val[15], val[16], val[17],val[18],val[19]];
    NSLog(@"string=%@",string);
    [self writeDataToFile:string fileType:@"braceletDaily"];
    
    CBUUID *serviceUUID = ASDKBLTUUID.uartServiceUUID;
    CBUUID *charaUUID = ASDKBLTUUID.txCharacteristicUUID;
    
    CBService *service = [self searchServiceFromUUID:serviceUUID withPeripheral:[ShareDataSdk shareInstance].peripheral];
    if (!service)
    {
        NSLog(@"service错误");
        return;
    }
    
    CBCharacteristic *chara = [self searchCharacteristcFromUUID:charaUUID withService:service];
    if (!chara)
    {
        NSLog(@"Characteristc错误");
        return;
    }
    
    [asdkBleModule ASDKSendWriteData:data type:CBCharacteristicWriteWithResponse Peripheral:[ShareDataSdk shareInstance].peripheral Characteristic:chara];
}

- (CBService *)searchServiceFromUUID:(CBUUID *)uuid withPeripheral:(CBPeripheral *)peripheral
{
    //    NSLog(@"peripheral.services == %@",peripheral.services);
    for (int i = 0; i < peripheral.services.count; i++)
    {
        CBService *service = peripheral.services[i];
        if ([service.UUID isEqual:uuid])
        {
            return service;
        }
    }
    
    return  nil;
}

- (CBCharacteristic *)searchCharacteristcFromUUID:(CBUUID *)uuid withService:(CBService *)service
{
    for (int i = 0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *chara = service.characteristics[i];
        if ([chara.UUID isEqual:uuid])
        {
            return chara;
        }
    }
    
    return nil;
}


@end
