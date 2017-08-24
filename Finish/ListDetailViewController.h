//
//  ListDetailViewController.h
//  Finish
//
//  Created by vane on 14-3-20.
//  Copyright (c) 2014年 vane.greenisland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListDetailViewController;
@class ListBox;

@protocol ListDetailViewControllerDelegate <NSObject>
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(ListBox *)checklist;
- (void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(ListBox *)checklist;
@end

@interface ListDetailViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, weak) id <ListDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) ListBox *listToEdit;//切换编辑界面

@end
