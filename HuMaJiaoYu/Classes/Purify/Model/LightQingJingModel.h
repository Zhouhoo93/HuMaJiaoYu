//
//  LightQingJingModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/8/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightQingJingModel : NSObject
@property (nonatomic,copy) NSString *Auto;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *blackboard_value;
@property (nonatomic,copy) NSString *classroom_value;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *plan_id;
@property (nonatomic,copy) NSString *updated_at;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
