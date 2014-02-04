//
//  BINMainViewController.h
//  MyFinance
//
//  Created by bin on 14-2-2.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "BINExpenseViewController.h"

@interface BINMainViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>

@property float thisMonthIncome;
@property float thisMonthExpense;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *expense;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartIncome;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartExpense;

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;


- (IBAction)incomeDetailButtonPressed:(id)sender;

@end
