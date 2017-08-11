//
//  NoticeModel.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *thumbnail;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *updated_at;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
