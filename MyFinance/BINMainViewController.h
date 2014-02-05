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
#import "BINIncomeViewController.h"

@interface BINMainViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>

@property float thisMonthIncome;
@property float thisMonthExpense;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartIncome;
@property (strong, nonatomic) IBOutlet XYPieChart *pieChartExpense;

@property(nonatomic, strong) NSMutableArray *incomeSlices;
@property(nonatomic, strong) NSArray        *incomeSliceColors;
@property(nonatomic, strong) NSMutableArray *expenseSlices;
@property(nonatomic, strong) NSArray        *expenseSliceColors;

@property (strong,nonatomic) NSMutableArray * income;
@property (strong,nonatomic) NSMutableArray * expense;

@property bool fileExist;

- (IBAction)incomeDetailButtonPressed:(UIButton *)sender;
- (IBAction)expenseDetailButtonPressed:(UIButton *)sender;


@end
