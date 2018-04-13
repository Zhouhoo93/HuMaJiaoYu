//
//  JHTableChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/8/24.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHTableChart.h"
#import "JHTableDataRowModel.h"
@interface JHTableChart ()

@property (nonatomic,assign)CGFloat tableWidth;
@property (nonatomic,assign) CGFloat tableHeight;
@property (nonatomic,assign) CGFloat lastY;
@property (nonatomic,assign) CGFloat bodyHeight;
@property (nonatomic,strong)NSMutableArray * dataModelArr;
@end

@implementation JHTableChart

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _minHeightItems             = 20;
        _beginSpace                 = 15.0;
        _tableChartTitleItemsHeight = 20.0;
        _lineColor                  = [UIColor darkGrayColor];
        if (KWidth>374) {
            _tableTitleFont             = [UIFont systemFontOfSize:14];
        }else{
            _tableTitleFont             = [UIFont systemFontOfSize:13];
        }
        
        _tableTitleColor            = [UIColor darkGrayColor];
        _tableWidth                 = 100;
        _lastY                      = 0.0;
        _bodyHeight                 = 0;
        _bodyTextColor              = [UIColor darkGrayColor];
        
    }
    return self;
}

-(void)setBeginSpace:(CGFloat)beginSpace{
    
    _beginSpace = beginSpace;
    _lastY = beginSpace;
    
}


-(void)setDataArr:(NSArray *)dataArr{
    
    
    _dataArr = dataArr;
    
    _dataModelArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<_dataArr.count; i++) {
        
        JHTableDataRowModel *model = [JHTableDataRowModel new];
        model.maxCount = 1;
        
        for (id obj in _dataArr[i]) {
            
            if ([obj isKindOfClass:[NSArray class]]) {
                if (model.maxCount<=[obj count]) {
                    model.maxCount = [obj count];
                }
            }
        }
        model.dataArr = dataArr[i];
        
        [_dataModelArr addObject:model];
    }
    
    
    
}
//代理方法, 通过BUT 下标 来滑动视图
- (void)ClickBut:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(transButIndex:)]) {
        //代理存在且有这个transButIndex:方法
        [self.delegate transButIndex:sender.tag - 1000];
    }
}

- (void)btnClick:(UIButton *)sender{
    NSLog(@"点击了表格按钮%ld",sender.tag);
    [self ClickBut:sender];
}

/**
 *  CoreGraphic 绘图
 *
 *  @param rect
 */
-(void)drawRect:(CGRect)rect{
    if (_typeCount==87) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        /*        表格四周线条         */
        
        //        /*        上         */
        //        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0) andIsDottedLine:NO andColor:_lineColor];
        //
        //        /*        下         */
        //        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 + _tableHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace ,0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
        //
        //
        //        /*        左         */
        //        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(_beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
        //
        //        /*        右         */
        //        [self drawLineWithContext:context andStarPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
        
        /*        表头         */
        if (_tableTitleString.length>0) {
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 +_tableChartTitleItemsHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0+_tableChartTitleItemsHeight) andIsDottedLine:NO andColor:_lineColor];
            
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
            if (self.isRed) {
                [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor redColor] font:_tableTitleFont];
            }else{
                if (self.isRed) {
                    [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor redColor] font:_tableTitleFont];
                }else{
                    [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor blackColor] font:_tableTitleFont];
                }
                
            }
            _lastY = _beginSpace + _tableChartTitleItemsHeight;
        }
        
        
        /*        绘制列的分割线         */
        if (_colTitleArr.count>0) {
            
            BOOL hasSetColWidth = 0;
            /*        如果指定了列的宽度         */
            if (_colTitleArr.count == _colWidthArr.count) {
                
                hasSetColWidth = YES;
                
            }else{
                hasSetColWidth = NO;
            }
            
            CGFloat lastX = _beginSpace;
            for (NSInteger i = 0; i<_colTitleArr.count; i++) {
                
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
                
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:_colTitleArr[i]];
                
                
                if (i==0) {
                    
                    NSArray *firArr = [_colTitleArr[0] componentsSeparatedByString:@"|"];
                    if (firArr.count>=2) {
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                        if (KWidth>374) {
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];
                        }else{
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:13 aimString:firArr[0]];
                        }
                        
                        
                        [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                        if (KWidth>374) {
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];
                        }else{
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:13 aimString:firArr[1]];
                        }
                        
                        
                        [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                    }else{
                        if (self.isRed) {
                            if (KWidth>374) {
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14]];
                            }else{
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                            }
                            
                        }else{
                            if (KWidth>364) {
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:[UIFont systemFontOfSize:14]];
                            }else{
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:[UIFont systemFontOfSize:13]];
                            }
                            
                        }
                        
                    }
                    
                    
                }else{
                    if (self.isRed) {
                        if (KWidth>374) {
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14]];
                        }else{
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                        }
                        
                    }else{
                        if (KWidth>374) {
                            if ([_colTitleArr[i] isEqualToString:@"异常"]) {
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:RGBColor(255, 139, 0) font:[UIFont systemFontOfSize:14]];
                            }else if([_colTitleArr[i] isEqualToString:@"故障"]){
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14]];
                            }else{
                               [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
                            }
                        }else{
                            if ([_colTitleArr[i] isEqualToString:@"异常"]) {
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:RGBColor(255, 139, 0) font:[UIFont systemFontOfSize:14]];
                            }else if([_colTitleArr[i] isEqualToString:@"故障"]){
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14]];
                            }else{
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
                            }
                        }
                        
                    }
                    
                }
                lastX += wid;
                if (i==_colTitleArr.count - 1) {
                    
                }else
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
                
            }
            
            _lastY += _minHeightItems;
        }
        /*        列名分割线         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY ) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY ) andIsDottedLine:NO andColor:_lineColor];
        
        
        
        
        BOOL hasSetColWidth = 0;
        /*        如果指定了列的宽度         */
        if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
            
            hasSetColWidth = YES;
            
        }else{
            hasSetColWidth = NO;
        }
        
        /*        绘制具体的行数据         */
        
        for (NSInteger i = 0; i<_dataModelArr.count; i++) {
            
            JHTableDataRowModel *model = _dataModelArr[i];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_beginSpace, _lastY-_minHeightItems, KWidth-20, _minHeightItems)];
            btn.tag = i+1000;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY + model.maxCount * _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY + model.maxCount * _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
            
            CGFloat lastX = _beginSpace;
            
            for (NSInteger j = 0; j< model.dataArr.count; j++) {
                
                
                id rowItems = model.dataArr[j];
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
                if ([rowItems isKindOfClass:[NSArray class]]) {
                    
                    CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                    /*       具体某一列有多个元素时       */
                    for (NSInteger n = 0; n<[rowItems count]; n++) {
                        
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_tableTitleFont.pointSize aimString:rowItems[n]];
                        //                    P_M(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0)
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                    }
                    
                }else{
                    
                    CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_tableTitleFont.pointSize aimString:rowItems];
                    if (self.isRed) {
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor redColor] font:_tableTitleFont];
                    }else{
                        if ([rowItems isEqualToString:@"异常"]) {
                             [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:RGBColor(255, 139, 0) font:_tableTitleFont];
                        }else if([rowItems isEqualToString:@"故障"]){
                            [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor redColor] font:_tableTitleFont];
                        }else{
                            [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                        }
                    }
                }
                lastX += wid;
                
                
            }
            _lastY += model.maxCount * _minHeightItems;
            
            
            
        }
    }//用电故障列表
    
    if (_typeCount==88) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        /*        表格四周线条         */
        
