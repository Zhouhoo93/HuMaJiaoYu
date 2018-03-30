//
//  ClassListModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassListModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSMutableDictionary *room;
@property (nonatomic,copy) NSMutableDictionary *ctrl_data;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *plan_id;
@property (nonatomic,copy) NSString *room_id;
@property (nonatomic,copy) NSString *scene_id;
@property (nonatomic,copy) NSString *school_id;
@property (nonatomic,copy) NSString *sn;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *ctrl_mode;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
