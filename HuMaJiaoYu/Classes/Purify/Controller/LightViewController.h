//
//  LightViewController.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/28.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightViewController : UIViewController
@property (nonatomic,copy) NSString *classroom_id;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *scene_id;
@property (nonatomic,copy) NSString *plan_id;
@property (weak, nonatomic) IBOutlet UIButton *autoOffBtn;
@property (nonatomic,assign) CGFloat jiaoshi;
@property (weak, nonatomic) IBOutlet UIButton *autoOnBtn;
@property (nonatomic,assign) CGFloat heiban;
@end
