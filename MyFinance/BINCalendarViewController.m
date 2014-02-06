//
//  BINCalendarViewController.m
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINCalendarViewController.h"

@interface BINCalendarViewController ()

@end

@implementation BINCalendarViewController
@synthesize dictionary;

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

}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadFile];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

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
    
    BINDayViewController *dayView=[[BINDayViewController alloc] init];
    [self.navigationController pushViewController:dayView animated:YES];
    [dayView setData:date withData:array];
}

- (void)nextButtonPressed
{
	NSLog(@"Next...");
    NSLog(@"%d,%d",calendarView.getCurrentYear,calendarView.getCurrentMonth);
    [self loadFile];
}

- (void)prevButtonPressed
{
	NSLog(@"Prev...");
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
    NSString *filePath = [self getDataFilePath:calendarView.getCurrentYear setMonth:calendarView.getCurrentMonth];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])     //如果存在
    {
        dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSString *date;
        for(int i=1;i<=31;i++)
        {
            date = [NSString stringWithFormat:@"%i-%i-%i",calendarView.getCurrentYear,calendarView.getCurrentMonth,i];
            if([dictionary objectForKey:date] != nil)
            {
                [calendarView setButtonColor:i];
            }
        }
    
    }
    else
    {
        NSLog(@"找不到当前月份的文件");
    }
}




@end
