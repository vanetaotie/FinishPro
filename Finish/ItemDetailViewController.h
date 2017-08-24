//
//  ItemDetailViewController.h
//  Finish
//
//  Created by vane on 14-3-20.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBCustomDatePickerView.h"

@class ItemDetailViewController;
@class ListItem;

@protocol itemDetailViewControllerDelegate <NSObject>
@optional
- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ListItem *)item;
@required
- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ListItem *)item;
@end

@interface ItemDetailViewController : UIViewController<UITextFieldDelegate,RBCustomDatePickerViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, retain) UITableView *detailTableView;
@property (nonatomic, weak) id <itemDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) ListItem *itemToEdit;//切换编辑界面

@end
