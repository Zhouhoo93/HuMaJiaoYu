//
//  FamilyMineModel.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/30.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "FamilyMineModel.h"

@implementation FamilyMineModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if ([super init]) {
        //KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
