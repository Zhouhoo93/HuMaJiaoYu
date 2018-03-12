//
//  GradeModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/27.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeModel : NSObject
@property (nonatomic,copy) NSString *alias;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,strong)NSMutableArray *classrooms;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
