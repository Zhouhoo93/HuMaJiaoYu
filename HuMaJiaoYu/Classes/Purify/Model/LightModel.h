//
//  LightModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/8/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightModel : NSObject
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *classroom_id;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *currentapower;
@property (nonatomic,copy) NSString *currentbpower;
@property (nonatomic,copy) NSString *currentstatus;
@property (nonatomic,copy) NSString *deleted_at;
@property (nonatomic,copy) NSString *did;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *install_time;
@property (nonatomic,copy) NSString *lengthOfuse;
@property (nonatomic,copy) NSString *light_type;
@property (nonatomic,copy) NSString *localtion;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *plan_id;
@property (nonatomic,copy) NSString *plan_name;
@property (nonatomic,copy) NSString *power;
@property (nonatomic,copy) NSString *scene_name;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *scene;
@property (nonatomic,copy) NSString *updated_at;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
