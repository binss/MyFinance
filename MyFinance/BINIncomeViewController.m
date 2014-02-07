//
//  BINIncomeViewController.m
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINIncomeViewController.h"

@interface BINIncomeViewController ()

@end

@implementation BINIncomeViewController
@synthesize income;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收入统计";
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    
    
    self.sliceColors = [NSArray arrayWithObjects:
                        [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                        [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                        [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                        [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                        [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    [self.pieChart setAnimationSpeed:1.0];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];
    [self.pieChart setLabelRadius:60];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setUserInteractionEnabled:YES];
    
    [self.selectTotal setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];
    [self.selectPercent setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:20]];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self.pieChart reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData:(NSMutableArray *)incomeData setState:(BOOL)fileExist
{
    self.slices = [NSMutableArray arrayWithCapacity:5];
    income = incomeData;
    if(fileExist)
    {
        //图表数据更新
        for(int i = 0; i < 3; i ++)
        {
            NSNumber *temp = [NSNumber numberWithFloat:[income[i] floatValue]];
            [self.slices addObject:temp];
        }
        
    }
}



#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    //    if(pieChart == self.pieChartRight) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    self.showDetailPic.hidden = YES;
    UIColor * color;

    switch (index)
    {
        case 0:
        {
            self.selectName.text = @"出粮";
            color = [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1];
            break;
        }
        case 1:
        {
            self.selectName.text = @"提款";
            color = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
            break;
        }
        case 2:
        {
            self.selectName.text = @"收益";
            color = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
            break;
        }
    }
    [self.selectName setTextColor:color];
    [self.selectTotal setTextColor:color];
    [self.selectPercent setTextColor:color];

    self.selectTotal.text = [NSString stringWithFormat:@"金额：%.2f",[income[index] floatValue]];
    self.selectPercent.text = [NSString stringWithFormat:@"占比：%.2f%%",[income[index] floatValue] * 100/[income[3] floatValue]];
    
}

@end
