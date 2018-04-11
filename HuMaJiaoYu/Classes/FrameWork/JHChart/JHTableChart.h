//
//  JHTableChart.h
//  JHChartDemo
//
//  Created by 简豪 on 16/8/24.
//  Copyright © 2016年 JH. All rights reserved.
//
/************************************************************
 *                                                           *
 *                                                           *
                            表格
 *                                                           *
 *                                                              *
 ************************************************************/


#import "JHChart.h"
@protocol TableButDelegate <NSObject>//协议

- (void)transButIndex:(NSInteger)index;//协议方法

@end
@interface JHTableChart : JHChart
/**
 *  Table name, if it is empty, does not display a table name
 */
@property (nonatomic, copy) NSString * tableTitleString;
@property (nonatomic, assign) id<TableButDelegate>delegate;//代理属性
@property (nonatomic,assign)BOOL small;
/**
 *  Table header row height, default 50
 */
@property (nonatomic, assign) CGFloat tableChartTitleItemsHeight;
@property (nonatomic,assign) BOOL isblue;

/**
 *  Table header text font size (default 15), color (default depth)
 */
@property (nonatomic, strong) UIFont * tableTitleFont;
@property (nonatomic, strong) UIColor * tableTitleColor;
@property (nonatomic,assign)NSInteger typeCount;
//  0 =发用电表格1  1=发用电表格2  2 =发用电表格3  3 = 发用电表格4 4 = 发用电表格5 5=发用电表格6  6=发电故障  7= 用电故障


/**
 *  Table line color
 */
@property (nonatomic, strong) UIColor  * lineColor;


/**
 *  Data Source Arrays
 */
@property (nonatomic, strong) NSArray * dataArr;


/**
 *  Width of each column
 */
@property (nonatomic, strong) NSArray * colWidthArr;

/**
 *  The smallest line is high, the default is 50
 */
@property (nonatomic, assign) CGFloat minHeightItems;
@property (nonatomic,assign)BOOL isRed;

/**
 *  Table data display color
 */
@property (nonatomic, strong) UIColor * bodyTextColor;


/**
 *  The column header name, the first column horizontal statement, need to use | segmentation
 */
@property (nonatomic, strong) NSArray * colTitleArr;

/**
 *  Anyway, the ranks of name statement, if it is necessary to fill out a two data
 */
@property (nonatomic, strong) NSArray * rowAndColTitleArr;


/**
 *  Offset value of start point
 */
@property (nonatomic, assign) CGFloat beginSpace;



/**
 *  According to the current data source to determine the desired table view
 */
- (CGFloat)heightFromThisDataSource;
- (void)ClickBut:(UIButton *)sender;//此方法执行时判断协议方法的执行情况
@end
