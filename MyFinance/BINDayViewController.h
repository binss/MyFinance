//
//  BINDayViewController.h
//  MyFinance
//
//  Created by bin on 14-2-6.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINDayViewController : UITableViewController

@property (nonatomic,retain) NSMutableArray *listData;

@property (strong,nonatomic) NSMutableArray *incomeList;
@property (strong,nonatomic) NSMutableArray *expenseList;
@property (strong,nonatomic) NSMutableArray *otherList;

@property (strong,nonatomic) NSMutableArray *incomeListIndex;
@property (strong,nonatomic) NSMutableArray *expenseListIndex;
@property (strong,nonatomic) NSMutableArray *otherListIndex;

@property (nonatomic,retain) NSMutableIndexSet *delectListIndex;



@property (strong,nonatomic) NSMutableArray *sections;

@property (strong,nonatomic) NSArray *listImage;
@property (strong,nonatomic) NSString *filePath;

@property (strong,nonatomic) NSMutableArray * income;
@property (strong,nonatomic) NSMutableArray * expense;



//@property (strong,nonatomic) NSString *title;


- (void)setData:(NSString *) title withFilePath:(NSString *) path withData:(NSMutableArray *) data;
@end