//        /*        上         */
//        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0) andIsDottedLine:NO andColor:_lineColor];
//        
//        /*        下         */
//        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 + _tableHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace ,0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
//        
//        
//        /*        左         */
//        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(_beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
//        
//        /*        右         */
//        [self drawLineWithContext:context andStarPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
        
        /*        表头         */
        if (_tableTitleString.length>0) {
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 +_tableChartTitleItemsHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0+_tableChartTitleItemsHeight) andIsDottedLine:NO andColor:_lineColor];
            
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
            if (self.isRed) {
                [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor redColor] font:_tableTitleFont];
            }else{
                if (self.isRed) {
                    [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor redColor] font:_tableTitleFont];
                }else{
                    [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor blackColor] font:_tableTitleFont];
                }
                
            }
            _lastY = _beginSpace + _tableChartTitleItemsHeight;
        }
        
        
        /*        绘制列的分割线         */
        if (_colTitleArr.count>0) {
            
            BOOL hasSetColWidth = 0;
            /*        如果指定了列的宽度         */
            if (_colTitleArr.count == _colWidthArr.count) {
                
                hasSetColWidth = YES;
                
            }else{
                hasSetColWidth = NO;
            }
            
            CGFloat lastX = _beginSpace;
            for (NSInteger i = 0; i<_colTitleArr.count; i++) {
                
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
                
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:_colTitleArr[i]];
                
                
                if (i==0) {
                    
                    NSArray *firArr = [_colTitleArr[0] componentsSeparatedByString:@"|"];
                    if (firArr.count>=2) {
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                        
                        
                        if (_small) {
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:9 aimString:firArr[0]];
                             [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:[UIFont systemFontOfSize:9]];
                        }else{
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:13 aimString:firArr[0]];
                            [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                        }
                        
                       
                        
                        if (_small) {
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:9 aimString:firArr[1]];
                            [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:[UIFont systemFontOfSize:9]];
                        }else{
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:13 aimString:firArr[1]];
                        [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                        }
                    }else{
                        if (self.isRed) {
                            if (KWidth>374) {
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14]];
                            }else{
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                            }
                            
                        }else{
                            if (KWidth>364) {
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:[UIFont systemFontOfSize:14]];
                            }else{
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:[UIFont systemFontOfSize:13]];
                            }
                            
                        }
                        
                    }
                    
                    
                }else{
                    if (self.isRed) {
                        if (KWidth>374) {
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14]];
                        }else{
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                        }
                        
                    }else{
                        if (KWidth>374) {
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
                        }else{
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
                        }
                        
                    }
                    
                }
                lastX += wid;
                if (i==_colTitleArr.count - 1) {
                    
                }else
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
                
            }
            
            _lastY += _minHeightItems;
        }
        /*        列名分割线         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY ) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY ) andIsDottedLine:NO andColor:_lineColor];
        
        
        
        
        BOOL hasSetColWidth = 0;
        /*        如果指定了列的宽度         */
        if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
            
            hasSetColWidth = YES;
            
        }else{
            hasSetColWidth = NO;
        }
        
        /*        绘制具体的行数据         */
        if (_dataModelArr.count==0){
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_beginSpace, _lastY-_minHeightItems, KWidth-20, _minHeightItems)];
            btn.tag = 1000;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        for (NSInteger i = 0; i<_dataModelArr.count; i++) {
            
            JHTableDataRowModel *model = _dataModelArr[i];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_beginSpace, _lastY-_minHeightItems, KWidth-20, _minHeightItems)];
            btn.tag = i+1000;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (i==_dataModelArr.count-1){
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_beginSpace, _lastY, KWidth-20, _minHeightItems)];
                btn.tag = i+1001;
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
            
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY + model.maxCount * _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY + model.maxCount * _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
            
            CGFloat lastX = _beginSpace;
            
            for (NSInteger j = 0; j< model.dataArr.count; j++) {
                
                
                id rowItems = model.dataArr[j];
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
                if ([rowItems isKindOfClass:[NSArray class]]) {
                    
                    CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                    /*       具体某一列有多个元素时       */
                    for (NSInteger n = 0; n<[rowItems count]; n++) {
                        
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_tableTitleFont.pointSize aimString:rowItems[n]];
                        //                    P_M(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0)
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                    }
                    
                }else{
                    
                    CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_tableTitleFont.pointSize aimString:rowItems];
                    if (self.isRed) {
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor redColor] font:_tableTitleFont];
                    }else{
                        
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                    }
                }
                lastX += wid;
                
                
            }
            _lastY += model.maxCount * _minHeightItems;
            
            
            
        }
    }//用电故障列表
    if (_typeCount==11) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        /*        表格四周线条         */
        
        /*        上         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0) andIsDottedLine:NO andColor:_lineColor];
        
        /*        下         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 + _tableHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace ,0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
        
        
        /*        左         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(_beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
        
        /*        右         */
        [self drawLineWithContext:context andStarPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:_lineColor];
        
        /*        表头         */
        if (_tableTitleString.length>0) {
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 +_tableChartTitleItemsHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0+_tableChartTitleItemsHeight) andIsDottedLine:NO andColor:_lineColor];
            
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
            if (self.isRed) {
                 [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor redColor] font:_tableTitleFont];
            }else{
                if (self.isRed) {
                     [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor redColor] font:_tableTitleFont];
                }else{
                [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:[UIColor whiteColor] font:_tableTitleFont];
                }
           
            }
            _lastY = _beginSpace + _tableChartTitleItemsHeight;
        }
        
        
        /*        绘制列的分割线         */
        if (_colTitleArr.count>0) {
            
            BOOL hasSetColWidth = 0;
            /*        如果指定了列的宽度         */
            if (_colTitleArr.count == _colWidthArr.count) {
                
                hasSetColWidth = YES;
                
            }else{
                hasSetColWidth = NO;
            }
            
            CGFloat lastX = _beginSpace;
            for (NSInteger i = 0; i<_colTitleArr.count; i++) {
                
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
          
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:_colTitleArr[i]];
                
                
                if (i==0) {
                    
                    NSArray *firArr = [_colTitleArr[0] componentsSeparatedByString:@"|"];
                    if (firArr.count>=2) {
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                        if (KWidth>374) {
                             size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];
                        }else{
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:13 aimString:firArr[0]];
                        }
                       
                        
                        [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                        if (KWidth>374) {
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];
                        }else{
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:13 aimString:firArr[1]];
                        }
                        
                        
                        [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                    }else{
                        if (self.isRed) {
                            if (KWidth>374) {
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14]];
                            }else{
                               [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                            }
                            
                        }else{
                            if (KWidth>364) {
                                 [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
                            }else{
                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13]];
                            }
                       
                        }
                       
                    }
                    
                    
                }else{
                    if (self.isRed) {
                        if (KWidth>374) {
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14]];
                        }else{
                        [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
                        }
                        
                    }else{
                        if (KWidth>374) {
                             [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
                        }else{
                             [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13]];
                        }
                   
                    }
                    
                }
                lastX += wid;
                if (i==_colTitleArr.count - 1) {
                    
                }else
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
                
                }
            
            _lastY += _minHeightItems;
        }
        /*        列名分割线         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY ) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY ) andIsDottedLine:NO andColor:_lineColor];
        
        
        
        
        BOOL hasSetColWidth = 0;
        /*        如果指定了列的宽度         */
        if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
            
            hasSetColWidth = YES;
            
        }else{
            hasSetColWidth = NO;
        }
        
        /*        绘制具体的行数据         */
        
        for (NSInteger i = 0; i<_dataModelArr.count; i++) {
            
            
            JHTableDataRowModel *model = _dataModelArr[i];
            
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY + model.maxCount * _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY + model.maxCount * _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
            
            CGFloat lastX = _beginSpace;
            
            for (NSInteger j = 0; j< model.dataArr.count; j++) {
                
                
                id rowItems = model.dataArr[j];
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
                if ([rowItems isKindOfClass:[NSArray class]]) {
                    
                    CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                    /*       具体某一列有多个元素时       */
                    for (NSInteger n = 0; n<[rowItems count]; n++) {
                        
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_tableTitleFont.pointSize aimString:rowItems[n]];
                        //                    P_M(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0)
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                    }
                    
                }else{
                    
                    CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_tableTitleFont.pointSize aimString:rowItems];
                    if (self.isRed) {
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor redColor] font:_tableTitleFont];
                    }else{
                    
                    [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                    }
                }
                lastX += wid;
                
                
            }
            _lastY += model.maxCount * _minHeightItems;
            
            
            
        }
    }//用电故障列表
    if (_typeCount==6) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.isblue) {
            CGMutablePathRef path = CGPathCreateMutable();
            //指定矩形
            CGRect rectangle = CGRectMake(_beginSpace, 0,KWidth-_beginSpace*2,
                                          210/6);
            //将矩形添加到路径中
            CGPathAddRect(path,NULL,
                          rectangle);
            //获取上下文
            CGContextRef currentContext =
            UIGraphicsGetCurrentContext();
            //将路径添加到上下文
            CGContextAddPath(currentContext, path);
            //设置矩形填充色
            [RGBColor(9, 68, 132)setFill];
            //矩形边框颜色
            //        [[UIColor brownColor] setStroke];
            //边框宽度
            CGContextSetLineWidth(currentContext,0.0f);
            //绘制
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            CGPathRelease(path);

        }
        
        /*        表格四周线条         */
        
        /*        上         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        /*        下         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 + _tableHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace ,0 + _tableHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        
        /*        左         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(_beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        /*        右         */
        [self drawLineWithContext:context andStarPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        /*        表头         */
        if (_tableTitleString.length>0) {
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _beginSpace +_tableChartTitleItemsHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , _beginSpace+_tableChartTitleItemsHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
            
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
            [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:_tableTitleColor font:_tableTitleFont];
            _lastY = _beginSpace + _tableChartTitleItemsHeight;
        }
        
        
        /*        绘制列的分割线         */
        if (_colTitleArr.count>0) {
            
            BOOL hasSetColWidth = 0;
            /*        如果指定了列的宽度         */
            if (_colTitleArr.count == _colWidthArr.count) {
                
                hasSetColWidth = YES;
                
            }else{
                hasSetColWidth = NO;
            }
            
            CGFloat lastX = _beginSpace;
            for (NSInteger i = 0; i<_colTitleArr.count; i++) {
                
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:_colTitleArr[i]];
                
                
                
                        if ([_colTitleArr[1] isEqualToString:@"异常"]||[_colTitleArr[1] isEqualToString:@"隐患"] ) {
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:RGBColor(248, 200, 19) font:_tableTitleFont];
                        }else if([_colTitleArr[1] isEqualToString:@"故障"]||[_colTitleArr[1] isEqualToString:@"危险"]){
                        [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:_tableTitleFont];
                        }else{
                    
                    [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor blackColor] font:_tableTitleFont];
                        }
                    
                
                lastX += wid;
                if (i==_colTitleArr.count - 1) {
                    
                }else{
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
                    
                    //
                }
            }
            _lastY += _minHeightItems;
    }
        /*        列名分割线         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY ) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY ) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        
        
        
        BOOL hasSetColWidth = 0;
        /*        如果指定了列的宽度         */
        if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
            
            hasSetColWidth = YES;
            
        }else{
            hasSetColWidth = NO;
        }
        
        /*        绘制具体的行数据         */
        
        for (NSInteger i = 0; i<_dataModelArr.count; i++) {
            
            
            JHTableDataRowModel *model = _dataModelArr[i];
            
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY + model.maxCount * _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY + model.maxCount * _minHeightItems) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
            
            CGFloat lastX = _beginSpace;
            
            for (NSInteger j = 0; j< model.dataArr.count; j++) {
                
                
                id rowItems = model.dataArr[j];
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
                if ([rowItems isKindOfClass:[NSArray class]]) {
                    
                    CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                    /*       具体某一列有多个元素时       */
                    for (NSInteger n = 0; n<[rowItems count]; n++) {
                        
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_tableTitleFont.pointSize aimString:rowItems[n]];
                        //                    P_M(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0)
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height)];
                        [button addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
                        
                        [self addSubview:button];
                        
                    }
                    
                }else{
                    
                    CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_tableTitleFont.pointSize aimString:rowItems];
                    
                    if ([model.dataArr[1] isEqualToString:@"故障"]||[model.dataArr[1] isEqualToString:@"危险"]){
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor redColor] font:_tableTitleFont];
                    }else if([model.dataArr[1] isEqualToString:@"隐患"]||[model.dataArr[1] isEqualToString:@"异常"]){
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:RGBColor(254, 206, 44) font:_tableTitleFont];
                    }else{
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor blackColor] font:_tableTitleFont];
                    }

                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height)];
                    [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitle:rowItems forState:UIControlStateNormal];
                    button.titleLabel.textColor = [UIColor blackColor];
                    button.alpha = 0.1;
                    [self addSubview:button];
                }
                lastX += wid;
                
                
            }
            _lastY += model.maxCount * _minHeightItems;
            
            
            
        }
        //发电故障列表
    }else if (_typeCount==7){
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.isblue) {
            CGMutablePathRef path = CGPathCreateMutable();
            //指定矩形
            CGRect rectangle = CGRectMake(_beginSpace, 0,KWidth-_beginSpace*2,
                                          210/6);
            //将矩形添加到路径中
            CGPathAddRect(path,NULL,
                          rectangle);
            //获取上下文
            CGContextRef currentContext =
            UIGraphicsGetCurrentContext();
            //将路径添加到上下文
            CGContextAddPath(currentContext, path);
            //设置矩形填充色
            [RGBColor(9, 68, 132)setFill];
            //矩形边框颜色
            //        [[UIColor brownColor] setStroke];
            //边框宽度
            CGContextSetLineWidth(currentContext,0.0f);
            //绘制
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            CGPathRelease(path);

        }
        
        /*        表格四周线条         */
        
        /*        上         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        /*        下         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 + _tableHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace ,0 + _tableHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];

        
        /*        左         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(_beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        /*        右         */
        [self drawLineWithContext:context andStarPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace,  0 + _tableHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        /*        表头         */
        if (_tableTitleString.length>0) {
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _beginSpace +_tableChartTitleItemsHeight) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , _beginSpace+_tableChartTitleItemsHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
            
            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, _tableChartTitleItemsHeight) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
            [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + _tableChartTitleItemsHeight/2 - size.height / 2.0, _tableWidth, _tableChartTitleItemsHeight) WithColor:_tableTitleColor font:_tableTitleFont];
            _lastY = _beginSpace + _tableChartTitleItemsHeight;
        }
        
        
        /*        绘制列的分割线         */
        if (_colTitleArr.count>0) {
            
            BOOL hasSetColWidth = 0;
            /*        如果指定了列的宽度         */
            if (_colTitleArr.count == _colWidthArr.count) {
                
                hasSetColWidth = YES;
                
            }else{
                hasSetColWidth = NO;
            }
            
            CGFloat lastX = _beginSpace;
            for (NSInteger i = 0; i<_colTitleArr.count; i++) {
                
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
                
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:_colTitleArr[i]];
                
                
                if (i==0) {
                    
                    NSArray *firArr = [_colTitleArr[0] componentsSeparatedByString:@"|"];
                    if (firArr.count>=2) {
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                        size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];
                        
                        [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                        size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];
                        
                        [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                    }else{
                        
                        [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:_tableTitleFont];;
                    }
                    
                    
                }else{
                    if ([_colTitleArr[1] isEqualToString:@"故障"]) {
                         [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:[UIColor redColor] font:_tableTitleFont];;
                    }else if ([_colTitleArr[1] isEqualToString:@"异常"]) {
                        [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:RGBColor(248, 200, 19) font:_tableTitleFont];;
                    }else{
                    [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:_bodyTextColor font:_tableTitleFont];;
                }
                }
                lastX += wid;
                if (i==_colTitleArr.count - 1) {
                    
                }else{
                    [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
                    
                    //
                }
            }
            _lastY += _minHeightItems;
        }
        /*        列名分割线         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY ) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY ) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
        
        
        
        
        BOOL hasSetColWidth = 0;
        /*        如果指定了列的宽度         */
        if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
            
            hasSetColWidth = YES;
            
        }else{
            hasSetColWidth = NO;
        }
        
        /*        绘制具体的行数据         */
        
        for (NSInteger i = 0; i<_dataModelArr.count; i++) {
            
            
            JHTableDataRowModel *model = _dataModelArr[i];
            
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY + model.maxCount * _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY + model.maxCount * _minHeightItems) andIsDottedLine:NO andColor:RGBColor(175, 175, 175)];
            
            CGFloat lastX = _beginSpace;
            
            for (NSInteger j = 0; j< model.dataArr.count; j++) {
                
                
                id rowItems = model.dataArr[j];
                
                
                CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
                if ([rowItems isKindOfClass:[NSArray class]]) {
                    
                    CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                    /*       具体某一列有多个元素时       */
                    for (NSInteger n = 0; n<[rowItems count]; n++) {
                        
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_tableTitleFont.pointSize aimString:rowItems[n]];
                        //                    P_M(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0)
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                        
                        if([rowItems isEqualToString:@"危险"]){
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor redColor] font:_tableTitleFont];
                        }else if ([rowItems isEqualToString:@"隐患"]){
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:RGBColor(254, 206, 44) font:_tableTitleFont];
                        }else{
                        [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_tableTitleColor font:_tableTitleFont];
                        }
                        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height)];
                        [button addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
                        
                        [self addSubview:button];
                        
                    }
                    
                }else{
                    
                    CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_tableTitleFont.pointSize aimString:rowItems];
                    if([rowItems isEqualToString:@"未解决"]){
                    [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor redColor] font:_tableTitleFont];
                    }else if([rowItems isEqualToString:@"已解决"]){
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor greenColor] font:_tableTitleFont];
                    
                    }else {
                       [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:[UIColor blackColor] font:_tableTitleFont];
                    }
                    
                    
                    
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height)];
                    [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitle:rowItems forState:UIControlStateNormal];
                    button.titleLabel.textColor = [UIColor blackColor];
                    button.alpha = 0.1;
                    [self addSubview:button];
                }
                lastX += wid;
                
                
            }
            _lastY += model.maxCount * _minHeightItems;
            
            
            
            
        }
    }else if(_typeCount==0||_typeCount==1){
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.isblue) {
            CGMutablePathRef path = CGPathCreateMutable();
            //指定矩形
            CGRect rectangle = CGRectMake(_beginSpace, 0,KWidth-_beginSpace*2,
                                          47);
            //将矩形添加到路径中
            CGPathAddRect(path,NULL,
                          rectangle);
            //获取上下文
            CGContextRef currentContext =
            UIGraphicsGetCurrentContext();
            //将路径添加到上下文
            CGContextAddPath(currentContext, path);
            //设置矩形填充色
            [RGBColor(9, 68, 132)setFill];
            //矩形边框颜色
            //        [[UIColor brownColor] setStroke];
            //边框宽度
            CGContextSetLineWidth(currentContext,0.0f);
            //绘制
            CGContextDrawPath(currentContext, kCGPathFillStroke);
            CGPathRelease(path);

        }
        
        /*        表格四周线条         */
        
        /*        上         */
        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , 0) andIsDottedLine:NO andColor:_lineColor];
        
        /*        下         */
