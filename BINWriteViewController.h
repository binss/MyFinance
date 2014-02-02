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


@property (weak, nonatomic) IBOutlet UIPickerView *EventPicker;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UITextField *contentField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *incomeEventType;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)MainTypeSelected:(UISegmentedControl *)sender;



- (IBAction)EventTypeSelected:(UISegmentedControl *)sender;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)submitButtonPressed:(UIButton *)sender;




@end
