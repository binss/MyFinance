//
//  BINIncomeViewController.h
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface BINIncomeViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (strong,nonatomic) NSMutableArray *income;


@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *selectName;
@property (weak, nonatomic) IBOutlet UILabel *selectTotal;
@property (weak, nonatomic) IBOutlet UILabel *selectPercent;
@property (weak, nonatomic) IBOutlet UIImageView *showDetailPic;




- (void)setData: (NSMutableArray *) incomeData setState:(BOOL) fileExist;


@end
