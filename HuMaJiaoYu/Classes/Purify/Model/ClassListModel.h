//
//  ClassListModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassListModel : NSObject
@property (nonatomic,copy) NSString *class_id;
@property (nonatomic,copy) NSString *class_name;
@property (nonatomic,copy) NSString *classroom_id;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *status;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
