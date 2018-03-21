//
//  ClassListTwoModel.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2018/3/21.
//  Copyright © 2018年 xinyuntec. All rights reserved.
//

#import "ClassListTwoModel.h"

@implementation ClassListTwoModel
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
