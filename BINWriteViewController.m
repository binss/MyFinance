//
//  BINWriteViewController.m
//  MyFinance
//
//  Created by bin on 14-2-2.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINWriteViewController.h"

@interface BINWriteViewController ()

@end

@implementation BINWriteViewController





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


    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"thingsDictionary"withExtension:@"plist"];
    //加载thingsDictionary.plist
    self.detailNamesDictionary = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    
    //获取字典中的所有键，存入allThingNames数组
    NSArray *allThingNames = [self.detailNamesDictionary allKeys];
    //对allThingNames按字母顺序排序

    //对所有键按汉语拼音首字母进行排序
    NSArray *sortedThingNames=[allThingNames sortedArrayUsingComparator:^(id a, id b)
    {
        //获取字符串长度，取两者的最小值
        int len = [a length] > [b length]? [b length]:[a length];
        NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_hans"];
        //按localizedCompare进行字符串比较，得出结果
        NSComparisonResult ret = [a compare:b options:NSCaseInsensitiveSearch range:NSMakeRange(0, len) locale:local];
        return ret;
    }];
    
    self.thingNames = sortedThingNames;
    NSInteger row = [self.thingNames count]/2;

    //默认设定右侧组件的内容为左侧组件当前行（索引为row）的数据
    NSString *selectedThingName = self.thingNames[row];
    //设置右侧组件内容数组
    self.detailNames = self.detailNamesDictionary[selectedThingName];
    //左侧组件选中第row行
    [self.EventPicker selectRow:row inComponent:0 animated:NO];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [self resetTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)MainTypeSelected:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
        {
            self.EventPicker.hidden = NO;
            self.TypeLabel.hidden = NO;
            self.TypeLabel.text = @"支出：";
            self.moneyField.hidden = NO;
            self.contentLabel.hidden = NO;
            self.contentField.hidden = NO;
            self.incomeEventType.hidden = YES;
            self.otherContentLabel.hidden = YES;
            self.otherContentField.hidden = YES;
            [self resetContent];
            break;
        }
        case 1:
        {
            self.EventPicker.hidden = YES;
            self.TypeLabel.hidden = NO;
            self.TypeLabel.text = @"收入：";
            self.moneyField.hidden = NO;
            self.contentLabel.hidden = NO;
            self.contentField.hidden = NO;
            self.incomeEventType.hidden = NO;
            self.otherContentLabel.hidden = YES;
            self.otherContentField.hidden = YES;
            [self resetContent];
            break;
        }
        case 2:
        {
            self.EventPicker.hidden = YES;
            self.TypeLabel.hidden = YES;
            self.moneyField.hidden = YES;
            self.contentLabel.hidden = YES;
            self.contentField.hidden = YES;
            self.incomeEventType.hidden = YES;
            self.otherContentLabel.hidden = NO;
            self.otherContentField.hidden = NO;
            [self resetContent];
            break;
        }
    }
}

- (IBAction)EventTypeSelected:(UISegmentedControl *)sender
{
}

- (IBAction)backgroundTap:(id)sender
{
    [self.moneyField resignFirstResponder];
    [self.contentField resignFirstResponder];
    [self.otherContentField resignFirstResponder];
    [self resumeView];

}

- (IBAction)submitButtonPressed:(UIButton *)sender
{
    NSInteger thingRow = [self.EventPicker selectedRowInComponent:0];
    NSInteger detailRow = [self.EventPicker selectedRowInComponent:1];
    
    NSString *thingSelected = self.thingNames[thingRow];
    NSString *detailSelected = self.detailNames[detailRow];

    NSString *title = [[NSString alloc] initWithFormat:@"%@ %@!",thingSelected,detailSelected];
    NSLog(@"%@",title);
    
}

- (IBAction)resetButtonPressed:(UIButton *)sender
{
    [self resetContent];
    [self resetTime];
}

- (void)resetContent
{
    self.moneyField.text = @"";
    self.contentField.text = @"";
    self.incomeEventType.selectedSegmentIndex = 0;
    self.otherContentField.text = @"点击此处输入要记录的事项内容";
    
    
}

- (void)resetTime
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = [dateComponent year];
    int month = [dateComponent month];
    int day = [dateComponent day];
    int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    
    self.timeLabel.text = [[NSString alloc] initWithFormat:@"%i年%i月%i日 %i:%i",year,month,day,hour,minute];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;           //设定选取器有两个组件
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return [self.thingNames count];
    else
        return [self.detailNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
        return self.thingNames[row];
    else
        return self.detailNames[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //当左侧选取器改变时，右侧选取器作出相应变化
    if(component == 0)
    {
        //获取左侧选取器中所选中的string
        NSString * selectedThingName = self.thingNames[row];
        //从字典中取出键为左侧选取器中所选中的值，保存入数组中
        self.detailNames = self.detailNamesDictionary[selectedThingName];
        //重新加载右侧选取器
        [self.EventPicker reloadComponent:1];
        [self.EventPicker selectRow:0 inComponent:1 animated:YES];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-150,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES; 
}

-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为0，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
@end
