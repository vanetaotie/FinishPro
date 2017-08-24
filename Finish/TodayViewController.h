//
//  TodayViewController.h
//  Finish
//
//  Created by vane on 14-3-27.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

/**********************
 今日待办，明日待办重用该类
***********************/
#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
#import "JDSideMenu.h"
#import "ListItemCell.h"

@class DataModel;

@interface TodayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,itemDetailViewControllerDelegate,UIGestureRecognizerDelegate,jdSideMenuDelegate,UIScrollViewDelegate,ListItemCellDelegate>

@property (nonatomic, retain) UITableView *todayTableView;
@property (nonatomic,strong) DataModel *dataModel;
@property (nonatomic,assign) BOOL isTomorrow;

- (NSInteger)countUnFinishTodayItems;
- (NSInteger)countUnFinishTomorrowItems;

@end