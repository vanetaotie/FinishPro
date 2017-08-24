//
//  ScheduleViewController.h
//  Finish
//
//  Created by vane on 14-4-7.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JDSideMenu.h"
#import "JBUnitView.h"

@class DataModel;

@interface ScheduleViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,jdSideMenuDelegate,UIScrollViewDelegate,JBUnitGridViewDelegate, JBUnitGridViewDataSource, JBUnitViewDelegate, JBUnitViewDataSource>

@property (nonatomic, retain) JBUnitView *unitView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) DataModel *dataModel;

@end
