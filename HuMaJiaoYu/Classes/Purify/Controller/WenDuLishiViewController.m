//
//  WenDuLishiViewController.m
//  HuMaJiaoYu
//
//  Created by Zhouhoo on 2017/12/19.
//  Copyright © 2017年 xinyuntec. All rights reserved.
//

#import "WenDuLishiViewController.h"
#import "JHLineChart.h"
@interface WenDuLishiViewController ()
@property (nonatomic,strong)JHLineChart *lineChart;
@property (nonatomic,strong)JHLineChart *lineChart1;
@end

@implementation WenDuLishiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setChart];
}

- (void)setChart{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, 250, 20)];
    titleLabel.text = self.charttip1;
    titleLabel.textColor = RGBColor(2, 28, 106);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.ImgBg addSubview:titleLabel];
    
    UILabel *waLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 40, 10)];
    waLabel.text = self.chartleft1;
    waLabel.textColor = RGBColor(0, 60, 255);
    waLabel.font = [UIFont systemFontOfSize:11];
    [self.ImgBg addSubview:waLabel];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 15, 50, 20)];
    rightTopLabel.text = self.chartright1;
    rightTopLabel.font = [UIFont systemFontOfSize:8];
    [self.ImgBg addSubview:rightTopLabel];
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 20, 10, 10)];
    topImg.image = [UIImage imageNamed:@"round"];
    [self.ImgBg addSubview:topImg];
    
    self.lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(15,KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart.isShowRight = NO;
    self.lineChart.xLineDataArr = @[@"7:00",@"9:00",@"11:00",@"13:00",@"15:00",@"17:00"];
    self.lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart.valueArr = @[];
    //    self.lineChart.valueArr = @[@1,@1,@1,[NSNull null],@1,@1,@1];
    self.lineChart.showYLevelLine = YES;
    self.lineChart.showYLine = YES;
    self.lineChart.isShowLeft = YES;
    self.lineChart.isKw = NO;
    self.lineChart.isShowRight = NO;
    self.lineChart.showValueLeadingLine = NO;
    self.lineChart.valueFontSize = 0.0;
    self.lineChart.backgroundColor = [UIColor clearColor];
    /* Line Chart colors */
    self.lineChart.valueLineColorArr =@[ RGBColor(255, 0, 0)];
    /* Colors for every line chart*/
    //    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    self.lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    self.lineChart.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    /*        Set whether to fill the content, the default is False         */
    //    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    self.lineChart.pathCurve = YES;
    /*        Set fill color array         */
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [self.ImgBg addSubview:self.lineChart];
    //-------------------
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 240, 250, 20)];
    titleLabel1.text = self.charttip2;
    titleLabel1.textColor = RGBColor(2, 28, 106);
    titleLabel1.font = [UIFont systemFontOfSize:16];
    [self.ImgBg addSubview:titleLabel1];
    
    UILabel *waLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 245, 35, 10)];
    waLabel1.text = self.chartleft2;
    waLabel1.textColor = RGBColor(0, 60, 255);
    waLabel1.font = [UIFont systemFontOfSize:11];
    [self.ImgBg addSubview:waLabel1];
    
    UILabel *rightTopLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 235, 50, 20)];
    rightTopLabel1.text = self.chartright2;
    rightTopLabel1.font = [UIFont systemFontOfSize:8];
    [self.ImgBg addSubview:rightTopLabel1];
    UIImageView *topImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 240, 10, 10)];
    topImg1.image = [UIImage imageNamed:@"round"];
    [self.ImgBg addSubview:topImg1];
    
    self.lineChart1 = [[JHLineChart alloc] initWithFrame:CGRectMake(15,KHeight/667*250, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart1.isShowRight = NO;
    self.lineChart1.xLineDataArr = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    self.lineChart1.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart1.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart1.valueArr = @[];
    //    self.lineChart.valueArr = @[@1,@1,@1,[NSNull null],@1,@1,@1];
    self.lineChart1.showYLevelLine = YES;
    self.lineChart1.showYLine = YES;
    self.lineChart1.isShowLeft = YES;
    self.lineChart1.isKw = NO;
    self.lineChart1.isShowRight = NO;
    self.lineChart1.showValueLeadingLine = NO;
    self.lineChart1.valueFontSize = 0.0;
    self.lineChart1.backgroundColor = [UIColor clearColor];
    /* Line Chart colors */
    self.lineChart1.valueLineColorArr =@[ RGBColor(255, 0, 0)];
    /* Colors for every line chart*/
    //    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    self.lineChart1.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart1.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    self.lineChart1.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    /*        Set whether to fill the content, the default is False         */
    //    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    self.lineChart1.pathCurve = YES;
    /*        Set fill color array         */
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [self.ImgBg addSubview:self.lineChart1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
