//
//  ClassModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
@property (nonatomic,copy) NSString *alias;
@property (nonatomic,copy) NSString *grade_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *school_id;
@property (nonatomic,copy) NSString *ID;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
