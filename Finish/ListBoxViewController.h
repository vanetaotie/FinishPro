//
//  ListBoxViewController.h
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDSideMenu.h"

@class DataModel;

@interface ListBoxViewController : UITableViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,jdSideMenuDelegate>

@property (nonatomic,strong) DataModel *dataModel;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizerList;//列表界面的拖动手势

@end