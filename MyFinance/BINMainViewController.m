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
//    UIViewController *vc1=[[UIViewController alloc] init];

    
    
    
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (resetData:) name:@"resetData" object:nil];
    [self loadFile];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetData" object:nil];
    
    
    self.slices = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0; i < 5; i ++)
    {
//        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        NSNumber *one = [NSNumber numberWithInt:20];
        [self.slices addObject:one];
    }
    
    self.sliceColors = [NSArray arrayWithObjects:
                        [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                        [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                        [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                        [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                        [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    [self.pieChartIncome setDelegate:self];
    [self.pieChartIncome setDataSource:self];
    [self.pieChartIncome setStartPieAngle:M_PI_2];
    [self.pieChartIncome setAnimationSpeed:1.0];
    [self.pieChartIncome setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChartIncome setLabelRadius:50];
    [self.pieChartIncome setShowPercentage:YES];
    [self.pieChartIncome setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
//    [self.pieChartIncome setPieCenter:CGPointMake(240, 240)];
    [self.pieChartIncome setUserInteractionEnabled:YES];
    
    [self.pieChartIncome reloadData];

    
//    [self.pieChartRight setDelegate:self];
//    [self.pieChartRight setDataSource:self];
//    [self.pieChartRight setPieCenter:CGPointMake(240, 240)];
//    [self.pieChartRight setShowPercentage:NO];
    
    

    
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
        NSString *Tincome = [dictionary objectForKey:@"income"];
        NSString *Texpense = [dictionary objectForKey:@"expense"];
        thisMonthIncome = Tincome.floatValue;
        thisMonthExpense = Texpense.floatValue;
    }
    else
    {
        thisMonthIncome = 0;
        thisMonthExpense = 0;
    }
    
}

- (void)resetData:(NSNotification *) notification
{
    self.income.text = [NSString stringWithFormat:@"%.2f",thisMonthIncome];
    self.expense.text = [NSString stringWithFormat:@"%.2f",thisMonthExpense];
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
    NSLog(@"did select slice at index %d",index);
    //显示相关的内容～～～
//    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}





- (IBAction)incomeDetailButtonPressed:(id)sender
{
    NSLog(@"call");
    BINExpenseViewController *vc2=[[BINExpenseViewController alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];
//    [self presentModalViewController:vc2 animated:YES];
}
@end
