//
//  HSingleGlobalData.h
//  HelloBoxT
//
//  Created by waveboyz on 16/5/19.
//  Copyright © 2016年 quanjiakeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSingleGlobalData : NSObject

@property (nonatomic,copy)NSString *passName;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * registerid;
@property (nonatomic,copy) NSString * BID;
@property (nonatomic,copy) NSString *actual_distance;
@property (nonatomic,copy) NSString *straight_line_distance;
@property (nonatomic,copy) NSString *address; //定位地址
@property (nonatomic,copy) NSString *position;//定位经纬度
@property (nonatomic,copy) NSString *city;//城市
@property (nonatomic,copy) NSString *province;//城市
@property (nonatomic,copy) NSString *district;//区
@property (nonatomic,assign) double loc;  //对方纬度
@property (nonatomic,assign) double lat; //对方经度
@property (nonatomic,assign) BOOL isHave; //对方接受后才可以获取经纬度
@property (nonatomic,copy)NSString *editName;
@property (nonatomic,copy)NSString *editPhone;
+ (instancetype)sharedInstance;

@end
