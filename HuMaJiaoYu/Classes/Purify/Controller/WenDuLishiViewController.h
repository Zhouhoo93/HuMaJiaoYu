//
//  WenDuLishiViewController.h
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/12/19.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WenDuLishiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *RightBtn1;
@property (weak, nonatomic) IBOutlet UIButton *RightBtn2;
@property (nonatomic,copy)NSString *charttip1;
@property (nonatomic,copy)NSString *charttip2;
@property (nonatomic,copy)NSString *chartleft1;
@property (nonatomic,copy)NSString *chartleft2;
@property (nonatomic,copy)NSString *chartright1;
@property (nonatomic,copy)NSString *chartright2;
@property (weak, nonatomic) IBOutlet UIImageView *ImgBg;
@property (nonatomic,assign) NSInteger index;

@end
