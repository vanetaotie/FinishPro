//
//  SettingViewController.h
//  Finish
//
//  Created by vane on 14-4-10.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDSideMenu.h"

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,jdSideMenuDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, retain) UITableView *settingtableView;

@end