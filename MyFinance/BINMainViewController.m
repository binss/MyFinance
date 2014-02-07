//
//  BINMainViewController.m
//  MyFinance
//
//  Created by bin on 14-2-2.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINMainViewController.h"

@interface BINMainViewController ()

@end

@implementation BINMainViewController
@synthesize thisMonthIncome;
@synthesize thisMonthExpense;
@synthesize income;
@synthesize expense;
@synthesize fileExist;


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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    

    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (resetData:) name:@"resetData" object:nil];
    
    NSNumber *zero = [NSNumber numberWithFloat:0.0];

    self.incomeSlices = [[NSMutableArray alloc] initWithObjects:zero,zero,zero,nil];
    
    self.expenseSlices = [[NSMutableArray alloc] initWithObjects:zero,zero,zero,zero,zero,nil];
    
    self.incomeSliceColors = [NSArray arrayWithObjects:
                        [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                        [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                        [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                        [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                        [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    self.expenseSliceColors = [NSArray arrayWithObjects:
                               [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                               [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                               [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                               [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                               [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];

    
    //income 图表初始化
    
    [self.pieChartIncome setDelegate:self];
    [self.pieChartIncome setDataSource:self];
    [self.pieChartIncome setStartPieAngle:M_PI_2];
    [self.pieChartIncome setAnimationSpeed:1.0];
    [self.pieChartIncome setShowLabel:NO];
    [self.pieChartIncome setShowPercentage:YES];
    [self.pieChartIncome setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChartIncome setUserInteractionEnabled:NO];
    
    
    //expense 图表初始化

    
    [self.pieChartExpense setDelegate:self];
    [self.pieChartExpense setDataSource:self];
    [self.pieChartExpense setStartPieAngle:M_PI_2];
    [self.pieChartExpense setAnimationSpeed:1.0];
    [self.pieChartExpense setShowLabel:NO];
    [self.pieChartExpense setShowPercentage:YES];
    [self.pieChartExpense setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChartExpense setUserInteractionEnabled:NO];
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetData" object:nil];

    

}

- (void)viewWillAppear:(BOOL)animated
{
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.pieChartIncome reloadData];
    [self.pieChartExpense reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getDataFilePath:(int)Tyear setMonth:(int)Tmonth
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *name = [[NSString alloc] initWithFormat:@"data_%i_%i.plist",Tyear,Tmonth];
    
    return [documentsDirectory stringByAppendingPathComponent:name];
}

- (void)loadFile
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:now];

    NSString *filePath = [self getDataFilePath:[dateComponent year] setMonth:[dateComponent month]];
    
    self.date.text = [NSString stringWithFormat:@"%i年%i月",[dateComponent year],[dateComponent month]];
    
    //该月份事件的字典
    NSMutableDictionary *dictionary;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])     //如果存在
    {
        dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        income = [dictionary objectForKey:@"income"];
        expense = [dictionary objectForKey:@"expense"];
        thisMonthIncome = [income[[income count] - 1] floatValue];
        thisMonthExpense = [expense[[expense count] - 1] floatValue];
        fileExist = YES;
    }
    else
    {
        thisMonthIncome = 0;
        thisMonthExpense = 0;
        fileExist = NO;
    }
    
}

- (void)resetData:(NSNotification *) notification
{
    [self loadFile];
    //label数据更新
    self.incomeLabel.text = [NSString stringWithFormat:@"%.2f",thisMonthIncome];
    self.expenseLabel.text = [NSString stringWithFormat:@"%.2f",thisMonthExpense];
    
    if(fileExist)
    {
        //income 图表数据更新
        for(int i = 0; i < 3; i ++)
        {
            NSNumber *temp = [NSNumber numberWithFloat:[income[i] floatValue]];
            [self.incomeSlices replaceObjectAtIndex:i withObject:temp];
        }
        
        //expense 图表数据更新
        for(int i = 0; i < 5; i ++)
        {
            NSNumber *temp = [NSNumber numberWithInt:[expense[i] floatValue]];
            [self.expenseSlices replaceObjectAtIndex:i withObject:temp];
        }

    }

}

- (IBAction)incomeDetailButtonPressed:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    BINIncomeViewController *incomeView=[[BINIncomeViewController alloc] init];
    [self.navigationController pushViewController:incomeView animated:YES];
    [incomeView setData:income setState:fileExist];
    self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)expenseDetailButtonPressed:(UIButton *)sender
{
    self.hidesBottomBarWhenPushed = YES;
    BINExpenseViewController *expenseView=[[BINExpenseViewController alloc] init];
    [self.navigationController pushViewController:expenseView animated:YES];
    [expenseView setData:expense setState:fileExist];
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    if(pieChart == self.pieChartIncome)
        return self.incomeSlices.count;
    else
        return self.expenseSlices.count;

}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    if(pieChart == self.pieChartIncome)
        return [[self.incomeSlices objectAtIndex:index] intValue];
    else
        return [[self.expenseSlices objectAtIndex:index] intValue];

}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    if(pieChart == self.pieChartIncome)
        return [self.incomeSliceColors objectAtIndex:(index % self.incomeSliceColors.count)];
    else
        return [self.expenseSliceColors objectAtIndex:(index % self.expenseSliceColors.count)];

}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %d",index);
}










@end
