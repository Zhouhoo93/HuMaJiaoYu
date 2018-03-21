//
//  ClassListTwoModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2018/3/21.
//  Copyright © 2018年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassListTwoModel : NSObject
@property (nonatomic,copy) NSString *alias;
@property (nonatomic,copy) NSMutableDictionary *classroom;
@property (nonatomic,copy) NSString *classroom_id;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *school_id;
@property (nonatomic,copy) NSString *updated_at;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