//        [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0 + 71) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace ,0 + 71) andIsDottedLine:NO andColor:_lineColor];
//        
//        /*        左         */
        if (self.dataArr.count>0) {
             [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(_beginSpace,  71) andIsDottedLine:NO andColor:_lineColor];
            
             [self drawLineWithContext:context andStarPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace,  71) andIsDottedLine:NO andColor:_lineColor];
        }else{
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 0) andEndPoint:P_M(_beginSpace,  47) andIsDottedLine:NO andColor:_lineColor];
            
            /*        右         */
            [self drawLineWithContext:context andStarPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace, 0) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace,   47) andIsDottedLine:NO andColor:_lineColor];
        }
        /*        表头         */
        if (_typeCount==0||_typeCount==1||_typeCount==2) {
            //发用电第一个表格
            
            if (_tableTitleString.length>0) {
                
                [self drawLineWithContext:context andStarPoint:P_M(_beginSpace,  46) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , _beginSpace+46) andIsDottedLine:NO andColor:_lineColor];
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, 46) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
                [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + 46/2 - size.height / 2.0, _tableWidth, 46) WithColor:_tableTitleColor font:_tableTitleFont];
                _lastY = _beginSpace + 46;
                
            }
            
            
            /*        绘制列的分割线         */
            if (_colTitleArr.count>0) {
                
                BOOL hasSetColWidth = 0;
                /*        如果指定了列的宽度         */
                if (_colTitleArr.count == _colWidthArr.count) {
                    
                    hasSetColWidth = YES;
                    
                }else{
                    hasSetColWidth = NO;
                }
                
                CGFloat lastX = _beginSpace;
                for (NSInteger i = 0; i<_colTitleArr.count; i++) {
                    
                    
                    
                    CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);
                    
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:13 aimString:_colTitleArr[i]];
                    
                    
                    
                    
                    
                    
                    if (i==0) {
                        
                        NSArray *firArr = [_colTitleArr[0] componentsSeparatedByString:@"|"];
                        if (firArr.count>=2) {
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX + wid, _lastY + 46) andIsDottedLine:NO andColor:_lineColor];
                            if (KWidth>374) {
                                  size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:14 aimString:firArr[0]];
                            }else{
                                 size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:13 aimString:firArr[0]];
                            }
                          
                            
                            [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + 46 / 4.0 -size.height / 2.0, wid, 46 / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            if (KWidth>374) {
                                 size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:14 aimString:firArr[1]];
                            }else{
                                 size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:13 aimString:firArr[1]];
                            }
                           
                            
                            [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + 46 / 2.0 + 46 / 4.0 - size.height / 2.0, size.width+5, 46 / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                        }else{
                            
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + 46 / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:_tableTitleFont];;
                        }
                        
                        
                    }else if(i==3){
                        NSArray *firArr = [_colTitleArr[3] componentsSeparatedByString:@"|"];
                        if (firArr.count>=2) {
                            //横线
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, 23) andEndPoint:P_M(lastX + wid, 23) andIsDottedLine:NO andColor:_lineColor];
                            //竖线
                            //                    [self drawLineWithContext:context andStarPoint:P_M(lastX+wid/2, _lastY+18) andEndPoint:P_M(lastX + wid/2, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                            if (KWidth>374) {
                                 size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:14 aimString:firArr[0]];
                            }else{
                                 size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:13 aimString:firArr[0]];
                            }
                           
                            
                            [self drawText:firArr[0] context:context atPoint:CGRectMake(wid*5-20, _lastY + 46 / 4.0 -size.height / 2.0, wid, 46 / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            if (KWidth>374) {
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:14 aimString:firArr[1]];
                            }else{
                               size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:13 aimString:firArr[1]];
                            }
                            
                            
                            [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX  +wid/4+ wid / 4.0 - size.width / 2, _lastY + 46 / 2.0 + 46 / 4.0 - size.height / 2.0, size.width+5, 46 / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                        }
                    }else if (i==4){
                        
                        NSArray *firArr = [_colTitleArr[4] componentsSeparatedByString:@"|"];
                        if (firArr.count>=2) {
                            //横线
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, 23) andEndPoint:P_M(lastX + wid, 23) andIsDottedLine:NO andColor:_lineColor];
                            //竖线
                            //                    [self drawLineWithContext:context andStarPoint:P_M(lastX+wid/2, _lastY+18) andEndPoint:P_M(lastX + wid/2, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                            if (KWidth>374) {
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:14 aimString:firArr[0]];
                            }else{
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:13 aimString:firArr[0]];
                            }
                            
                            
                            [self drawText:firArr[0] context:context atPoint:CGRectMake(wid*5+10, _lastY + 46 / 4.0 -size.height / 2.0, wid, 46 / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            if (KWidth>374) {
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:14 aimString:firArr[1]];
                            }else{
                               size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, 46) textFont:13 aimString:firArr[1]];
                            }
                            
                            
                            [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX  +wid/4+ wid / 4.0 - size.width / 2, _lastY + 46 / 2.0 + 46 / 4.0 - size.height / 2.0, size.width+5, 46 / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            
                        }else{
                            
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2-5, _lastY + 46 / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:_tableTitleFont];;
                        }
                        
                        
                    }else{
                        
                        [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2-5, _lastY + 46 / 2.0 -size.height / 2.0, wid, 46) WithColor:_bodyTextColor font:_tableTitleFont];;
                    }
                    lastX += wid;
                    if (i==_colTitleArr.count - 1) {
                        
                    }else if(i==3){
                        //竖线
                        if (_dataArr.count>0) {
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, 23) andEndPoint:P_M(lastX, 71) andIsDottedLine:NO andColor:_lineColor];
                        }else{
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, 23) andEndPoint:P_M(lastX, 47) andIsDottedLine:NO andColor:_lineColor];
                        }
                    }else
                        if (_dataArr.count>0) {
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX,71) andIsDottedLine:NO andColor:_lineColor];
                        }else{
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX,47) andIsDottedLine:NO andColor:_lineColor];
                        }
                    
                    
                }
                _lastY += 25;
            }
            /*        列名分割线         */
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 46 ) andEndPoint:P_M(_beginSpace + _tableWidth, 46 ) andIsDottedLine:NO andColor:_lineColor];
            
            
            
            
            BOOL hasSetColWidth = 0;
            /*        如果指定了列的宽度         */
            if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
                
                hasSetColWidth = YES;
                
            }else{
                hasSetColWidth = NO;
            }
            
            /*        绘制具体的行数据         */
            
            for (NSInteger i = 0; i<_dataModelArr.count; i++) {
                
                
                JHTableDataRowModel *model = _dataModelArr[i];
                
                [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, 71) andEndPoint:P_M(_beginSpace + _tableWidth, 71) andIsDottedLine:NO andColor:_lineColor];
                
                CGFloat lastX = _beginSpace;
                
                for (NSInteger j = 0; j< model.dataArr.count; j++) {
                    
                    
                    id rowItems = model.dataArr[j];
                    
                    
                    CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
                    if ([rowItems isKindOfClass:[NSArray class]]) {
                        
                        CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                        /*       具体某一列有多个元素时       */
                        for (NSInteger n = 0; n<[rowItems count]; n++) {
                            
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_tableTitleFont.pointSize aimString:rowItems[n]];
                            //                    P_M(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0)
                            [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                        }
                        
                    }else{
                        
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * 46) textFont:_tableTitleFont.pointSize aimString:rowItems];
                        if (self.isRed) {
                             [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0-2,  46 + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width+10, size.height) WithColor:[UIColor redColor] font:_tableTitleFont];
                        }else{
                        
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0-2,  46 + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width+10, size.height) WithColor:RGBColor(108, 229, 0) font:_tableTitleFont];
                        }
                    }
                    lastX += wid;
                    
                    
                }
                _lastY += model.maxCount * _minHeightItems;
                
                
                
            }
            
        }else if(_typeCount==3||_typeCount==4||_typeCount==5){
            if (_tableTitleString.length>0) {
                
                [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _beginSpace +46) andEndPoint:P_M(CGRectGetWidth(self.frame) - _beginSpace , _beginSpace+46) andIsDottedLine:NO andColor:_lineColor];
                
                CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(_tableWidth, 46) textFont:_tableTitleFont.pointSize aimString:_tableTitleString];
                [self drawText:_tableTitleString context:context atPoint:CGRectMake(CGRectGetWidth(self.frame)/2.0 - size.width / 2, _beginSpace + 46/2 - size.height / 2.0, _tableWidth, 46) WithColor:_tableTitleColor font:_tableTitleFont];
                _lastY = _beginSpace + 46;
                
            }
            
            
            /*        绘制列的分割线         */
            if (_colTitleArr.count>0) {
                
                BOOL hasSetColWidth = 0;
                /*        如果指定了列的宽度         */
                if (_colTitleArr.count == _colWidthArr.count) {
                    
                    hasSetColWidth = YES;
                    
                }else{
                    hasSetColWidth = NO;
                }
                
                CGFloat lastX = _beginSpace;
                for (NSInteger i = 0; i<_colTitleArr.count; i++) {
                    
                    
                    
                    CGFloat wid = (hasSetColWidth?[_colWidthArr[i] floatValue]:_tableWidth / _colTitleArr.count);

                    
                    CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:_colTitleArr[i]];
                    
                    
                    if (i==0) {
                        
                        NSArray *firArr = [_colTitleArr[0] componentsSeparatedByString:@"|"];
                        if (firArr.count>=2) {
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];
                            
                            [self drawText:firArr[0] context:context atPoint:CGRectMake(lastX + wid / 2.0 + wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];
                            
                            [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX + wid / 4.0 - size.width / 2.0, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                        }else{
                            
                            [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:_tableTitleFont];;
                        }
                        
                        
                    }else if(i==2||i==4){
                        if (i==2) {
                            NSArray *firArr = [_colTitleArr[2] componentsSeparatedByString:@"|"];
                            if (firArr.count>=2) {
                                //横线
                                [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY+18) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems-18) andIsDottedLine:NO andColor:_lineColor];
                                //竖线
                                //                    [self drawLineWithContext:context andStarPoint:P_M(lastX+wid/2, _lastY+18) andEndPoint:P_M(lastX + wid/2, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                                
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];
                                
                                [self drawText:firArr[0] context:context atPoint:CGRectMake(wid*3-10, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];
                                
                                [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX  +wid/4+ wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            }
                            
                        }else{
                            NSArray *firArr = [_colTitleArr[4] componentsSeparatedByString:@"|"];
                            if (firArr.count>=2) {
                                //横线
                                [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY+18) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems-18) andIsDottedLine:NO andColor:_lineColor];
                                //竖线
                                //                    [self drawLineWithContext:context andStarPoint:P_M(lastX+wid/2, _lastY+18) andEndPoint:P_M(lastX + wid/2, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                                
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];
                                
                                [self drawText:firArr[0] context:context atPoint:CGRectMake(wid*5-10, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];
                                
                                [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX  +wid/4+ wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            }
                            
                        }
                    }else if (i==3||i==5){
                        if (i==3) {
                            NSArray *firArr = [_colTitleArr[3] componentsSeparatedByString:@"|"];
                            if (firArr.count>=2) {
                                //横线
                                [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY+18) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems-18) andIsDottedLine:NO andColor:_lineColor];
                                //竖线
                                //                    [self drawLineWithContext:context andStarPoint:P_M(lastX+wid/2, _lastY+18) andEndPoint:P_M(lastX + wid/2, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                                
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];
                                
                                [self drawText:firArr[0] context:context atPoint:CGRectMake(wid*3+20, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];
                                
                                [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX  +wid/4+ wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            }
                        }if (i==5) {
                            NSArray *firArr = [_colTitleArr[5] componentsSeparatedByString:@"|"];
                            if (firArr.count>=2) {
                                //横线
                                [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY+18) andEndPoint:P_M(lastX + wid, _lastY + _minHeightItems-18) andIsDottedLine:NO andColor:_lineColor];
                                //竖线
                                //                    [self drawLineWithContext:context andStarPoint:P_M(lastX+wid/2, _lastY+18) andEndPoint:P_M(lastX + wid/2, _lastY + _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                                
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[0]];
                                
                                [self drawText:firArr[0] context:context atPoint:CGRectMake(wid*5+20, _lastY + _minHeightItems / 4.0 -size.height / 2.0, wid, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                                size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, _minHeightItems) textFont:14 aimString:firArr[1]];
                                
                                [self drawText:firArr[1] context:context atPoint:CGRectMake(lastX  +wid/4+ wid / 4.0 - size.width / 2, _lastY + _minHeightItems / 2.0 + _minHeightItems / 4.0 - size.height / 2.0, size.width+5, _minHeightItems / 2.0) WithColor:_bodyTextColor font:_tableTitleFont];
                            }
                            
                            
                        }else{
                            
                                                [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, size.height) WithColor:_bodyTextColor font:_tableTitleFont];;
                        }
                        
                        
                    }else{
                        
                        [self drawText:_colTitleArr[i] context:context atPoint:CGRectMake(lastX + wid / 2.0 - size.width / 2, _lastY + _minHeightItems / 2.0 -size.height / 2.0, wid, _minHeightItems) WithColor:_bodyTextColor font:_tableTitleFont];
                    }
                    lastX += wid;
                    if (i==_colTitleArr.count - 1) {
                        
                    }else if(i==2||i==4){
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY+17) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
                    }else
                        [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY) andEndPoint:P_M(lastX, _lastY + _bodyHeight) andIsDottedLine:NO andColor:_lineColor];
                    
                    
                }
                _lastY += _minHeightItems;
            }
            /*        列名分割线         */
            [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY ) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY ) andIsDottedLine:NO andColor:_lineColor];
            
            
            
            
            BOOL hasSetColWidth = 0;
            /*        如果指定了列的宽度         */
            if (_colTitleArr.count == _colWidthArr.count && _colTitleArr.count>0) {
                
                hasSetColWidth = YES;
                
            }else{
                hasSetColWidth = NO;
            }
            
            /*        绘制具体的行数据         */
            
            for (NSInteger i = 0; i<_dataModelArr.count; i++) {
                
                
                JHTableDataRowModel *model = _dataModelArr[i];
                
                [self drawLineWithContext:context andStarPoint:P_M(_beginSpace, _lastY + model.maxCount * _minHeightItems) andEndPoint:P_M(_beginSpace + _tableWidth, _lastY + model.maxCount * _minHeightItems) andIsDottedLine:NO andColor:_lineColor];
                
                CGFloat lastX = _beginSpace;
                
                for (NSInteger j = 0; j< model.dataArr.count; j++) {
                    
                    
                    id rowItems = model.dataArr[j];
                    
                    
                    CGFloat wid = (hasSetColWidth?[_colWidthArr[j] floatValue]:_tableWidth / _colTitleArr.count);
                    if ([rowItems isKindOfClass:[NSArray class]]) {
                        
                        CGFloat perItemsHeightByMaxCount = model.maxCount * _minHeightItems / [rowItems count];
                        /*       具体某一列有多个元素时       */
                        for (NSInteger n = 0; n<[rowItems count]; n++) {
                            
                            [self drawLineWithContext:context andStarPoint:P_M(lastX, _lastY + (n+1) * perItemsHeightByMaxCount) andEndPoint:P_M(lastX + wid, _lastY + (n+1) * perItemsHeightByMaxCount) andIsDottedLine:NO andColor:_lineColor];
                            CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, perItemsHeightByMaxCount) textFont:_tableTitleFont.pointSize aimString:rowItems[n]];
                            //                    P_M(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0)
                            [self drawText:rowItems[n] context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0, _lastY + (n+1) * perItemsHeightByMaxCount - perItemsHeightByMaxCount / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                        }
                        
                    }else{
                        
                        CGSize size = [self sizeOfStringWithMaxSize:CGSizeMake(wid, model.maxCount * _minHeightItems) textFont:_tableTitleFont.pointSize aimString:rowItems];
                        
                        [self drawText:rowItems context:context atPoint:CGRectMake(lastX + wid / 2 - size.width / 2.0,  _lastY + model.maxCount * _minHeightItems - model.maxCount * _minHeightItems / 2.0 - size.height / 2.0, size.width, size.height) WithColor:_bodyTextColor font:_tableTitleFont];
                    }
                    lastX += wid;
                    
                    
                }
                _lastY += model.maxCount * _minHeightItems;
                
                
                
            }
        }
        
    }
}


