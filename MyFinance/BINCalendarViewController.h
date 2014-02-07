//
//  BINCalendarViewController.h
//  MyFinance
//
//  Created by bin on 14-2-5.
//  Copyright (c) 2014年 bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BINCalendar.h"

@interface BINCalendarViewController : UIViewController <BINCalendarDelegate>
{
    BINCalendar *calendarView;
}
@property  (strong,nonatomic) NSMutableDictionary *dictionary;
@property  (strong,nonatomic) NSString *filePath;


@end
