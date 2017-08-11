//
//  PurifyTwoViewController.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/7/31.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurifyTwoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *qingjingLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanganLabel;
@property (weak, nonatomic) IBOutlet UILabel *wenduLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneSpeedBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoSpeedBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeSpeedBtn;
@property (weak, nonatomic) IBOutlet UIButton *UVlightONBtn;
@property (weak, nonatomic) IBOutlet UIButton *UVLightOffBtn;
@property (weak, nonatomic) IBOutlet UIButton *changgeOnBtn;
@property (weak, nonatomic) IBOutlet UIButton *changgeOffBtn;
@property (nonatomic,copy) NSString *classroom_id;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *qingjing;
@property (nonatomic,copy) NSString *fangan;
@property (nonatomic,copy) NSString *wind_speed;
@property (nonatomic,copy) NSString *uv_on;
@property (nonatomic,copy) NSString *fresh_air_open;
@end
