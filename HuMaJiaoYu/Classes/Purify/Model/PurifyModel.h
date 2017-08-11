//
//  PurifyModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurifyModel : NSObject
@property (nonatomic,copy) NSString *CO2;
@property (nonatomic,copy) NSString *PM25;
@property (nonatomic,copy) NSString *TVOC;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *brand;
@property (nonatomic,copy) NSString *classroom_id;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *deleted_at;
@property (nonatomic,copy) NSString *device_on;
@property (nonatomic,copy) NSString *device_status;
@property (nonatomic,copy) NSString *fresh_air_open;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *illuminance;
@property (nonatomic,copy) NSString *install_time;
@property (nonatomic,copy) NSString *localtion;
//@property (nonatomic,copy) NSString *plans;
@property (nonatomic,copy) NSString *sn;
@property (nonatomic,copy) NSString *updated_at;
@property (nonatomic,copy) NSString *uv_on;
@property (nonatomic,copy) NSString *uv_status;
@property (nonatomic,copy) NSString *wind_peed;
@property (nonatomic,copy) NSString *temperature;
@property (nonatomic,copy) NSString *plan_name;
@property (nonatomic,copy) NSString *sence_name;
@property (nonatomic,strong) NSArray *plans;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
