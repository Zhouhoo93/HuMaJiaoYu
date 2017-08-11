//
//  HSingleGlobalData.m
//  HelloBoxT
//
//  Created by waveboyz on 16/5/19.
//  Copyright © 2016年 quanjiakeji. All rights reserved.
//

#import "HSingleGlobalData.h"

static HSingleGlobalData *_sharedInstance;

@implementation HSingleGlobalData

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance =[[HSingleGlobalData alloc]init];
    });
    return _sharedInstance;
}
@end
