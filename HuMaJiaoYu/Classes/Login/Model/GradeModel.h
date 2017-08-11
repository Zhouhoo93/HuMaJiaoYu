//
//  GradeModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/27.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeModel : NSObject
@property (nonatomic,copy) NSString *grade;
@property (nonatomic,copy) NSString *grade_alias;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *updated_at;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
