//
//  ListItemViewController.h
//  Finish
//
//  Created by vane on 14-3-19.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
#import "ListItemCell.h"

@class DataModel;
@class ListBox;

@interface ListItemViewController : UITableViewController<itemDetailViewControllerDelegate,UIGestureRecognizerDelegate,ListItemCellDelegate>

@property (nonatomic,strong) DataModel *dataModel;
@property (nonatomic,strong) ListBox *checklist;

@end
