//
//  BINWriteViewController.h
//  MyFinance
//
//  Created by bin on 14-2-2.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BINWriteViewController : UIViewController
<UIPickerViewDelegate,UIPickerViewDataSource>


@property (strong,nonatomic) NSArray * thingNames;
@property (strong,nonatomic) NSArray * detailNames;
@property (strong,nonatomic) NSDictionary * detailNamesDictionary;

//重要属性
@property (strong,nonatomic) NSString * currentFilePath;

@property int year;
@property int month;
@property int day;
@property int hour;
@property NSString * minute;

@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *content;

//@property float income;
@property (strong,nonatomic) NSMutableArray * income;
@property (strong,nonatomic) NSMutableArray * expense;


//支出的相关组件
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *EventPicker;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentField;

//收入的相关组件
@property (weak, nonatomic) IBOutlet UISegmentedControl *incomeEventType;

//其他的相关组件
@property (weak, nonatomic) IBOutlet UILabel *otherContentLabel;
@property (weak, nonatomic) IBOutlet UITextView *otherContentField;


- (IBAction)MainTypeSelected:(UISegmentedControl *)sender;




- (IBAction)backgroundTap:(id)sender;
- (IBAction)submitButtonPressed:(UIButton *)sender;
- (IBAction)resetButtonPressed:(UIButton *)sender;





@end
