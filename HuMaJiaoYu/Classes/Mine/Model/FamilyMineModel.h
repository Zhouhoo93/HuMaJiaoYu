//
//  FamilyMineModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/30.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyMineModel : NSObject
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *family_name;
@property (nonatomic,copy) NSString *family_pic;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *pwd;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,strong) NSArray *has_many_stu;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
