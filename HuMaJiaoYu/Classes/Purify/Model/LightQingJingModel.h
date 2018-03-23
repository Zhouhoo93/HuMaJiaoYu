//
//  LightQingJingModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/8/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightQingJingModel : NSObject
@property (nonatomic,copy) NSString *change_air;
@property (nonatomic,copy) NSString *created_at;
//@property (nonatomic,copy) NSString *deleted_at;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *school_id;
@property (nonatomic,copy) NSString *speed_value;
@property (nonatomic,copy) NSString *uv_value;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
