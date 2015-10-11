//
//  TaskBoxViewController.h
//  Finish
//
//  Created by vane on 14-4-11.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

/*******************************************
任务，心愿单，购物清单，读书清单，观影清单均重用该类
********************************************/
#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
#import "JDSideMenu.h"
#import "ListItemCell.h"

@class DataModel;
@class ListBox;

@interface TaskBoxViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,itemDetailViewControllerDelegate,UIGestureRecognizerDelegate,jdSideMenuDelegate,UIScrollViewDelegate,ListItemCellDelegate>

@property (nonatomic,strong) DataModel *dataModel;
@property (nonatomic,strong) ListBox *checklist;
@property (nonatomic, retain) UITableView *taskBoxTableView;
@property (nonatomic, assign) NSInteger tipLable;//用于区分“任务”，“心愿单”等

- (NSInteger)countUnFinishItems;

@end
