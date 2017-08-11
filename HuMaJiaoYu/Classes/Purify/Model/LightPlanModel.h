//
//  LightPlanModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/8/1.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightPlanModel : NSObject
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *times;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
