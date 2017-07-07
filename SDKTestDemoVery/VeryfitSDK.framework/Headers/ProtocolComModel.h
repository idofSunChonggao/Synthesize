//
//  ProtocolComModel.h
//  VeryfitSDK
//
//  Created by morris on 16/4/24.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
@interface ProtocolComModel : NSObject
@property (nonatomic, assign) NSInteger week_total_steps;     // 本周的总步数
@property (nonatomic, assign) NSInteger week_total_calories;  // 本周的总卡路里
@property (nonatomic, assign) NSInteger week_total_distance ; // 本周的总路程
@property (nonatomic, assign) NSInteger week_total_sleep;     // 本周的总睡眠时间.

@property (nonatomic, assign) NSInteger daily_steps;         // 日均步数.
@property (nonatomic, assign) NSInteger daily_calories;      // 日均卡路里.
@property (nonatomic, assign) NSInteger daily_distance;      // 日均里程.

@property (nonatomic, assign) NSInteger daily_sleep;          // 日均睡眠.
@property (nonatomic, assign) NSInteger daily_deep_sleep;     // 日均深睡.
@property (nonatomic, assign) NSInteger daily_shallow_sleep;  // 日均浅睡.
@property (nonatomic, assign) NSInteger daily_waking_sleep;   // 日均清醒.
@property (nonatomic, assign) NSInteger daily_start_sleep;    // 日均入睡时间.
@property (nonatomic, assign) NSInteger daily_end_sleep;      // 日均醒来时间.

@property (nonatomic,assign) NSInteger silent_heart_rate;


@property (nonatomic, assign) NSInteger daily_burn_fat_mins; //平均脂肪燃烧时长
@property (nonatomic, assign) NSInteger daily_aerobic_mins;  //平均肌肉锻炼时长
@property (nonatomic, assign) NSInteger daily_limit_mins;    //平均极限运动时长

@property (nonatomic, assign) NSInteger max_fat_excise;         //最高脂肪锻炼
@property (nonatomic, assign) NSInteger max_endurance_excise;   //最高耐力锻炼
@property (nonatomic, assign) NSInteger max_power_excise;       //最高力量锻炼

@property (nonatomic, strong) NSMutableDictionary *sportDic;
@property (nonatomic,strong) NSMutableDictionary *sleepDic;
@property (nonatomic,strong) NSMutableDictionary *heartDic;


@end
