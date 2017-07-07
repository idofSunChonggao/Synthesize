//
//  ProtocolMonthModel.h
//  BLEProject
//
//  Created by aiju_huangjing1 on 16/4/8.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//

#import "JKDBModel.h"

@interface ProtocolMonthModel : NSObject
@property (nonatomic,assign)  NSInteger days_count;

@property (nonatomic, assign) NSInteger month_number;            //第几月
@property (nonatomic, assign) NSInteger year_number;             //年，如2014
@property (nonatomic, assign) NSInteger month_totalSteps;        // 当月的总步数
@property (nonatomic, assign) NSInteger month_total_calories;     // 当月的总卡路里
@property (nonatomic, assign) NSInteger month_total_distance ;    // 当月的总路程
@property (nonatomic, assign) NSInteger month_total_sleep ;       // 当月的总睡眠时间

@property (nonatomic, assign) NSInteger total_deep_sleep;         // 累计深睡.
@property (nonatomic, assign) NSInteger total_shallow_sleep;      // 累计浅睡.
@property (nonatomic, assign) NSInteger total_waking_sleep;       // 累计清醒.
@property (nonatomic, assign) NSInteger total_start_sleep;        // 累计入睡时间.
@property (nonatomic, assign) NSInteger total_end_sleep;          // 累计醒来时间.

@property (nonatomic, assign) NSInteger daily_steps;             // 日均步数.
@property (nonatomic, assign) NSInteger daily_calories;          // 日均卡路里.
@property (nonatomic, assign) NSInteger daily_distance;          // 日均里程.

@property (nonatomic, assign) NSInteger daily_sleep;             // 日均睡眠.
@property (nonatomic, assign) NSInteger daily_deep_sleep;         // 日均深睡.
@property (nonatomic, assign) NSInteger daily_shallow_sleep;      // 日均浅睡.
@property (nonatomic, assign) NSInteger daily_waking_sleep;       // 日均清醒.
@property (nonatomic, assign) NSInteger daily_start_sleep;        // 日均入睡时间.
@property (nonatomic, assign) NSInteger daily_end_sleep;          // 日均醒来时间.

@property (nonatomic, assign) NSInteger sport_active_days;        // 每月运动活跃天数.
@property (nonatomic, assign) NSInteger sleep_active_days;        // 每月睡眠活跃天数.

@property (nonatomic,assign) uint8_t silent_heart_rate;           //静息心率

@property (nonatomic, assign) NSInteger daily_burn_fat_mins; //平均脂肪燃烧时长
@property (nonatomic, assign) NSInteger daily_aerobic_mins;  //平均肌肉锻炼时长
@property (nonatomic, assign) NSInteger daily_limit_mins;    //平均极限运动时长

@property (nonatomic, assign) NSInteger max_fat_excise;         //最高脂肪锻炼
@property (nonatomic, assign) NSInteger max_endurance_excise;   //最高耐力锻炼
@property (nonatomic, assign) NSInteger max_power_excise;       //最高力量锻炼


@property (nonatomic,strong) NSMutableArray *show_sport_data_array;
@property (nonatomic,strong) NSMutableArray *show_sleep_data_array;
@property (nonatomic,strong) NSMutableArray *show_deep_data_array;
@property (nonatomic,strong) NSMutableArray *show_shallow_data_array;
@property (nonatomic,strong) NSMutableArray *show_silent_data_array;

@property (nonatomic,strong) NSMutableDictionary *sportDic;
@property (nonatomic,strong) NSMutableDictionary *sleepDic;
@property (nonatomic,strong) NSMutableDictionary *heartRateDic;

@end
