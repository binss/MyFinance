//
//  BINCalendarViewController.m
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINCalendarViewController.h"
#import "BINDayViewController.h"

@interface BINCalendarViewController ()

@end

@implementation BINCalendarViewController
@synthesize dictionary;
@synthesize filePath;

- (void)loadView
{
    UIView *appView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	calendarView = [[BINCalendar alloc] initWithFrame:appView.bounds fontName:@"AmericanTypewriter" delegate:self];
	
	self.view = appView;
	
	[self.view addSubview: calendarView];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self.navigationItem setHidesBackButton:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [self loadFile];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dayButtonPressed:(BINDayButton *)button
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:button.buttonDate];
    
    int year = [dateComponent year];
    int month = [dateComponent month];
    int day = [dateComponent day];

    NSString *date = [NSString stringWithFormat:@"%i-%i-%i",year,month,day];
    NSMutableArray * array = [dictionary objectForKey:date];

    
    self.hidesBottomBarWhenPushed = YES;
    BINDayViewController *dayView=[[BINDayViewController alloc] init];
    [self.navigationController pushViewController:dayView animated:YES];
    [dayView setData:date withFilePath:filePath withData:array];
    self.hidesBottomBarWhenPushed = NO;

}

- (void)nextButtonPressed
{
    NSLog(@"%d,%d",calendarView.getCurrentYear,calendarView.getCurrentMonth);
    [self loadFile];
}

- (void)prevButtonPressed
{
    NSLog(@"%d,%d",calendarView.getCurrentYear,calendarView.getCurrentMonth);
    [self loadFile];

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
    filePath = [self getDataFilePath:calendarView.getCurrentYear setMonth:calendarView.getCurrentMonth];
    
    //如果当前月份的文件存在，按内容更新界面内容
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSString *date;
        for(int i=1;i<=31;i++)
        {
            date = [NSString stringWithFormat:@"%i-%i-%i",calendarView.getCurrentYear,calendarView.getCurrentMonth,i];
            NSArray *dateList = [dictionary objectForKey:date];
            if(dateList != nil)
            {
                NSLog(@"%i",[dateList count]);
                if([dateList count])
                {
                    [calendarView setButtonColor:[UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1] dayIndex:i];
                    [calendarView setbuttonEnable:YES dayIndex:i];
                }
                else
                {
                    [calendarView setButtonColor:[UIColor clearColor] dayIndex:i];
                    [calendarView setbuttonEnable:NO dayIndex:i];
                }
            }
        }
        NSArray *income = [dictionary objectForKey:@"income"];
        NSArray *expense = [dictionary objectForKey:@"expense"];
        [calendarView setIncomeAndExpense:[income[[income count] - 1] floatValue] withExpense:[expense[[expense count] - 1] floatValue]];
    
    }
    else
    {
        NSLog(@"找不到当前月份的文件");
        [calendarView setIncomeAndExpense:0 withExpense:0];
    }
}




@end