/**
 *  绘图前数据构建
 */
- (void)configBaseData{
    _tableWidth = CGRectGetWidth(self.frame) - _beginSpace * 2;
    
    [self configColWidthArr];
    [self countTableHeight];
    
}


/**
 *  重构列数据
 */
- (void)configColWidthArr{
    
    CGFloat wid = 0;
    
    if (_colTitleArr.count>0&&_colTitleArr.count == _colWidthArr.count) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i<_colWidthArr.count; i++) {
            
            if (wid>_tableWidth) {
                arr = nil;
            }else{
                if (i==_colWidthArr.count-1) {
                    
                    [arr addObject:[NSNumber numberWithFloat:(_tableWidth - wid)]];
                }else
                    [arr addObject:_colWidthArr[i]];
                
            }
            wid += [_colWidthArr[i] floatValue];
        }
        _colWidthArr = [arr copy];
        
    }else{
        _colWidthArr = nil;
    }
    
}

/**
 *  计算表格总高度和表格体高度
 */
- (void)countTableHeight{
    
    NSInteger rowCount = 0;
    for (NSArray * itemsArr in _dataArr) {
        
        NSInteger nowCount = 1;
        
        for (id obj in itemsArr) {
            
            if ([obj isKindOfClass:[NSArray class]]) {
                
                if (nowCount<=[obj count]) {
                    nowCount = [obj count];
                }
                
            }
            
        }
        rowCount += nowCount;
    }
    
    _bodyHeight = rowCount * _minHeightItems  + (_colTitleArr.count>0?_minHeightItems:0);
    _tableHeight = 0;
    _tableHeight += (_tableTitleString.length>0?_tableChartTitleItemsHeight:0) + _bodyHeight;
}

/**
 *  绘制图形
 */
-(void)showAnimation{
    
    [self configBaseData];
    
    [self setNeedsDisplay];
    
    
    
    
}

/**
 *  返回该图表所需的高度
 *
 *  @return 高度
 */
- (CGFloat)heightFromThisDataSource{
    [self countTableHeight];
    return _tableHeight + _beginSpace * 2;
    
}

- (void)buttonTouch:(UIButton *)sender{

    NSString *text = [NSString stringWithFormat:@"%@",sender.titleLabel.text];
    [MBProgressHUD showText:text];
}

@end
