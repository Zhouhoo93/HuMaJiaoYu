//
//  FindTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/6/5.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end
