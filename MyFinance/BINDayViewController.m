//
//  BINDayViewController.m
//  MyFinance
//
//  Created by bin on 14-2-6.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import "BINDayViewController.h"

@interface BINDayViewController ()

@end

@implementation BINDayViewController
@synthesize listData;
@synthesize incomeList;
@synthesize expenseList;
@synthesize otherList;
@synthesize incomeListIndex;
@synthesize expenseListIndex;
@synthesize otherListIndex;
@synthesize delectListIndex;

@synthesize sections;
@synthesize filePath;
@synthesize income;
@synthesize expense;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
//        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    sections = [[NSMutableArray alloc] initWithObjects:@"收入",@"支出",@"其他",nil];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    //如果检测到当天列表被修改，则重写文件
    if([delectListIndex count])
    {        
        [listData removeObjectsAtIndexes:delectListIndex];
        
        //再次检查文件是否存在
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath ];
            
            
            //把数组写入字典中
            [dictionary setObject:listData forKey:self.title];
            
            //把收入和支出写入字典中
            [dictionary setObject:income forKey:@"income"];
            [dictionary setObject:expense forKey:@"expense"];
            
            //把字典写入文件中
            [dictionary writeToFile:filePath atomically:YES];
            
            //更新主界面信息
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetData" object:nil];

        }
        else
        {
            NSLog(@"文件已被删除");

        }
        
    }
    
}

- (void)setData:(NSString *)title withFilePath:(NSString *)path withData:(NSMutableArray *)data
{
    self.title = title;
    filePath = path;
    listData = data;
    incomeList = [[NSMutableArray alloc] initWithCapacity:10];
    expenseList = [[NSMutableArray alloc] initWithCapacity:10];
    otherList = [[NSMutableArray alloc] initWithCapacity:10];

    incomeListIndex = [[NSMutableArray alloc] initWithCapacity:10];
    expenseListIndex = [[NSMutableArray alloc] initWithCapacity:10];
    otherListIndex = [[NSMutableArray alloc] initWithCapacity:10];
    
    delectListIndex = [[NSMutableIndexSet alloc] init];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])     //如果存在
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        income = [dictionary objectForKey:@"income"];
        expense = [dictionary objectForKey:@"expense"];
    }

    bool null_tag1 = YES;
    bool null_tag2 = YES;
    bool null_tag3 = YES;


    for(int i=0;i<[listData count];i++)
    {
        NSString *str = listData[i];
        NSArray *array=[str componentsSeparatedByString:@"_"];
        str = array[0];
        if(![str compare:@"income"])
        {
            NSString *temp = [NSString stringWithFormat:@"%@  %@  金额：%@",array[1],array[2],array[3]];
            [incomeList addObject:temp];
            [incomeListIndex addObject:[NSNumber numberWithInteger:i]];
            null_tag1 = NO;
        }
        if(![str compare:@"expense"])
        {
            NSString *temp = [NSString stringWithFormat:@"%@  %@  %@  金额：%@",array[1],array[2],array[3],array[4]];
            [expenseList addObject:temp];
            [expenseListIndex addObject:[NSNumber numberWithInteger:i]];
            null_tag2 = NO;
        }
        if(![str compare:@"other"])
        {
            NSString *temp = [NSString stringWithFormat:@"%@  %@",array[1],array[2]];
            [otherList addObject:temp];
            [otherListIndex addObject:[NSNumber numberWithInteger:i]];
            null_tag3 = NO;
        }
    }
    

    //如果当前分组为空，则填充"无记录"
    if(null_tag1)
    {
        [incomeList addObject:[NSString stringWithFormat:@"无记录"]];
        [incomeListIndex addObject:[NSNumber numberWithInteger:-1]];
    }
    if(null_tag2)
    {
        [expenseList addObject:[NSString stringWithFormat:@"无记录"]];
        [expenseListIndex addObject:[NSNumber numberWithInteger:-1]];
    }
    if(null_tag3)
    {
        [otherList addObject:[NSString stringWithFormat:@"无记录"]];
        [otherListIndex addObject:[NSNumber numberWithInteger:-1]];

    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    int row;
    switch (section)
    {
        case 0:
            row = [incomeList count];
            break;
        case 1:
            row = [expenseList count];
            break;
        case 2:
            row = [otherList count];
            break;
    }
    
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray *temp;
    switch (section)
    {
        case 0:
            temp = incomeList;
            break;
        case 1:
            temp = expenseList;
            break;
        case 2:
            temp = otherList;
            break;
    }
    cell.textLabel.text = [temp objectAtIndex:row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = [sections objectAtIndex:section];
    return sectionName;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];

    //用指针指向要修改的列表和索引列表
    NSMutableArray *tempList;
    NSMutableArray *tempIndex;
    switch (section)
    {
        case 0:
        {
            tempList = incomeList;
            tempIndex = incomeListIndex;
            break;
        }
        case 1:
        {
            tempList = expenseList;
            tempIndex = expenseListIndex;
            break;
        }
        case 2:
        {
            tempList = otherList;
            tempIndex = otherListIndex;
            break;
        }
    }
    
    //如果要删除的记录不是"无记录"(-1)，则:
    int index = [tempIndex[row] intValue];
    if( index != -1)
    {
        //1.把这个记录的索引加入的delectList中
        [delectListIndex addIndex:index];
        //2.删除索引列表中的索引
        [tempIndex removeObjectAtIndex:row];
        
        //3.截取记录信息，修改income和expense数组
        NSString *type = listData[index];
        NSArray *array=[type componentsSeparatedByString:@"_"];
        //记录类型关键字
        type = array[2];
        //typeNum为类型对应的行号
        int totalRow;
        int typeNum;
        switch (section)
        {
            case 0:
            {
                if(![type compare:@"出粮"])
                    typeNum = 0;
                if(![type compare:@"提款"])
                    typeNum = 1;
                if(![type compare:@"收益"])
                    typeNum = 2;
                NSLog(@"%i",typeNum);
                totalRow = [income count] -1;
                float money = [income[typeNum] floatValue] - [array[3] floatValue];
                [income replaceObjectAtIndex:typeNum withObject:[NSNumber numberWithFloat:money]];
                money = [income[totalRow] floatValue] - [array[3] floatValue];
                [income replaceObjectAtIndex:totalRow withObject:[NSNumber numberWithFloat:money]];
                break;
            }
            case 1:
            {
                if(![type compare:@"吃饭"])
                    typeNum = 0;
                if(![type compare:@"购物"])
                    typeNum = 1;
                if(![type compare:@"交通"])
                    typeNum = 2;
                if(![type compare:@"网购"])
                    typeNum = 3;
                if(![type compare:@"娱乐"])
                    typeNum = 4;
                totalRow = [expense count] -1;
                float money = [expense[typeNum] floatValue] - [array[4] floatValue];
                [expense replaceObjectAtIndex:typeNum withObject:[NSNumber numberWithFloat:money]];
                money = [expense[totalRow] floatValue] - [array[4] floatValue];
                [expense replaceObjectAtIndex:totalRow withObject:[NSNumber numberWithFloat:money]];
                break;
            }

        }
    }
    

    //删除数据源
    [tempList removeObjectAtIndex:row];
    
    //更新视图
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //检查数组是否为空，如果为空，插入"无记录"并更新视图
    if([tempList count] == 0)
    {
        [tempList addObject:[NSString stringWithFormat:@"无记录"]];
        [tempIndex addObject:[NSNumber numberWithInteger:-1]];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

@end
