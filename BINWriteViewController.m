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

@synthesize currentFilePath;
@synthesize year;
@synthesize month;
@synthesize day;
@synthesize hour;
@synthesize minute;
@synthesize type;

//注：数组的尾行为整数
@synthesize income;
@synthesize expense;




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
    
    
    //数据初始化
    type = @"expense";
    [self resetTime];
    [self loadFile];

    

}

- (void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
            type = @"expense";
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
            type = @"income";
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
            type = @"other";
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
    
    NSString *content;
    float temp;
    int totalRow;
    if(![type compare:@"expense"])
    {
        content = [[NSString alloc] initWithFormat:@"%@_%i:%@_%@_%@_%.2f_%@",type,hour,minute,thingSelected,detailSelected,self.moneyField.text.floatValue,self.contentField.text];
        
        totalRow = [expense count] -1;
        temp = [expense[thingRow] floatValue] + self.moneyField.text.floatValue;
        [expense replaceObjectAtIndex:thingRow withObject:[NSNumber numberWithFloat:temp]];
        temp = [expense[totalRow] floatValue] + self.moneyField.text.floatValue;
        [expense replaceObjectAtIndex:totalRow withObject:[NSNumber numberWithFloat:temp]];
    }
    
    NSString *incomeType;
    if(![type compare:@"income"])
    {
        switch(self.incomeEventType.selectedSegmentIndex)
        {
            case 0: incomeType = @"出粮";break;
            case 1: incomeType = @"提款";break;
            case 2: incomeType = @"收益";break;
        }
        content = [[NSString alloc] initWithFormat:@"%@_%i:%@_%@_%.2f_%@",type,hour,minute,incomeType,
                   self.moneyField.text.floatValue,self.contentField.text];
        totalRow = [income count] -1;

        temp = [income[self.incomeEventType.selectedSegmentIndex] floatValue] + self.moneyField.text.floatValue;
        [income replaceObjectAtIndex:self.incomeEventType.selectedSegmentIndex withObject:[NSNumber numberWithFloat:temp]];
        temp = [income[totalRow] floatValue] + self.moneyField.text.floatValue;
        [income replaceObjectAtIndex:totalRow withObject:[NSNumber numberWithFloat:temp]];

    }
    
    if(![type compare:@"other"])
    {
        content = [[NSString alloc] initWithFormat:@"%@_%i:%@_%@",type,hour,minute,self.otherContentField.text];
    }
    
    [self writeFile:content];
    [self resetContent];
    [self resetTime];

    
}

- (IBAction)resetButtonPressed:(UIButton *)sender
{
    [self resetContent];
    [self resetTime];
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

//---------逻辑部分
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
    
    year = [dateComponent year];
    month = [dateComponent month];
    day = [dateComponent day];
    hour = [dateComponent hour];
    int tempMinute = [dateComponent minute];
    
    if(tempMinute < 10)
        minute = [NSString stringWithFormat:@"0%i",tempMinute];
    else
        minute = [NSString stringWithFormat:@"%i",tempMinute];

    
    self.timeLabel.text = [[NSString alloc] initWithFormat:@"%i年%i月%i日 %i:%@",year,month,day,hour,minute];

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
    NSString *filePath = [self getDataFilePath:year setMonth:month];

    //该月份事件的字典
    NSMutableDictionary *dictionary;

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])     //如果存在
    {
        dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSMutableArray *incomeList = [dictionary objectForKey:@"income"];
        NSMutableArray *expenseList = [dictionary objectForKey:@"expense"];
        
        income = incomeList;
        expense = expenseList;
    }
    else
    {
        NSNumber *zero=[NSNumber numberWithFloat:0.00];
        income = [[NSMutableArray alloc] initWithObjects:zero,zero,zero,zero,nil];
        expense = [[NSMutableArray alloc] initWithObjects:zero,zero,zero,zero,zero,zero,nil];
    }

}

- (void)writeFile:(NSString *)thing
{
    //获取字典路径
    NSString *filePath = [self getDataFilePath:year setMonth:month];
    NSLog(@"%@",filePath);
    
    //该月份事件的字典
    NSMutableDictionary *dictionary;
    //该天事件的数组
    NSMutableArray *thingList;
    
    NSString * key = [[NSString alloc] initWithFormat:@"%i-%i-%i",year,month,day];

    //检测文件(字典)是否存在，如果不存在，则新建
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])     //如果存在
    {
        dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath ];
        thingList = [dictionary objectForKey:key];
        
        //如果该天的数组不存在，则新建
        if(thingList == NULL)
        {
            thingList = [NSMutableArray arrayWithCapacity:1];
            NSLog(@"Creat");
        }
    }
    else
    {
        NSLog(@"creat file");
        dictionary = [NSMutableDictionary dictionaryWithCapacity:40];
        thingList = [NSMutableArray arrayWithCapacity:1];

    }
    //把事件(string)添加入数组中
    [thingList addObject:thing];

    //把数组写入字典中
    [dictionary setObject:thingList forKey:key];

    //把收入和支出写入字典中
    [dictionary setObject:income forKey:@"income"];
    [dictionary setObject:expense forKey:@"expense"];
    
    //把字典写入文件中
    [dictionary writeToFile:filePath atomically:YES];
    
    //发送消息，更新主界面信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetData" object:nil];

}





@end
