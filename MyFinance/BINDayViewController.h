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
@property (nonatomic,retain) NSArray *listImage;
//@property (strong,nonatomic) NSString *title;

- (void)setData:(NSString *) title withData:(NSMutableArray *) data;
@end
