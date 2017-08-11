//
//  StudentMineModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/30.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentMineModel : NSObject
@property (nonatomic,copy) NSString *addr;
@property (nonatomic,copy) NSString *birth;
@property (nonatomic,copy) NSString *class_alias;
@property (nonatomic,copy) NSString *class_id;
@property (nonatomic,copy) NSString *family_id;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *pwd;
@property (nonatomic,copy) NSString *relationship;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *stu_id;
@property (nonatomic,copy) NSString *stu_name;
@property (nonatomic,copy) NSString *stu_pic;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *updated_at;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *grade_alias;
@property (nonatomic,strong) NSDictionary *has_one_family;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
